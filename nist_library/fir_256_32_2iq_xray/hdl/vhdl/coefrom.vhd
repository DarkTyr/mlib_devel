-------------------------------------------------------------------------------
-- Title      : coefficient ROM
-- Project    : 
-------------------------------------------------------------------------------
-- File       : coefrom.vhd
-- Author     : jozsef imrek  <jozsef.imrek@nist.gov>
-- Company    : 
-- Created    : 2019-02-11
-- Last update: 2019-08-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: coefficient ROM for FIR filter - randomized content
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Author  Description
-- 2019-02-11  mazsi   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity coefrom is

  port (
    RCLK  : in  std_logic;
    RADDR : in  std_logic_vector(7 downto 0);
    RDATA : out std_logic_vector(15 downto 0)
    );

end entity coefrom;



architecture imp of coefrom is

  signal rdatai : std_logic_vector(RDATA'range);

  attribute rom_extract           : string;
  attribute rom_style             : string;
  attribute rom_extract of rdatai : signal is "yes";
  attribute rom_style of rdatai   : signal is "distributed";

begin

  process (RCLK) is
  begin
    if RCLK'event and RCLK = '1' then
      case RADDR is
        when x"00"  => rdatai <= x"fc28";
        when x"01"  => rdatai <= x"ffbc";
        when x"02"  => rdatai <= x"ffbc";
        when x"03"  => rdatai <= x"ffbd";
        when x"04"  => rdatai <= x"ffbf";
        when x"05"  => rdatai <= x"ffc3";
        when x"06"  => rdatai <= x"ffc9";
        when x"07"  => rdatai <= x"ffd1";
        when x"08"  => rdatai <= x"ffdb";
        when x"09"  => rdatai <= x"ffe6";
        when x"0a"  => rdatai <= x"fff5";
        when x"0b"  => rdatai <= x"0005";
        when x"0c"  => rdatai <= x"0018";
        when x"0d"  => rdatai <= x"002e";
        when x"0e"  => rdatai <= x"0047";
        when x"0f"  => rdatai <= x"0063";
        when x"10"  => rdatai <= x"0082";
        when x"11"  => rdatai <= x"00a4";
        when x"12"  => rdatai <= x"00ca";
        when x"13"  => rdatai <= x"00f4";
        when x"14"  => rdatai <= x"0122";
        when x"15"  => rdatai <= x"0154";
        when x"16"  => rdatai <= x"018b";
        when x"17"  => rdatai <= x"01c6";
        when x"18"  => rdatai <= x"0205";
        when x"19"  => rdatai <= x"024a";
        when x"1a"  => rdatai <= x"0293";
        when x"1b"  => rdatai <= x"02e2";
        when x"1c"  => rdatai <= x"0336";
        when x"1d"  => rdatai <= x"0390";
        when x"1e"  => rdatai <= x"03f0";
        when x"1f"  => rdatai <= x"0455";
        when x"20"  => rdatai <= x"04c1";
        when x"21"  => rdatai <= x"0533";
        when x"22"  => rdatai <= x"05ac";
        when x"23"  => rdatai <= x"062b";
        when x"24"  => rdatai <= x"06b0";
        when x"25"  => rdatai <= x"073d";
        when x"26"  => rdatai <= x"07d1";
        when x"27"  => rdatai <= x"086b";
        when x"28"  => rdatai <= x"090d";
        when x"29"  => rdatai <= x"09b6";
        when x"2a"  => rdatai <= x"0a67";
        when x"2b"  => rdatai <= x"0b1f";
        when x"2c"  => rdatai <= x"0bdf";
        when x"2d"  => rdatai <= x"0ca6";
        when x"2e"  => rdatai <= x"0d75";
        when x"2f"  => rdatai <= x"0e4c";
        when x"30"  => rdatai <= x"0f2a";
        when x"31"  => rdatai <= x"1010";
        when x"32"  => rdatai <= x"10fe";
        when x"33"  => rdatai <= x"11f4";
        when x"34"  => rdatai <= x"12f1";
        when x"35"  => rdatai <= x"13f6";
        when x"36"  => rdatai <= x"1502";
        when x"37"  => rdatai <= x"1616";
        when x"38"  => rdatai <= x"1731";
        when x"39"  => rdatai <= x"1853";
        when x"3a"  => rdatai <= x"197d";
        when x"3b"  => rdatai <= x"1aae";
        when x"3c"  => rdatai <= x"1be5";
        when x"3d"  => rdatai <= x"1d23";
        when x"3e"  => rdatai <= x"1e68";
        when x"3f"  => rdatai <= x"1fb3";
        when x"40"  => rdatai <= x"2104";
        when x"41"  => rdatai <= x"225b";
        when x"42"  => rdatai <= x"23b7";
        when x"43"  => rdatai <= x"2519";
        when x"44"  => rdatai <= x"2680";
        when x"45"  => rdatai <= x"27eb";
        when x"46"  => rdatai <= x"295b";
        when x"47"  => rdatai <= x"2ad0";
        when x"48"  => rdatai <= x"2c48";
        when x"49"  => rdatai <= x"2dc3";
        when x"4a"  => rdatai <= x"2f41";
        when x"4b"  => rdatai <= x"30c2";
        when x"4c"  => rdatai <= x"3246";
        when x"4d"  => rdatai <= x"33cb";
        when x"4e"  => rdatai <= x"3552";
        when x"4f"  => rdatai <= x"36da";
        when x"50"  => rdatai <= x"3863";
        when x"51"  => rdatai <= x"39eb";
        when x"52"  => rdatai <= x"3b74";
        when x"53"  => rdatai <= x"3cfc";
        when x"54"  => rdatai <= x"3e83";
        when x"55"  => rdatai <= x"4009";
        when x"56"  => rdatai <= x"418c";
        when x"57"  => rdatai <= x"430d";
        when x"58"  => rdatai <= x"448b";
        when x"59"  => rdatai <= x"4605";
        when x"5a"  => rdatai <= x"477b";
        when x"5b"  => rdatai <= x"48ed";
        when x"5c"  => rdatai <= x"4a5a";
        when x"5d"  => rdatai <= x"4bc2";
        when x"5e"  => rdatai <= x"4d24";
        when x"5f"  => rdatai <= x"4e80";
        when x"60"  => rdatai <= x"4fd5";
        when x"61"  => rdatai <= x"5121";
        when x"62"  => rdatai <= x"5268";
        when x"63"  => rdatai <= x"53a6";
        when x"64"  => rdatai <= x"54db";
        when x"65"  => rdatai <= x"5607";
        when x"66"  => rdatai <= x"572a";
        when x"67"  => rdatai <= x"5843";
        when x"68"  => rdatai <= x"5952";
        when x"69"  => rdatai <= x"5a56";
        when x"6a"  => rdatai <= x"5b4f";
        when x"6b"  => rdatai <= x"5c3d";
        when x"6c"  => rdatai <= x"5d1f";
        when x"6d"  => rdatai <= x"5df6";
        when x"6e"  => rdatai <= x"5ec0";
        when x"6f"  => rdatai <= x"5f7d";
        when x"70"  => rdatai <= x"602e";
        when x"71"  => rdatai <= x"60d1";
        when x"72"  => rdatai <= x"6167";
        when x"73"  => rdatai <= x"61ef";
        when x"74"  => rdatai <= x"626a";
        when x"75"  => rdatai <= x"62d6";
        when x"76"  => rdatai <= x"6334";
        when x"77"  => rdatai <= x"6385";
        when x"78"  => rdatai <= x"63c6";
        when x"79"  => rdatai <= x"63fa";
        when x"7a"  => rdatai <= x"641e";
        when x"7b"  => rdatai <= x"6434";
        when x"7c"  => rdatai <= x"643b";
        when x"7d"  => rdatai <= x"6434";
        when x"7e"  => rdatai <= x"641e";
        when x"7f"  => rdatai <= x"63fa";
        when x"80"  => rdatai <= x"63c6";
        when x"81"  => rdatai <= x"6385";
        when x"82"  => rdatai <= x"6334";
        when x"83"  => rdatai <= x"62d6";
        when x"84"  => rdatai <= x"626a";
        when x"85"  => rdatai <= x"61ef";
        when x"86"  => rdatai <= x"6167";
        when x"87"  => rdatai <= x"60d1";
        when x"88"  => rdatai <= x"602e";
        when x"89"  => rdatai <= x"5f7d";
        when x"8a"  => rdatai <= x"5ec0";
        when x"8b"  => rdatai <= x"5df6";
        when x"8c"  => rdatai <= x"5d1f";
        when x"8d"  => rdatai <= x"5c3d";
        when x"8e"  => rdatai <= x"5b4f";
        when x"8f"  => rdatai <= x"5a56";
        when x"90"  => rdatai <= x"5952";
        when x"91"  => rdatai <= x"5843";
        when x"92"  => rdatai <= x"572a";
        when x"93"  => rdatai <= x"5607";
        when x"94"  => rdatai <= x"54db";
        when x"95"  => rdatai <= x"53a6";
        when x"96"  => rdatai <= x"5268";
        when x"97"  => rdatai <= x"5121";
        when x"98"  => rdatai <= x"4fd5";
        when x"99"  => rdatai <= x"4e80";
        when x"9a"  => rdatai <= x"4d24";
        when x"9b"  => rdatai <= x"4bc2";
        when x"9c"  => rdatai <= x"4a5a";
        when x"9d"  => rdatai <= x"48ed";
        when x"9e"  => rdatai <= x"477b";
        when x"9f"  => rdatai <= x"4605";
        when x"a0"  => rdatai <= x"448b";
        when x"a1"  => rdatai <= x"430d";
        when x"a2"  => rdatai <= x"418c";
        when x"a3"  => rdatai <= x"4009";
        when x"a4"  => rdatai <= x"3e83";
        when x"a5"  => rdatai <= x"3cfc";
        when x"a6"  => rdatai <= x"3b74";
        when x"a7"  => rdatai <= x"39eb";
        when x"a8"  => rdatai <= x"3863";
        when x"a9"  => rdatai <= x"36da";
        when x"aa"  => rdatai <= x"3552";
        when x"ab"  => rdatai <= x"33cb";
        when x"ac"  => rdatai <= x"3246";
        when x"ad"  => rdatai <= x"30c2";
        when x"ae"  => rdatai <= x"2f41";
        when x"af"  => rdatai <= x"2dc3";
        when x"b0"  => rdatai <= x"2c48";
        when x"b1"  => rdatai <= x"2ad0";
        when x"b2"  => rdatai <= x"295b";
        when x"b3"  => rdatai <= x"27eb";
        when x"b4"  => rdatai <= x"2680";
        when x"b5"  => rdatai <= x"2519";
        when x"b6"  => rdatai <= x"23b7";
        when x"b7"  => rdatai <= x"225b";
        when x"b8"  => rdatai <= x"2104";
        when x"b9"  => rdatai <= x"1fb3";
        when x"ba"  => rdatai <= x"1e68";
        when x"bb"  => rdatai <= x"1d23";
        when x"bc"  => rdatai <= x"1be5";
        when x"bd"  => rdatai <= x"1aae";
        when x"be"  => rdatai <= x"197d";
        when x"bf"  => rdatai <= x"1853";
        when x"c0"  => rdatai <= x"1731";
        when x"c1"  => rdatai <= x"1616";
        when x"c2"  => rdatai <= x"1502";
        when x"c3"  => rdatai <= x"13f6";
        when x"c4"  => rdatai <= x"12f1";
        when x"c5"  => rdatai <= x"11f4";
        when x"c6"  => rdatai <= x"10fe";
        when x"c7"  => rdatai <= x"1010";
        when x"c8"  => rdatai <= x"0f2a";
        when x"c9"  => rdatai <= x"0e4c";
        when x"ca"  => rdatai <= x"0d75";
        when x"cb"  => rdatai <= x"0ca6";
        when x"cc"  => rdatai <= x"0bdf";
        when x"cd"  => rdatai <= x"0b1f";
        when x"ce"  => rdatai <= x"0a67";
        when x"cf"  => rdatai <= x"09b6";
        when x"d0"  => rdatai <= x"090d";
        when x"d1"  => rdatai <= x"086b";
        when x"d2"  => rdatai <= x"07d1";
        when x"d3"  => rdatai <= x"073d";
        when x"d4"  => rdatai <= x"06b0";
        when x"d5"  => rdatai <= x"062b";
        when x"d6"  => rdatai <= x"05ac";
        when x"d7"  => rdatai <= x"0533";
        when x"d8"  => rdatai <= x"04c1";
        when x"d9"  => rdatai <= x"0455";
        when x"da"  => rdatai <= x"03f0";
        when x"db"  => rdatai <= x"0390";
        when x"dc"  => rdatai <= x"0336";
        when x"dd"  => rdatai <= x"02e2";
        when x"de"  => rdatai <= x"0293";
        when x"df"  => rdatai <= x"024a";
        when x"e0"  => rdatai <= x"0205";
        when x"e1"  => rdatai <= x"01c6";
        when x"e2"  => rdatai <= x"018b";
        when x"e3"  => rdatai <= x"0154";
        when x"e4"  => rdatai <= x"0122";
        when x"e5"  => rdatai <= x"00f4";
        when x"e6"  => rdatai <= x"00ca";
        when x"e7"  => rdatai <= x"00a4";
        when x"e8"  => rdatai <= x"0082";
        when x"e9"  => rdatai <= x"0063";
        when x"ea"  => rdatai <= x"0047";
        when x"eb"  => rdatai <= x"002e";
        when x"ec"  => rdatai <= x"0018";
        when x"ed"  => rdatai <= x"0005";
        when x"ee"  => rdatai <= x"fff5";
        when x"ef"  => rdatai <= x"ffe6";
        when x"f0"  => rdatai <= x"ffdb";
        when x"f1"  => rdatai <= x"ffd1";
        when x"f2"  => rdatai <= x"ffc9";
        when x"f3"  => rdatai <= x"ffc3";
        when x"f4"  => rdatai <= x"ffbf";
        when x"f5"  => rdatai <= x"ffbd";
        when x"f6"  => rdatai <= x"ffbc";
        when x"f7"  => rdatai <= x"ffbc";
        when x"f8"  => rdatai <= x"fc28";
        when others => rdatai <= (others => '0');
      end case;
    end if;
  end process;

  RDATA <= rdatai;

end architecture imp;
