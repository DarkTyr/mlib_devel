-------------------------------------------------------------------------------
-- Title      : FIR -- 256 tap, 32 decimating, 2 * (I + Q) sample per clock
-- Project    : 
-------------------------------------------------------------------------------
-- File       : fir_256_32_2iq.vhd
-- Author     : jozsef imrek  <jozsef.imrek@nist.gov>
-- Company    : 
-- Created    : 2019-02-11
-- Last update: 2019-05-17
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
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
-- 2019-05-17  mazsi   simplify module: separate ports for samples, no generics
-- 2019-08-19  mazsi   extra registers on input to work around timing errors
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;





entity fir_256_32_2iq is

  port (
    ---------------------------------------------------------------------------
    CLK   : in  std_logic;
    CE    : in  std_logic := '1';       -- MUST be '1' all the time
    RST   : in  std_logic;
    --
    I1IN  : in  std_logic_vector(17 downto 0);
    Q1IN  : in  std_logic_vector(17 downto 0);
    I0IN  : in  std_logic_vector(17 downto 0);
    Q0IN  : in  std_logic_vector(17 downto 0);
    --
    VALID : out std_logic;
    IOUT  : out std_logic_vector(47 downto 0);
    QOUT  : out std_logic_vector(47 downto 0)
   ---------------------------------------------------------------------------
    );

end entity fir_256_32_2iq;





architecture imp of fir_256_32_2iq is

  attribute shreg_extract: string;
  attribute shreg_extract of imp : architecture is "no";

  constant DWIDTH : integer := I0IN'length;

  signal i1in1, q1in1, i0in1, q0in1 : std_logic_vector(17 downto 0);
  signal validi0, validi1, validi2, validi3     : std_logic;
  signal i1, q1, i0, q0 : std_logic_vector(47 downto 0);
  signal i11, q11, i01, q01 : std_logic_vector(47 downto 0);
  signal isumm, qsumm   : std_logic_vector(47 downto 0);
  signal isumm1, qsumm1   : std_logic_vector(47 downto 0);

begin


  -----------------------------------------------------------------------------
  -- extra registers on input -- should not be needed, but apparently 
  -- simulink alwyas adds logic for date rate conversion
  -----------------------------------------------------------------------------

  i1in1 <= I1IN when rising_edge(CLK);
  q1in1 <= Q1IN when rising_edge(CLK);
  i0in1 <= I0IN when rising_edge(CLK);
  q0in1 <= Q0IN when rising_edge(CLK);



  -----------------------------------------------------------------------------
  -- 4 instances of 128 tap FIR, one for earch input sample
  -- 
  -- first 2 instances have SELBITS set to '1', the other 2 have it set to '0'
  -- this will pick odd and even coefficients from the ROM, respectively
  -----------------------------------------------------------------------------

  firi1 : entity work.fircompact generic map (DWIDTH => DWIDTH)
    port map (
      CLK   => CLK, RST => RST, SELBITS => "1",
      --
      D     => i1in1, -- I1IN,
      VALID => validi0,
      Q     => i1
      );

  firq1 : entity work.fircompact generic map (DWIDTH => DWIDTH)
    port map (
      CLK   => CLK, RST => RST, SELBITS => "1",
      --
      D     => q1in1, -- Q1IN,
      VALID => open,
      Q     => q1
      );

  firi0 : entity work.fircompact generic map (DWIDTH => DWIDTH)
    port map (
      CLK   => CLK, RST => RST, SELBITS => "0",
      --
      D     => i0in1, -- I0IN,
      VALID => open,
      Q     => i0
      );

  firq0 : entity work.fircompact generic map (DWIDTH => DWIDTH)
    port map (
      CLK   => CLK, RST => RST, SELBITS => "0",
      --
      D     => q0in1, -- Q0IN,
      VALID => open,
      Q     => q0
      );



  -----------------------------------------------------------------------------
  -- summ pairwise the 128 tap I / Q FIR outputs to create final output
  -----------------------------------------------------------------------------

  process (CLK) is
  begin
    if CLK'event and CLK = '1' then

      validi1 <= validi0;
      i01     <= i0;
      i11     <= i1;
      q01     <= q0;
      q11     <= q1;

      validi2 <= validi1;
      isumm   <= std_logic_vector(signed(i11) + signed(i01));
      qsumm   <= std_logic_vector(signed(q11) + signed(q01));

      validi3 <= validi2;
      isumm1  <= isumm;
      qsumm1  <= qsumm;

    end if;
  end process;



  -----------------------------------------------------------------------------
  -- register and hold data between updates
  -----------------------------------------------------------------------------

  process (CLK) is
  begin
    if CLK'event and CLK = '1' then

      VALID <= validi3;

      if validi3 = '1' then
        IOUT <= isumm1;
        QOUT <= qsumm1;
      end if;

    end if;
  end process;



end architecture imp;

