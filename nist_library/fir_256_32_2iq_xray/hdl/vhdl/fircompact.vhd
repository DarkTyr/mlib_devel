-------------------------------------------------------------------------------
-- Title      : decimating FIR -- compact implementation
-- Project    : 
-------------------------------------------------------------------------------
-- File       : fircompact.vhd
-- Author     : jozsef imrek  <jozsef.imrek@nist.gov>
-- Company    : 
-- Created    : 2019-02-11
-- Last update: 2019-05-17
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: compact (and low performance) decimating FIR
--
-- generic VHDL version, targeting xilinx architecture.
--
-- synthesis and translate are expected to recognize BRAM and DSP instantiations,
-- including dedicated cascading (DOUT/DIN for BRAM, PCOUT/PCIN for DSP).
--
-- decimation factor and block (FIR) length are hardcoded as constants.
-- coefficient values are hard coded in coefrom.vhd.
-- input, output, and coefficient SLVs are interpretted as signed values.
--
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Author  Description
-- 2019-02-11  mazsi   Created
-- 2019-08-19  mazsi   add reset to address counter to improve timing (haha)
--                     set max fanout + keep attributes on addr0 (xilinx)
--                     set max fanout + keep attributes on addr0 (synopsys)
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;





entity fircompact is

  generic (
    DWIDTH : positive := 16             -- input data width
    );

  port (
    ---------------------------------------------------------------------------
    CLK     : in  std_logic;
    RST     : in  std_logic;
    SELBITS : in  std_logic_vector(0 downto 0)  := (others => '0');
    PCIN    : in  std_logic_vector(47 downto 0) := (others => '0');
    D       : in  std_logic_vector(DWIDTH - 1 downto 0);
    VALID   : out std_logic;
    Q       : out std_logic_vector(47 downto 0)
   ---------------------------------------------------------------------------
    );

end entity fircompact;





architecture imp of fircompact is

  constant LOG2D : positive := 4;       -- log_2(decimation factor) 
  constant LOG2N : positive := 7;       -- log_2(block length) 
  --
  constant N     : positive := 2 ** (LOG2N - LOG2D);  -- number of cascaded cores

  signal addr0 : std_logic_vector(LOG2D - 1 downto 0) := (others => '0');
  signal tick  : std_logic;

  signal p : signed((N+1) * 48 - 1 downto 0) := (others => '0');

  attribute keep : boolean;
  attribute keep of addr0 : signal is true;
  attribute syn_keep : boolean;
  attribute syn_keep of addr0 : signal is true;

begin

  -----------------------------------------------------------------------------
  -- iterate through coefficients, signal (adjusted for latency) when turning over 
  -----------------------------------------------------------------------------

  process (CLK) is
  begin
    if CLK'event and CLK = '1' then

      if RST = '1' then                 -- use reset to guide mapper
          addr0 <= (others => '0');
      else
          addr0 <= std_logic_vector(unsigned(addr0) + 1);
      end if;

      if signed(addr0) = to_signed(1, addr0'length) then
        tick <= '1';
      else
        tick <= '0';
      end if;

    end if;
  end process;



  -----------------------------------------------------------------------------
  -- input to the carry chain -- used only for cascading or other magic
  -----------------------------------------------------------------------------

  p(47 downto 0) <= signed(PCIN);



  -----------------------------------------------------------------------------
  -- repeat core N times to build up the full 2**LOG2N long FIR.
  -- each core takes partial summ from the previous core, accumulates product
  -- for 2**LOG2D clocks, then passes on the new partial summ to the next core.
  -----------------------------------------------------------------------------

  coregen : for i in 1 to N generate
    core : block is
      signal addr        : std_logic_vector(LOG2N - 1 + SELBITS'length downto 0);
      --
      signal pcin, pcout : signed(47 downto 0);
      signal a1          : std_logic_vector(DWIDTH - 1 downto 0);
      signal coef, b1    : std_logic_vector(15 downto 0);
      signal m           : signed(a1'length + b1'length - 1 downto 0);
      signal opcode      : std_logic;
    begin

      -------------------------------------------------------------------------
      -- fetch coefficient
      -------------------------------------------------------------------------

      addr <= std_logic_vector(to_unsigned(i - 1, LOG2N - LOG2D)) & addr0 & SELBITS;

      rom : entity work.coefrom port map (RCLK => CLK, RADDR => addr, RDATA => coef);

      -------------------------------------------------------------------------
      -- this goes into a single DSP (modify DSP opcode on the run: carry over / accumulate)
      -------------------------------------------------------------------------

      pcin <= p(i * 48 - 1 downto (i-1) * 48);

      process (CLK) is
        variable inc : signed(47 downto 0);
      begin
        if CLK'event and CLK = '1' then

          if RST = '1' then             -- use reset to guide mapper
            a1 <= (others => '0');
            b1 <= (others => '0');
          else
            a1 <= D;                    -- register input to improve timing
            b1 <= coef;
          end if;

          m <= signed(a1) * signed(b1);

          opcode <= tick;

          if opcode = '1' then          -- every (2**LOG2D) clocks 
            inc := pcin;                -- carry over
          else
            inc := pcout;               -- accumulate
          end if;

          pcout <= m + inc;

        end if;
      end process;

      p((i+1) * 48 - 1 downto i * 48) <= pcout;

    end block core;
  end generate coregen;



  -----------------------------------------------------------------------------
  -- output from the chain
  -----------------------------------------------------------------------------

  VALID <= tick when rising_edge(CLK);
  Q     <= std_logic_vector(p(N * 48 + 47 downto N * 48));



end architecture imp;

