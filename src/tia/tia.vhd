-- Copyright (c) 2005 Adam Wozniak
--
-- Distributed under the Gnu General Public License
--
-- tia.vhd ; implementation of the Stella/TIA chip
-- Copyright (C) 2005 Adam Wozniak
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--
-- The author may be contacted
-- by email: adam@cuddlepuddle.org
-- by snailmail: Adam Wozniak, 1352 Fourteenth St, Los Osos, CA 93402

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package tia_components is
   
   component audiochannel port
      (
         clk : in std_logic;
         f : in std_logic_vector(4 downto 0);
         v : in std_logic_vector(3 downto 0);
         c : in std_logic_vector(3 downto 0);
         o : out std_logic_vector(3 downto 0)
      );
   end component;
   
   component playfielddraw port
      (
         pf0 : in std_logic_vector(7 downto 0);
         pf1 : in std_logic_vector(7 downto 0);
         pf2 : in std_logic_vector(7 downto 0);
         position : inout std_logic_vector(0 to 7);
         sync : in std_logic;
         clk : in std_logic;
         r  : in std_logic;
         o  : out std_logic;
         left  : out std_logic
      );
   end component;
   
   component playerdraw port
      (
         clk          : in std_logic;
         grold        : in std_logic_vector(7 downto 0);
         grnew        : in std_logic_vector(7 downto 0);
         r            : in std_logic;
         o_n          : in std_logic;
         o            : out std_logic;
         center       : out std_logic;
         nusiz        : in std_logic_vector(2 downto 0);
         position     : inout std_logic_vector(0 to 7);
         reset_strobe_in  : in std_logic;
         reset_strobe_out : inout std_logic
      );
   end component;
   
   component balldraw port
      (
         clk   : in std_logic;
         enold : in std_logic;
         ennew : in std_logic;
         o_n   : in std_logic;
         o     : out std_logic;
         w     : in std_logic_vector(1 downto 0);
         position     : inout std_logic_vector(0 to 7);
         reset_strobe_in  : in std_logic;
         reset_strobe_out : inout std_logic
      );
   end component;
   
   component missiledraw port
      (
         clk   : in std_logic;
         en    : in std_logic;
         lock  : in std_logic;
         o     : out std_logic;
         nusiz : in std_logic_vector(2 downto 0);
         w     : in std_logic_vector(1 downto 0);
         position     : inout std_logic_vector(0 to 7);
         playerposition     : inout std_logic_vector(0 to 7);
         reset_strobe_in  : in std_logic;
         reset_strobe_out : inout std_logic;
         playerlock : in std_logic
      );
   end component;
   
   constant reg_CXM0P : integer := 0;
   constant reg_CXM1P : integer := 1;
   constant reg_CXP0FB: integer := 2;
   constant reg_CXP1FB: integer := 3;
   constant reg_CXM0FB: integer := 4;
   constant reg_CXM1FB: integer := 5;
   constant reg_CXBLPF: integer := 6;
   constant reg_CXPPMM: integer := 7;
   constant reg_INPT0 : integer := 8;
   constant reg_INPT1 : integer := 9;
   constant reg_INPT2 : integer := 10;
   constant reg_INPT3 : integer := 11;
   constant reg_INPT4 : integer := 12;
   constant reg_INPT5 : integer := 13;
   
   constant reg_VSYNC   : integer := 0;
   constant reg_VBLANK  : integer := 1;
   constant reg_WSYNC   : integer := 2;
   constant reg_RSYNC   : integer := 3;
   constant reg_NUSIZ0  : integer := 4;
   constant reg_NUSIZ1  : integer := 5;
   constant reg_COLUP0  : integer := 6;
   constant reg_COLUP1  : integer := 7;
   constant reg_COLUPF  : integer := 8;
   constant reg_COLUBK  : integer := 9;
   constant reg_CTRLPF  : integer := 10;
   constant reg_REFP0   : integer := 11;
   constant reg_REFP1   : integer := 12;
   constant reg_PF0     : integer := 13;
   constant reg_PF1     : integer := 14;
   constant reg_PF2     : integer := 15;
   constant reg_RESP0   : integer := 16;
   constant reg_RESP1   : integer := 17;
   constant reg_RESM0   : integer := 18;
   constant reg_RESM1   : integer := 19;
   constant reg_RESBL   : integer := 20;
   constant reg_AUDC0   : integer := 21;
   constant reg_AUDC1   : integer := 22;
   constant reg_AUDF0   : integer := 23;
   constant reg_AUDF1   : integer := 24;
   constant reg_AUDV0   : integer := 25;
   constant reg_AUDV1   : integer := 26;
   constant reg_GRP0    : integer := 27;
   constant reg_GRP1    : integer := 28;
   constant reg_ENAM0   : integer := 29;
   constant reg_ENAM1   : integer := 30;
   constant reg_ENABL   : integer := 31;
   constant reg_HMP0    : integer := 32;
   constant reg_HMP1    : integer := 33;
   constant reg_HMM0    : integer := 34;
   constant reg_HMM1    : integer := 35;
   constant reg_HMBL    : integer := 36;
   constant reg_VDELP0  : integer := 37;
   constant reg_VDELP1  : integer := 38;
   constant reg_VDELBL  : integer := 39;
   constant reg_RESMP0  : integer := 40;
   constant reg_RESMP1  : integer := 41;
   constant reg_HMOVE   : integer := 42;
   constant reg_HMCLR   : integer := 43;
   constant reg_CXCLR   : integer := 44;
   constant reg_GRP0old : integer := 45; -- TODO will this break anything?
   constant reg_GRP1old : integer := 46; -- TODO will this break anything?
   constant reg_ENABLold: integer := 47; -- TODO will this break anything?
   
   constant IRE_n40  : std_logic_vector(7 downto 0) := x"00";
   constant IRE_n30  : std_logic_vector(7 downto 0) := x"12";
   constant IRE_n20  : std_logic_vector(7 downto 0) := x"25";
   constant IRE_n10  : std_logic_vector(7 downto 0) := x"37";
   constant IRE_0    : std_logic_vector(7 downto 0) := x"49";
   constant IRE_p10  : std_logic_vector(7 downto 0) := x"5B";
   constant IRE_p20  : std_logic_vector(7 downto 0) := x"6E";
   constant IRE_p30  : std_logic_vector(7 downto 0) := x"80";
   constant IRE_p40  : std_logic_vector(7 downto 0) := x"92";
   constant IRE_p50  : std_logic_vector(7 downto 0) := x"A5";
   constant IRE_p60  : std_logic_vector(7 downto 0) := x"B7";
   constant IRE_p70  : std_logic_vector(7 downto 0) := x"C9";
   constant IRE_p80  : std_logic_vector(7 downto 0) := x"DB";
   constant IRE_p90  : std_logic_vector(7 downto 0) := x"EE";
   constant IRE_p100 : std_logic_vector(7 downto 0) := x"FF";
   
   constant XXX_INVALID : std_logic_vector(7 downto 0) := "00000000";
   constant XXX_0 : std_logic_vector(7 downto 0) := "11111111";
   constant XXX_1 : std_logic_vector(7 downto 0) := "01111111";
   constant XXX_2 : std_logic_vector(7 downto 0) := "00111111";
   constant XXX_3 : std_logic_vector(7 downto 0) := "00011111";
   constant XXX_4 : std_logic_vector(7 downto 0) := "00001111";
   constant XXX_5 : std_logic_vector(7 downto 0) := "10000111";
   constant XXX_6 : std_logic_vector(7 downto 0) := "01000011";
   constant XXX_7 : std_logic_vector(7 downto 0) := "10100001";
   constant XXX_8 : std_logic_vector(7 downto 0) := "11010000";
   constant XXX_9 : std_logic_vector(7 downto 0) := "11101000";
   constant XXX_10 : std_logic_vector(7 downto 0) := "11110100";
   constant XXX_11 : std_logic_vector(7 downto 0) := "01111010";
   constant XXX_12 : std_logic_vector(7 downto 0) := "00111101";
   constant XXX_13 : std_logic_vector(7 downto 0) := "00011110";
   constant XXX_14 : std_logic_vector(7 downto 0) := "10001111";
   constant XXX_15 : std_logic_vector(7 downto 0) := "11000111";
   constant XXX_16 : std_logic_vector(7 downto 0) := "01100011";
   constant XXX_17 : std_logic_vector(7 downto 0) := "10110001";
   constant XXX_18 : std_logic_vector(7 downto 0) := "01011000";
   constant XXX_19 : std_logic_vector(7 downto 0) := "00101100";
   constant XXX_20 : std_logic_vector(7 downto 0) := "00010110";
   constant XXX_21 : std_logic_vector(7 downto 0) := "00001011";
   constant XXX_22 : std_logic_vector(7 downto 0) := "00000101";
   constant XXX_23 : std_logic_vector(7 downto 0) := "00000010";
   constant XXX_24 : std_logic_vector(7 downto 0) := "00000001";
   constant XXX_25 : std_logic_vector(7 downto 0) := "10000000";
   constant XXX_26 : std_logic_vector(7 downto 0) := "01000000";
   constant XXX_27 : std_logic_vector(7 downto 0) := "00100000";
   constant XXX_28 : std_logic_vector(7 downto 0) := "00010000";
   constant XXX_29 : std_logic_vector(7 downto 0) := "10001000";
   constant XXX_30 : std_logic_vector(7 downto 0) := "11000100";
   constant XXX_31 : std_logic_vector(7 downto 0) := "11100010";
   constant XXX_32 : std_logic_vector(7 downto 0) := "01110001";
   constant XXX_33 : std_logic_vector(7 downto 0) := "00111000";
   constant XXX_34 : std_logic_vector(7 downto 0) := "00011100";
   constant XXX_35 : std_logic_vector(7 downto 0) := "10001110";
   constant XXX_36 : std_logic_vector(7 downto 0) := "01000111";
   constant XXX_37 : std_logic_vector(7 downto 0) := "00100011";
   constant XXX_38 : std_logic_vector(7 downto 0) := "10010001";
   constant XXX_39 : std_logic_vector(7 downto 0) := "01001000";
   constant XXX_40 : std_logic_vector(7 downto 0) := "10100100";
   constant XXX_41 : std_logic_vector(7 downto 0) := "11010010";
   constant XXX_42 : std_logic_vector(7 downto 0) := "11101001";
   constant XXX_43 : std_logic_vector(7 downto 0) := "01110100";
   constant XXX_44 : std_logic_vector(7 downto 0) := "00111010";
   constant XXX_45 : std_logic_vector(7 downto 0) := "00011101";
   constant XXX_46 : std_logic_vector(7 downto 0) := "00001110";
   constant XXX_47 : std_logic_vector(7 downto 0) := "00000111";
   constant XXX_48 : std_logic_vector(7 downto 0) := "00000011";
   constant XXX_49 : std_logic_vector(7 downto 0) := "10000001";
   constant XXX_50 : std_logic_vector(7 downto 0) := "11000000";
   constant XXX_51 : std_logic_vector(7 downto 0) := "01100000";
   constant XXX_52 : std_logic_vector(7 downto 0) := "00110000";
   constant XXX_53 : std_logic_vector(7 downto 0) := "10011000";
   constant XXX_54 : std_logic_vector(7 downto 0) := "01001100";
   constant XXX_55 : std_logic_vector(7 downto 0) := "00100110";
   constant XXX_56 : std_logic_vector(7 downto 0) := "10010011";
   constant XXX_57 : std_logic_vector(7 downto 0) := "01001001";
   constant XXX_58 : std_logic_vector(7 downto 0) := "00100100";
   constant XXX_59 : std_logic_vector(7 downto 0) := "10010010";
   constant XXX_60 : std_logic_vector(7 downto 0) := "11001001";
   constant XXX_61 : std_logic_vector(7 downto 0) := "01100100";
   constant XXX_62 : std_logic_vector(7 downto 0) := "10110010";
   constant XXX_63 : std_logic_vector(7 downto 0) := "11011001";
   constant XXX_64 : std_logic_vector(7 downto 0) := "11101100";
   constant XXX_65 : std_logic_vector(7 downto 0) := "01110110";
   constant XXX_66 : std_logic_vector(7 downto 0) := "00111011";
   constant XXX_67 : std_logic_vector(7 downto 0) := "10011101";
   constant XXX_68 : std_logic_vector(7 downto 0) := "01001110";
   constant XXX_69 : std_logic_vector(7 downto 0) := "00100111";
   constant XXX_70 : std_logic_vector(7 downto 0) := "00010011";
   constant XXX_71 : std_logic_vector(7 downto 0) := "00001001";
   constant XXX_72 : std_logic_vector(7 downto 0) := "00000100";
   constant XXX_73 : std_logic_vector(7 downto 0) := "10000010";
   constant XXX_74 : std_logic_vector(7 downto 0) := "01000001";
   constant XXX_75 : std_logic_vector(7 downto 0) := "10100000";
   constant XXX_76 : std_logic_vector(7 downto 0) := "01010000";
   constant XXX_77 : std_logic_vector(7 downto 0) := "10101000";
   constant XXX_78 : std_logic_vector(7 downto 0) := "11010100";
   constant XXX_79 : std_logic_vector(7 downto 0) := "01101010";
   constant XXX_80 : std_logic_vector(7 downto 0) := "10110101";
   constant XXX_81 : std_logic_vector(7 downto 0) := "11011010";
   constant XXX_82 : std_logic_vector(7 downto 0) := "01101101";
   constant XXX_83 : std_logic_vector(7 downto 0) := "10110110";
   constant XXX_84 : std_logic_vector(7 downto 0) := "01011011";
   constant XXX_85 : std_logic_vector(7 downto 0) := "10101101";
   constant XXX_86 : std_logic_vector(7 downto 0) := "11010110";
   constant XXX_87 : std_logic_vector(7 downto 0) := "01101011";
   constant XXX_88 : std_logic_vector(7 downto 0) := "00110101";
   constant XXX_89 : std_logic_vector(7 downto 0) := "10011010";
   constant XXX_90 : std_logic_vector(7 downto 0) := "01001101";
   constant XXX_91 : std_logic_vector(7 downto 0) := "10100110";
   constant XXX_92 : std_logic_vector(7 downto 0) := "11010011";
   constant XXX_93 : std_logic_vector(7 downto 0) := "01101001";
   constant XXX_94 : std_logic_vector(7 downto 0) := "00110100";
   constant XXX_95 : std_logic_vector(7 downto 0) := "00011010";
   constant XXX_96 : std_logic_vector(7 downto 0) := "00001101";
   constant XXX_97 : std_logic_vector(7 downto 0) := "10000110";
   constant XXX_98 : std_logic_vector(7 downto 0) := "11000011";
   constant XXX_99 : std_logic_vector(7 downto 0) := "11100001";
   constant XXX_100 : std_logic_vector(7 downto 0) := "11110000";
   constant XXX_101 : std_logic_vector(7 downto 0) := "11111000";
   constant XXX_102 : std_logic_vector(7 downto 0) := "01111100";
   constant XXX_103 : std_logic_vector(7 downto 0) := "10111110";
   constant XXX_104 : std_logic_vector(7 downto 0) := "11011111";
   constant XXX_105 : std_logic_vector(7 downto 0) := "01101111";
   constant XXX_106 : std_logic_vector(7 downto 0) := "10110111";
   constant XXX_107 : std_logic_vector(7 downto 0) := "11011011";
   constant XXX_108 : std_logic_vector(7 downto 0) := "11101101";
   constant XXX_109 : std_logic_vector(7 downto 0) := "11110110";
   constant XXX_110 : std_logic_vector(7 downto 0) := "01111011";
   constant XXX_111 : std_logic_vector(7 downto 0) := "10111101";
   constant XXX_112 : std_logic_vector(7 downto 0) := "01011110";
   constant XXX_113 : std_logic_vector(7 downto 0) := "10101111";
   constant XXX_114 : std_logic_vector(7 downto 0) := "11010111";
   constant XXX_115 : std_logic_vector(7 downto 0) := "11101011";
   constant XXX_116 : std_logic_vector(7 downto 0) := "01110101";
   constant XXX_117 : std_logic_vector(7 downto 0) := "10111010";
   constant XXX_118 : std_logic_vector(7 downto 0) := "01011101";
   constant XXX_119 : std_logic_vector(7 downto 0) := "00101110";
   constant XXX_120 : std_logic_vector(7 downto 0) := "00010111";
   constant XXX_121 : std_logic_vector(7 downto 0) := "10001011";
   constant XXX_122 : std_logic_vector(7 downto 0) := "01000101";
   constant XXX_123 : std_logic_vector(7 downto 0) := "00100010";
   constant XXX_124 : std_logic_vector(7 downto 0) := "00010001";
   constant XXX_125 : std_logic_vector(7 downto 0) := "00001000";
   constant XXX_126 : std_logic_vector(7 downto 0) := "10000100";
   constant XXX_127 : std_logic_vector(7 downto 0) := "11000010";
   constant XXX_128 : std_logic_vector(7 downto 0) := "01100001";
   constant XXX_129 : std_logic_vector(7 downto 0) := "10110000";
   constant XXX_130 : std_logic_vector(7 downto 0) := "11011000";
   constant XXX_131 : std_logic_vector(7 downto 0) := "01101100";
   constant XXX_132 : std_logic_vector(7 downto 0) := "00110110";
   constant XXX_133 : std_logic_vector(7 downto 0) := "00011011";
   constant XXX_134 : std_logic_vector(7 downto 0) := "10001101";
   constant XXX_135 : std_logic_vector(7 downto 0) := "11000110";
   constant XXX_136 : std_logic_vector(7 downto 0) := "11100011";
   constant XXX_137 : std_logic_vector(7 downto 0) := "11110001";
   constant XXX_138 : std_logic_vector(7 downto 0) := "01111000";
   constant XXX_139 : std_logic_vector(7 downto 0) := "00111100";
   constant XXX_140 : std_logic_vector(7 downto 0) := "10011110";
   constant XXX_141 : std_logic_vector(7 downto 0) := "11001111";
   constant XXX_142 : std_logic_vector(7 downto 0) := "11100111";
   constant XXX_143 : std_logic_vector(7 downto 0) := "01110011";
   constant XXX_144 : std_logic_vector(7 downto 0) := "00111001";
   constant XXX_145 : std_logic_vector(7 downto 0) := "10011100";
   constant XXX_146 : std_logic_vector(7 downto 0) := "11001110";
   constant XXX_147 : std_logic_vector(7 downto 0) := "01100111";
   constant XXX_148 : std_logic_vector(7 downto 0) := "00110011";
   constant XXX_149 : std_logic_vector(7 downto 0) := "00011001";
   constant XXX_150 : std_logic_vector(7 downto 0) := "10001100";
   constant XXX_151 : std_logic_vector(7 downto 0) := "01000110";
   constant XXX_152 : std_logic_vector(7 downto 0) := "10100011";
   constant XXX_153 : std_logic_vector(7 downto 0) := "11010001";
   constant XXX_154 : std_logic_vector(7 downto 0) := "01101000";
   constant XXX_155 : std_logic_vector(7 downto 0) := "10110100";
   constant XXX_156 : std_logic_vector(7 downto 0) := "01011010";
   constant XXX_157 : std_logic_vector(7 downto 0) := "00101101";
   constant XXX_158 : std_logic_vector(7 downto 0) := "10010110";
   constant XXX_159 : std_logic_vector(7 downto 0) := "01001011";
   constant XXX_160 : std_logic_vector(7 downto 0) := "00100101";
   constant XXX_161 : std_logic_vector(7 downto 0) := "00010010";
   constant XXX_162 : std_logic_vector(7 downto 0) := "10001001";
   constant XXX_163 : std_logic_vector(7 downto 0) := "01000100";
   constant XXX_164 : std_logic_vector(7 downto 0) := "10100010";
   constant XXX_165 : std_logic_vector(7 downto 0) := "01010001";
   constant XXX_166 : std_logic_vector(7 downto 0) := "00101000";
   constant XXX_167 : std_logic_vector(7 downto 0) := "10010100";
   constant XXX_168 : std_logic_vector(7 downto 0) := "01001010";
   constant XXX_169 : std_logic_vector(7 downto 0) := "10100101";
   constant XXX_170 : std_logic_vector(7 downto 0) := "01010010";
   constant XXX_171 : std_logic_vector(7 downto 0) := "10101001";
   constant XXX_172 : std_logic_vector(7 downto 0) := "01010100";
   constant XXX_173 : std_logic_vector(7 downto 0) := "00101010";
   constant XXX_174 : std_logic_vector(7 downto 0) := "10010101";
   constant XXX_175 : std_logic_vector(7 downto 0) := "11001010";
   constant XXX_176 : std_logic_vector(7 downto 0) := "11100101";
   constant XXX_177 : std_logic_vector(7 downto 0) := "01110010";
   constant XXX_178 : std_logic_vector(7 downto 0) := "10111001";
   constant XXX_179 : std_logic_vector(7 downto 0) := "11011100";
   constant XXX_180 : std_logic_vector(7 downto 0) := "11101110";
   constant XXX_181 : std_logic_vector(7 downto 0) := "01110111";
   constant XXX_182 : std_logic_vector(7 downto 0) := "10111011";
   constant XXX_183 : std_logic_vector(7 downto 0) := "11011101";
   constant XXX_184 : std_logic_vector(7 downto 0) := "01101110";
   constant XXX_185 : std_logic_vector(7 downto 0) := "00110111";
   constant XXX_186 : std_logic_vector(7 downto 0) := "10011011";
   constant XXX_187 : std_logic_vector(7 downto 0) := "11001101";
   constant XXX_188 : std_logic_vector(7 downto 0) := "11100110";
   constant XXX_189 : std_logic_vector(7 downto 0) := "11110011";
   constant XXX_190 : std_logic_vector(7 downto 0) := "01111001";
   constant XXX_191 : std_logic_vector(7 downto 0) := "10111100";
   constant XXX_192 : std_logic_vector(7 downto 0) := "11011110";
   constant XXX_193 : std_logic_vector(7 downto 0) := "11101111";
   constant XXX_194 : std_logic_vector(7 downto 0) := "11110111";
   constant XXX_195 : std_logic_vector(7 downto 0) := "11111011";
   constant XXX_196 : std_logic_vector(7 downto 0) := "11111101";
   constant XXX_197 : std_logic_vector(7 downto 0) := "01111110";
   constant XXX_198 : std_logic_vector(7 downto 0) := "10111111";
   constant XXX_199 : std_logic_vector(7 downto 0) := "01011111";
   constant XXX_200 : std_logic_vector(7 downto 0) := "00101111";
   constant XXX_201 : std_logic_vector(7 downto 0) := "10010111";
   constant XXX_202 : std_logic_vector(7 downto 0) := "11001011";
   constant XXX_203 : std_logic_vector(7 downto 0) := "01100101";
   constant XXX_204 : std_logic_vector(7 downto 0) := "00110010";
   constant XXX_205 : std_logic_vector(7 downto 0) := "10011001";
   constant XXX_206 : std_logic_vector(7 downto 0) := "11001100";
   constant XXX_207 : std_logic_vector(7 downto 0) := "01100110";
   constant XXX_208 : std_logic_vector(7 downto 0) := "10110011";
   constant XXX_209 : std_logic_vector(7 downto 0) := "01011001";
   constant XXX_210 : std_logic_vector(7 downto 0) := "10101100";
   constant XXX_211 : std_logic_vector(7 downto 0) := "01010110";
   constant XXX_212 : std_logic_vector(7 downto 0) := "00101011";
   constant XXX_213 : std_logic_vector(7 downto 0) := "00010101";
   constant XXX_214 : std_logic_vector(7 downto 0) := "10001010";
   constant XXX_215 : std_logic_vector(7 downto 0) := "11000101";
   constant XXX_216 : std_logic_vector(7 downto 0) := "01100010";
   constant XXX_217 : std_logic_vector(7 downto 0) := "00110001";
   constant XXX_218 : std_logic_vector(7 downto 0) := "00011000";
   constant XXX_219 : std_logic_vector(7 downto 0) := "00001100";
   constant XXX_220 : std_logic_vector(7 downto 0) := "00000110";
   constant XXX_221 : std_logic_vector(7 downto 0) := "10000011";
   constant XXX_222 : std_logic_vector(7 downto 0) := "11000001";
   constant XXX_223 : std_logic_vector(7 downto 0) := "11100000";
   constant XXX_224 : std_logic_vector(7 downto 0) := "01110000";
   constant XXX_225 : std_logic_vector(7 downto 0) := "10111000";
   constant XXX_226 : std_logic_vector(7 downto 0) := "01011100";
   constant XXX_227 : std_logic_vector(7 downto 0) := "10101110";
   constant XXX_228 : std_logic_vector(7 downto 0) := "01010111";
   constant XXX_229 : std_logic_vector(7 downto 0) := "10101011";
   constant XXX_230 : std_logic_vector(7 downto 0) := "01010101";
   constant XXX_231 : std_logic_vector(7 downto 0) := "10101010";
   constant XXX_232 : std_logic_vector(7 downto 0) := "11010101";
   constant XXX_233 : std_logic_vector(7 downto 0) := "11101010";
   constant XXX_234 : std_logic_vector(7 downto 0) := "11110101";
   constant XXX_235 : std_logic_vector(7 downto 0) := "11111010";
   constant XXX_236 : std_logic_vector(7 downto 0) := "01111101";
   constant XXX_237 : std_logic_vector(7 downto 0) := "00111110";
   constant XXX_238 : std_logic_vector(7 downto 0) := "10011111";
   constant XXX_239 : std_logic_vector(7 downto 0) := "01001111";
   constant XXX_240 : std_logic_vector(7 downto 0) := "10100111";
   constant XXX_241 : std_logic_vector(7 downto 0) := "01010011";
   constant XXX_242 : std_logic_vector(7 downto 0) := "00101001";
   constant XXX_243 : std_logic_vector(7 downto 0) := "00010100";
   constant XXX_244 : std_logic_vector(7 downto 0) := "00001010";
   constant XXX_245 : std_logic_vector(7 downto 0) := "10000101";
   constant XXX_246 : std_logic_vector(7 downto 0) := "01000010";
   constant XXX_247 : std_logic_vector(7 downto 0) := "00100001";
   constant XXX_248 : std_logic_vector(7 downto 0) := "10010000";
   constant XXX_249 : std_logic_vector(7 downto 0) := "11001000";
   constant XXX_250 : std_logic_vector(7 downto 0) := "11100100";
   constant XXX_251 : std_logic_vector(7 downto 0) := "11110010";
   constant XXX_252 : std_logic_vector(7 downto 0) := "11111001";
   constant XXX_253 : std_logic_vector(7 downto 0) := "11111100";
   constant XXX_254 : std_logic_vector(7 downto 0) := "11111110";
   
   constant HSC_INVALID : std_logic_vector(0 to 5) := "000000";
   constant HSC_0 : std_logic_vector(0 to 5) := "111111";
   constant HSC_1 : std_logic_vector(0 to 5) := "011111";
   constant HSC_2 : std_logic_vector(0 to 5) := "001111";
   constant HSC_3 : std_logic_vector(0 to 5) := "000111";
   constant HSC_4 : std_logic_vector(0 to 5) := "000011";
   constant HSC_5 : std_logic_vector(0 to 5) := "000001";
   constant HSC_6 : std_logic_vector(0 to 5) := "100000";
   constant HSC_7 : std_logic_vector(0 to 5) := "010000";
   constant HSC_8 : std_logic_vector(0 to 5) := "001000";
   constant HSC_9 : std_logic_vector(0 to 5) := "000100";
   constant HSC_10 : std_logic_vector(0 to 5) := "000010";
   constant HSC_11 : std_logic_vector(0 to 5) := "100001";
   constant HSC_12 : std_logic_vector(0 to 5) := "110000";
   constant HSC_13 : std_logic_vector(0 to 5) := "011000";
   constant HSC_14 : std_logic_vector(0 to 5) := "001100";
   constant HSC_15 : std_logic_vector(0 to 5) := "000110";
   constant HSC_16 : std_logic_vector(0 to 5) := "100011";
   constant HSC_17 : std_logic_vector(0 to 5) := "010001";
   constant HSC_18 : std_logic_vector(0 to 5) := "101000";
   constant HSC_19 : std_logic_vector(0 to 5) := "010100";
   constant HSC_20 : std_logic_vector(0 to 5) := "001010";
   constant HSC_21 : std_logic_vector(0 to 5) := "100101";
   constant HSC_22 : std_logic_vector(0 to 5) := "110010";
   constant HSC_23 : std_logic_vector(0 to 5) := "111001";
   constant HSC_24 : std_logic_vector(0 to 5) := "111100";
   constant HSC_25 : std_logic_vector(0 to 5) := "011110";
   constant HSC_26 : std_logic_vector(0 to 5) := "101111";
   constant HSC_27 : std_logic_vector(0 to 5) := "010111";
   constant HSC_28 : std_logic_vector(0 to 5) := "001011";
   constant HSC_29 : std_logic_vector(0 to 5) := "000101";
   constant HSC_30 : std_logic_vector(0 to 5) := "100010";
   constant HSC_31 : std_logic_vector(0 to 5) := "110001";
   constant HSC_32 : std_logic_vector(0 to 5) := "111000";
   constant HSC_33 : std_logic_vector(0 to 5) := "011100";
   constant HSC_34 : std_logic_vector(0 to 5) := "001110";
   constant HSC_35 : std_logic_vector(0 to 5) := "100111";
   constant HSC_36 : std_logic_vector(0 to 5) := "010011";
   constant HSC_37 : std_logic_vector(0 to 5) := "001001";
   constant HSC_38 : std_logic_vector(0 to 5) := "100100";
   constant HSC_39 : std_logic_vector(0 to 5) := "010010";
   constant HSC_40 : std_logic_vector(0 to 5) := "101001";
   constant HSC_41 : std_logic_vector(0 to 5) := "110100";
   constant HSC_42 : std_logic_vector(0 to 5) := "011010";
   constant HSC_43 : std_logic_vector(0 to 5) := "101101";
   constant HSC_44 : std_logic_vector(0 to 5) := "110110";
   constant HSC_45 : std_logic_vector(0 to 5) := "111011";
   constant HSC_46 : std_logic_vector(0 to 5) := "011101";
   constant HSC_47 : std_logic_vector(0 to 5) := "101110";
   constant HSC_48 : std_logic_vector(0 to 5) := "110111";
   constant HSC_49 : std_logic_vector(0 to 5) := "011011";
   constant HSC_50 : std_logic_vector(0 to 5) := "001101";
   constant HSC_51 : std_logic_vector(0 to 5) := "100110";
   constant HSC_52 : std_logic_vector(0 to 5) := "110011";
   constant HSC_53 : std_logic_vector(0 to 5) := "011001";
   constant HSC_54 : std_logic_vector(0 to 5) := "101100";
   constant HSC_55 : std_logic_vector(0 to 5) := "010110";
   constant HSC_56 : std_logic_vector(0 to 5) := "101011";
   constant HSC_57 : std_logic_vector(0 to 5) := "010101";
   constant HSC_58 : std_logic_vector(0 to 5) := "101010";
   constant HSC_59 : std_logic_vector(0 to 5) := "110101";
   constant HSC_60 : std_logic_vector(0 to 5) := "111010";
   constant HSC_61 : std_logic_vector(0 to 5) := "111101";
   constant HSC_62 : std_logic_vector(0 to 5) := "111110";
   
end tia_components;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.tia_components.all;

entity audiochannel is port
   (
      clk : in std_logic;
      f : in std_logic_vector(4 downto 0);
      v : in std_logic_vector(3 downto 0);
      c : in std_logic_vector(3 downto 0);
      o : out std_logic_vector(3 downto 0)
   );
end;

architecture audiochannel_architecture of audiochannel is
   signal counter : std_logic_vector(4 downto 0) := "00000";
   signal poly4 : std_logic_vector(3 downto 0) := "1111";
   signal poly5 : std_logic_vector(4 downto 0) := "11111";
   signal poly9 : std_logic_vector(8 downto 0) := "111111111";
   signal poly2 : std_logic := '1';
   type div6_state_type is (on1, on2, on3, off1, off2, off3);
   signal div6  : div6_state_type := on1;
begin
   process (clk, f, v, c)
   begin
      if (clk'event and clk = '1') then                                    --! [0]
         --if en = '1' then
         if counter = "00000" then                                         --! [1]
            counter <= f;
            case c is
               when "0000" =>
                  o <= v;
               when "0001" =>
                  if poly4 = "0000" then                                   --! [2]
                     poly4 <= "1111";
                  else                                                     --! [2]
                     poly4 <= poly4(2 downto 0) & (poly4(3) xor poly4(2));
                  end if;                                                  --! [2]
                  if (poly4(3) xor poly4(2)) /= poly4(0) then              --! [3]
                     o <= v;
                  else                                                     --! [3]
                     o <= "0000";
                  end if;                                                  --! [3]
               when "0010" =>
                  if poly5 = "00000" then                                  --! [4]
                     poly5 <= "11111";
                  else                                                     --! [4]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [4]
                  if poly5 = "11111" or poly5 = "10101" then               --! [5]
                     if poly4 = "0000" then                                --! [6]
                        poly4 <= "1111";
                     else                                                  --! [6]
                        poly4 <= poly4(2 downto 0) & (poly4(3) xor poly4(2));
                     end if;                                               --! [6]
                     if (poly4(3) xor poly4(2)) /= poly4(0) then           --! [7]
                        o <= v;
                     else                                                  --! [7]
                        o <= "0000";
                     end if;                                               --! [7]
                  end if;                                                  --! [5]
               when "0011" =>
                  if poly5 = "00000" then                                  --! [8]
                     poly5 <= "11111";
                  else                                                     --! [8]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [8]
                  if (poly5(4) xor poly5(2)) /= poly5(0) then              --! [9]
                     if poly4 = "0000" then                                --! [10]
                        poly4 <= "1111";
                     else                                                  --! [10]
                        poly4 <= poly4(2 downto 0) & (poly4(3) xor poly4(2));
                     end if;                                               --! [10]
                     if (poly4(3) xor poly4(2)) /= poly4(0) then           --! [11]
                        o <= v;
                     else                                                  --! [11]
                        o <= "0000";
                     end if;                                               --! [11]
                  end if;                                                  --! [9]
               when "0100" =>
                  poly2 <= not poly2;
                  if poly2 = '1' then                                      --! [12]
                     o <= v;
                  else                                                     --! [12]
                     o <= "0000";
                  end if;                                                  --! [12]
               when "0101" =>
                  poly2 <= not poly2;
                  if poly2 = '1' then                                      --! [13]
                     o <= v;
                  else                                                     --! [13]
                     o <= "0000";
                  end if;                                                  --! [13]
               when "0110" =>
                  if poly5 = "00000" then                                  --! [14]
                     poly5 <= "11111";
                  else                                                     --! [14]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [14]
                  if poly5 = "11111" then                                  --! [15]
                     o <= v;
                  elsif poly5 = "10101" then                               --! [15]
                     o <= "0000";
                  end if;                                                  --! [15]
               when "0111" =>
                  if poly5 = "00000" then                                  --! [16]
                     poly5 <= "11111";
                  else                                                     --! [16]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [16]
                  if (poly5(4) xor poly5(2)) /= poly5(0) then              --! [17]
                     o <= v;
                  else                                                     --! [17]
                     o <= "0000";
                  end if;                                                  --! [17]
               when "1000" =>
                  if poly9 = "000000000" then                              --! [18]
                     poly9 <= "111111111";
                  else                                                     --! [18]
                     poly9 <= poly9(7 downto 0) & (poly9(8) xor poly9(4));
                  end if;                                                  --! [18]
                  if (poly9(8) xor poly9(4)) /= poly9(0) then              --! [19]
                     o <= v;
                  else                                                     --! [19]
                     o <= "0000";
                  end if;                                                  --! [19]
               when "1001" =>
                  if poly5 = "00000" then                                  --! [20]
                     poly5 <= "11111";
                  else                                                     --! [20]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [20]
                  if (poly5(4) xor poly5(2)) /= poly5(0) then              --! [21]
                     o <= v;
                  else                                                     --! [21]
                     o <= "0000";
                  end if;                                                  --! [21]
               when "1010" =>
                  if poly5 = "00000" then                                  --! [22]
                     poly5 <= "11111";
                  else                                                     --! [22]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [22]
                  if poly5 = "11111" then                                  --! [23]
                     o <= v;
                  elsif poly5 = "10101" then                               --! [23]
                     o <= "0000";
                  end if;                                                  --! [23]
               when "1011" =>
                  o <= "1111";
               when "1100" =>
                  case div6 is
                     when on1 =>
                        div6 <= on2;
                        o <= v;
                     when on2 =>
                        div6 <= on3;
                     when on3 =>
                        div6 <= off1;
                     when off1 =>
                        div6 <= off2;
                        o <= "0000";
                     when off2 =>
                        div6 <= off3;
                     when off3 =>
                        div6 <= on1;
                  end case;
               when "1101" =>
                  case div6 is
                     when on1 =>
                        div6 <= on2;
                        o <= v;
                     when on2 =>
                        div6 <= on3;
                     when on3 =>
                        div6 <= off1;
                     when off1 =>
                        div6 <= off2;
                        o <= "0000";
                     when off2 =>
                        div6 <= off3;
                     when off3 =>
                        div6 <= on1;
                  end case;
               when "1110" =>
                  if poly5 = "00000" then                                  --! [24]
                     poly5 <= "11111";
                  else                                                     --! [24]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [24]
                  if poly5 = "11111" or poly5 = "10101" then               --! [25]
                     case div6 is
                        when on1 =>
                           div6 <= on2;
                           o <= v;
                        when on2 =>
                           div6 <= on3;
                        when on3 =>
                           div6 <= off1;
                        when off1 =>
                           div6 <= off2;
                           o <= "0000";
                        when off2 =>
                           div6 <= off3;
                        when off3 =>
                           div6 <= on1;
                     end case;
                  end if;                                                  --! [25]
               when "1111" =>
                  if poly5 = "00000" then                                  --! [26]
                     poly5 <= "11111";
                  else                                                     --! [26]
                     poly5 <= poly5(3 downto 0) & (poly5(4) xor poly5(2));
                  end if;                                                  --! [26]
                  if (poly5(4) xor poly5(2)) /= poly5(0) then              --! [27]
                     case div6 is
                        when on1 =>
                           div6 <= on2;
                        when on2 =>
                           div6 <= on3;
                        when on3 =>
                           div6 <= off1;
                           o <= "0000";
                        when off1 =>
                           div6 <= off2;
                        when off2 =>
                           div6 <= off3;
                        when off3 =>
                           div6 <= on1;
                           o <= v;
                     end case;
                  end if;                                                  --! [27]
               when others =>
            end case;
         else                                                              --! [1]
            counter <= counter + "11111";
         end if;                                                           --! [1]
         --end if;
      end if;                                                              --! [0]
   end process;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.tia_components.all;

entity playfielddraw is port
   (
      pf0 : in std_logic_vector(7 downto 0);
      pf1 : in std_logic_vector(7 downto 0);
      pf2 : in std_logic_vector(7 downto 0);
      position : inout std_logic_vector(0 to 7);
      sync : in std_logic;
      clk : in std_logic;
      r  : in std_logic;
      o  : out std_logic;
      left  : out std_logic
   );
end;

architecture playfielddraw_architecture of playfielddraw is
   signal pf : std_logic_vector(0 to 19);
begin
   process (pf0, pf1, pf2)
   begin
      pf <=
      (
         pf0(4) & pf0(5) & pf0(6) & pf0(7) &
         pf1(7 downto 0) &
         pf2(0) & pf2(1) & pf2(2) & pf2(3) & pf2(4) & pf2(5) & pf2(6) & pf2(7)
      );
   end process;
   
   process(clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if sync = '1' or position = XXX_INVALID then                      --! [1]
            position <= XXX_8;
         elsif position = XXX_159 then                                     --! [1]
            position <= XXX_0;
         else                                                              --! [1]
            position <= (position(7) xor position(5) xor position(4) xor position(3)) & position(0 to 6);
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(clk, position, pf, r)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         case position is
            when XXX_0 =>
               o <= pf(0);
               left <= '1';
            when XXX_4 =>
               o <= pf(1);
            when XXX_8 =>
               o <= pf(2);
            when XXX_12 =>
               o <= pf(3);
            when XXX_16 =>
               o <= pf(4);
            when XXX_20 =>
               o <= pf(5);
            when XXX_24 =>
               o <= pf(6);
            when XXX_28 =>
               o <= pf(7);
            when XXX_32 =>
               o <= pf(8);
            when XXX_36 =>
               o <= pf(9);
            when XXX_40 =>
               o <= pf(10);
            when XXX_44 =>
               o <= pf(11);
            when XXX_48 =>
               o <= pf(12);
            when XXX_52 =>
               o <= pf(13);
            when XXX_56 =>
               o <= pf(14);
            when XXX_60 =>
               o <= pf(15);
            when XXX_64 =>
               o <= pf(16);
            when XXX_68 =>
               o <= pf(17);
            when XXX_72 =>
               o <= pf(18);
            when XXX_76 =>
               o <= pf(19);
            when XXX_80 =>
               if r = '1' then                                             --! [1]
                  o <= pf(19);
               else                                                        --! [1]
                  o <= pf(0);
               end if;                                                     --! [1]
               left <= '0';
            when XXX_84 =>
               if r = '1' then                                             --! [2]
                  o <= pf(18);
               else                                                        --! [2]
                  o <= pf(1);
               end if;                                                     --! [2]
            when XXX_88 =>
               if r = '1' then                                             --! [3]
                  o <= pf(17);
               else                                                        --! [3]
                  o <= pf(2);
               end if;                                                     --! [3]
            when XXX_92 =>
               if r = '1' then                                             --! [4]
                  o <= pf(16);
               else                                                        --! [4]
                  o <= pf(3);
               end if;                                                     --! [4]
            when XXX_96 =>
               if r = '1' then                                             --! [5]
                  o <= pf(15);
               else                                                        --! [5]
                  o <= pf(4);
               end if;                                                     --! [5]
            when XXX_100 =>
               if r = '1' then                                             --! [6]
                  o <= pf(14);
               else                                                        --! [6]
                  o <= pf(5);
               end if;                                                     --! [6]
            when XXX_104 =>
               if r = '1' then                                             --! [7]
                  o <= pf(13);
               else                                                        --! [7]
                  o <= pf(6);
               end if;                                                     --! [7]
            when XXX_108 =>
               if r = '1' then                                             --! [8]
                  o <= pf(12);
               else                                                        --! [8]
                  o <= pf(7);
               end if;                                                     --! [8]
            when XXX_112 =>
               if r = '1' then                                             --! [9]
                  o <= pf(11);
               else                                                        --! [9]
                  o <= pf(8);
               end if;                                                     --! [9]
            when XXX_116 =>
               if r = '1' then                                             --! [10]
                  o <= pf(10);
               else                                                        --! [10]
                  o <= pf(9);
               end if;                                                     --! [10]
            when XXX_120 =>
               if r = '1' then                                             --! [11]
                  o <= pf(9);
               else                                                        --! [11]
                  o <= pf(10);
               end if;                                                     --! [11]
            when XXX_124 =>
               if r = '1' then                                             --! [12]
                  o <= pf(8);
               else                                                        --! [12]
                  o <= pf(11);
               end if;                                                     --! [12]
            when XXX_128 =>
               if r = '1' then                                             --! [13]
                  o <= pf(7);
               else                                                        --! [13]
                  o <= pf(12);
               end if;                                                     --! [13]
            when XXX_132 =>
               if r = '1' then                                             --! [14]
                  o <= pf(6);
               else                                                        --! [14]
                  o <= pf(13);
               end if;                                                     --! [14]
            when XXX_136 =>
               if r = '1' then                                             --! [15]
                  o <= pf(5);
               else                                                        --! [15]
                  o <= pf(14);
               end if;                                                     --! [15]
            when XXX_140 =>
               if r = '1' then                                             --! [16]
                  o <= pf(4);
               else                                                        --! [16]
                  o <= pf(15);
               end if;                                                     --! [16]
            when XXX_144 =>
               if r = '1' then                                             --! [17]
                  o <= pf(3);
               else                                                        --! [17]
                  o <= pf(16);
               end if;                                                     --! [17]
            when XXX_148 =>
               if r = '1' then                                             --! [18]
                  o <= pf(2);
               else                                                        --! [18]
                  o <= pf(17);
               end if;                                                     --! [18]
            when XXX_152 =>
               if r = '1' then                                             --! [19]
                  o <= pf(1);
               else                                                        --! [19]
                  o <= pf(18);
               end if;                                                     --! [19]
            when XXX_156 =>
               if r = '1' then                                             --! [20]
                  o <= pf(0);
               else                                                        --! [20]
                  o <= pf(19);
               end if;                                                     --! [20]
            when XXX_160 =>
               o <= '0';
            when others =>
         end case;
      end if;                                                              --! [0]
   end process;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.tia_components.all;

entity playerdraw is port
   (
      clk          : in std_logic;
      grold        : in std_logic_vector(7 downto 0);
      grnew        : in std_logic_vector(7 downto 0);
      r            : in std_logic;
      o_n          : in std_logic;
      o            : out std_logic;
      center       : out std_logic;
      nusiz        : in std_logic_vector(2 downto 0);
      position     : inout std_logic_vector(0 to 7);
      reset_strobe_in  : in std_logic;
      reset_strobe_out : inout std_logic
   );
end;

architecture playerdraw_architecture of playerdraw is
   signal drawme   : std_logic_vector(7 downto 0);
   signal counter  : std_logic_vector(4 downto 0);
   signal draw     : std_logic;
   signal maincopy : std_logic;
begin
   
   process (grold, grnew, o_n, r)
   begin
      if o_n = '1' then                                                    --! [0]
         if r = '0' then                                                   --! [1]
            drawme(0) <= grold(7);
            drawme(1) <= grold(6);
            drawme(2) <= grold(5);
            drawme(3) <= grold(4);
            drawme(4) <= grold(3);
            drawme(5) <= grold(2);
            drawme(6) <= grold(1);
            drawme(7) <= grold(0);
         else                                                              --! [1]
            drawme <= grold;
         end if;                                                           --! [1]
      else                                                                 --! [0]
         if r = '0' then                                                   --! [2]
            drawme(0) <= grnew(7);
            drawme(1) <= grnew(6);
            drawme(2) <= grnew(5);
            drawme(3) <= grnew(4);
            drawme(4) <= grnew(3);
            drawme(5) <= grnew(2);
            drawme(6) <= grnew(1);
            drawme(7) <= grnew(0);
         else                                                              --! [2]
            drawme <= grnew;
         end if;                                                           --! [2]
      end if;                                                              --! [0]
   end process;
   
   process (clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if nusiz = "111" then                                             --! [1]
            if draw = '1' or counter /= "00000" then                       --! [2]
               --odelay <= drawme(CONV_INTEGER(counter(4 downto 2))) & odelay(0 to 1);
               --o <= odelay(2);
               o <= drawme(CONV_INTEGER(counter(4 downto 2)));
               counter <= counter + "00001";
               
               if maincopy = '1' and counter(4 downto 2) = "100" then      --! [3]
                  center <= '1';
               else                                                        --! [3]
                  center <= '0';
               end if;                                                     --! [3]
               
            else                                                           --! [2]
               --odelay <= '0' & odelay(0 to 1);
               --o <= odelay(2);
               o <= '0';
               counter <= "00000";
            end if;                                                        --! [2]
         elsif nusiz = "101" then                                          --! [1]
            if draw = '1' or counter /= "00000" then                       --! [4]
               --odelay <= drawme(CONV_INTEGER(counter(3 downto 1))) & odelay(0 to 1);
               --o <= odelay(2);
               o <= drawme(CONV_INTEGER(counter(3 downto 1)));
               counter <= (counter + "00001") and "01111";
               
               if maincopy = '1' and counter(3 downto 1) = "100" then      --! [5]
                  center <= '1';
               else                                                        --! [5]
                  center <= '0';
               end if;                                                     --! [5]
               
            else                                                           --! [4]
               --odelay <= '0' & odelay(0 to 1);
               --o <= odelay(2);
               o <= '0';
               counter <= "00000";
            end if;                                                        --! [4]
         else                                                              --! [1]
            if draw = '1' or counter /= "00000" then                       --! [6]
               --odelay <= drawme(CONV_INTEGER(counter(2 downto 0))) & odelay(0 to 1);
               --o <= odelay(2);
               o <= drawme(CONV_INTEGER(counter(2 downto 0)));
               counter <= (counter + "00001") and "00111";
               
               if maincopy = '1' and counter(2 downto 0) = "100" then      --! [7]
                  center <= '1';
               else                                                        --! [7]
                  center <= '0';
               end if;                                                     --! [7]
               
            else                                                           --! [6]
               --odelay <= '0' & odelay(0 to 1);
               --o <= odelay(2);
               o <= '0';
               counter <= "00000";
            end if;                                                        --! [6]
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process (position, nusiz)
   begin
      if position = XXX_0 then                                             --! [0]
         maincopy <= '1';
      elsif position = XXX_16 then                                         --! [0]
         maincopy <= '0';
      end if;                                                              --! [0]
      
      case nusiz is
         when "000" =>
            if position = XXX_0 then                                       --! [1]
               draw <= '1';
            else                                                           --! [1]
               draw <= '0';
            end if;                                                        --! [1]
         when "001" =>
            if position = XXX_0 or position = XXX_16 then                  --! [2]
               draw <= '1';
            else                                                           --! [2]
               draw <= '0';
            end if;                                                        --! [2]
         when "010" =>
            if position = XXX_0 or position = XXX_32 then                  --! [3]
               draw <= '1';
            else                                                           --! [3]
               draw <= '0';
            end if;                                                        --! [3]
         when "011" =>
            if position = XXX_0 or position = XXX_16 or position = XXX_32 then --! [4]
               draw <= '1';
            else                                                           --! [4]
               draw <= '0';
            end if;                                                        --! [4]
         when "100" =>
            if position = XXX_0 or position = XXX_64 then                  --! [5]
               draw <= '1';
            else                                                           --! [5]
               draw <= '0';
            end if;                                                        --! [5]
         when "101" =>
            if position = XXX_0 then                                       --! [6]
               draw <= '1';
            else                                                           --! [6]
               draw <= '0';
            end if;                                                        --! [6]
         when "110" =>
            if position = XXX_0 or position = XXX_32 or position = XXX_64 then --! [7]
               draw <= '1';
            else                                                           --! [7]
               draw <= '0';
            end if;                                                        --! [7]
         when "111" =>
            if position = XXX_0 then                                       --! [8]
               draw <= '1';
            else                                                           --! [8]
               draw <= '0';
            end if;                                                        --! [8]
         when others =>
      end case;
   end process;
   
   process (clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if reset_strobe_in /= reset_strobe_out then                       --! [1]
            position <= XXX_153;
            reset_strobe_out <= reset_strobe_in;
         elsif ( position = XXX_INVALID or position = XXX_159) then        --! [1]
            position <= XXX_0;
         else                                                              --! [1]
            position <= (position(7) xor position(5) xor position(4) xor position(3)) & position(0 to 6);
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.tia_components.all;

entity balldraw is port
   (
      clk   : in std_logic;
      enold : in std_logic;
      ennew : in std_logic;
      o_n   : in std_logic;
      o     : out std_logic;
      w     : in std_logic_vector(1 downto 0);
      position     : inout std_logic_vector(0 to 7);
      reset_strobe_in  : in std_logic;
      reset_strobe_out : inout std_logic
   );
end;

architecture balldraw_architecture of balldraw is
   signal counter : std_logic_vector(2 downto 0);
   signal max : std_logic_vector(2 downto 0);
   signal draw : std_logic;
begin
   
   process(w)
   begin
      case w is
         when "00" =>
            max <= "000";
         when "01" =>
            max <= "001";
         when "10" =>
            max <= "011";
         when "11" =>
            max <= "111";
         when others =>
      end case;
   end process;
   
   process (clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if draw = '1' or counter /= "000" then                            --! [1]
            if (o_n = '1' and enold = '1') or (o_n = '0' and ennew = '1') then --! [2]
               o <= '1';
            else                                                           --! [2]
               o <= '0';
            end if;                                                        --! [2]
            counter <= (counter + "001") and max;
         else                                                              --! [1]
            o <= '0';
            counter <= "000";
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process (position)
   begin
      if position = "11111111" then                                        --! [0]
         draw <= '1';
      else                                                                 --! [0]
         draw <= '0';
      end if;                                                              --! [0]
   end process;
   
   process(clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if reset_strobe_in /= reset_strobe_out then                       --! [1]
            position <= XXX_154;
            reset_strobe_out <= reset_strobe_in;
         elsif ( position = XXX_INVALID or position = XXX_159) then        --! [1]
            position <= XXX_0;
         else                                                              --! [1]
            position <= (position(7) xor position(5) xor position(4) xor position(3)) & position(0 to 6);
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.tia_components.all;

entity missiledraw is port
   (
      clk   : in std_logic;
      en    : in std_logic;
      lock  : in std_logic;
      o     : out std_logic;
      nusiz : in std_logic_vector(2 downto 0);
      w     : in std_logic_vector(1 downto 0);
      position     : inout std_logic_vector(0 to 7);
      playerposition     : inout std_logic_vector(0 to 7);
      reset_strobe_in  : in std_logic;
      reset_strobe_out : inout std_logic;
      playerlock : in std_logic
   );
end;

architecture missiledraw_architecture of missiledraw is
   signal counter : std_logic_vector(2 downto 0);
   signal draw : std_logic;
   signal max : std_logic_vector(2 downto 0);
begin
   
   process(w)
   begin
      case w is
         when "00" =>
            max <= "000";
         when "01" =>
            max <= "001";
         when "10" =>
            max <= "011";
         when "11" =>
            max <= "111";
         when others =>
      end case;
   end process;
   
   process (clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if draw = '1' or counter /= "000" then                            --! [1]
            if en = '1' and lock = '0' then                                --! [2]
               o <=  '1';
            else                                                           --! [2]
               o <= '0';
            end if;                                                        --! [2]
            counter <= (counter + "001") and max;
         else                                                              --! [1]
            o <= '0';
            counter <= "000";
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process (position, nusiz)
   begin
      case nusiz is
         when "000" =>
            if position = XXX_0 then                                       --! [0]
               draw <= '1';
            else                                                           --! [0]
               draw <= '0';
            end if;                                                        --! [0]
         when "001" =>
            if position = XXX_0 or position = XXX_16 then                  --! [1]
               draw <= '1';
            else                                                           --! [1]
               draw <= '0';
            end if;                                                        --! [1]
         when "010" =>
            if position = XXX_0 or position = XXX_32 then                  --! [2]
               draw <= '1';
            else                                                           --! [2]
               draw <= '0';
            end if;                                                        --! [2]
         when "011" =>
            if position = XXX_0 or position = XXX_16 or position = XXX_32 then --! [3]
               draw <= '1';
            else                                                           --! [3]
               draw <= '0';
            end if;                                                        --! [3]
         when "100" =>
            if position = XXX_0 or position = XXX_64 then                  --! [4]
               draw <= '1';
            else                                                           --! [4]
               draw <= '0';
            end if;                                                        --! [4]
         when "101" =>
            if position = XXX_0 then                                       --! [5]
               draw <= '1';
            else                                                           --! [5]
               draw <= '0';
            end if;                                                        --! [5]
         when "110" =>
            if position = XXX_0 or position = XXX_32 or position = XXX_64 then --! [6]
               draw <= '1';
            else                                                           --! [6]
               draw <= '0';
            end if;                                                        --! [6]
         when "111" =>
            if position = XXX_0 then                                       --! [7]
               draw <= '1';
            else                                                           --! [7]
               draw <= '0';
            end if;                                                        --! [7]
         when others =>
      end case;
   end process;
   
   process (clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if playerlock = '1' then                                          --! [1]
            --position <= playerposition;
            if nusiz = "111" then                                          --! [2]
               -- minus 16
               position <=
               (playerposition(0) xor playerposition(1) xor playerposition(4) xor playerposition(5) xor playerposition(6) xor playerposition(7)) &
               (playerposition(0) xor playerposition(1) xor playerposition(2) xor playerposition(4) xor playerposition(7)) &
               (playerposition(0) xor playerposition(1) xor playerposition(2) xor playerposition(3) xor playerposition(4) xor playerposition(6)) &
               (playerposition(1) xor playerposition(2) xor playerposition(3) xor playerposition(4) xor playerposition(5) xor playerposition(7)) &
               (playerposition(0) xor playerposition(2) xor playerposition(3)) &
               (playerposition(1) xor playerposition(3) xor playerposition(4)) &
               (playerposition(2) xor playerposition(4) xor playerposition(5)) &
               (playerposition(3) xor playerposition(5) xor playerposition(6)) ;
            elsif nusiz = "101" then                                       --! [2]
               -- minus 8
               position <=
               (playerposition(0) xor playerposition(4) xor playerposition(5) xor playerposition(6)) &
               (playerposition(1) xor playerposition(5) xor playerposition(6) xor playerposition(7)) &
               (playerposition(0) xor playerposition(2) xor playerposition(4) xor playerposition(5) xor playerposition(7)) &
               (playerposition(0) xor playerposition(1) xor playerposition(3) xor playerposition(4)) &
               (playerposition(1) xor playerposition(2) xor playerposition(4) xor playerposition(5)) &
               (playerposition(2) xor playerposition(3) xor playerposition(5) xor playerposition(6)) &
               (playerposition(3) xor playerposition(4) xor playerposition(6) xor playerposition(7)) &
               (playerposition(0) xor playerposition(6) xor playerposition(7));
               
            else                                                           --! [2]
               -- minus 4
               position <=
               playerposition(4) &
               playerposition(5) &
               playerposition(6) &
               playerposition(7) &
               (playerposition(0) xor playerposition(4) xor playerposition(5) xor playerposition(6)) &
               (playerposition(1) xor playerposition(5) xor playerposition(6) xor playerposition(7)) &
               (playerposition(0) xor playerposition(2) xor playerposition(4) xor playerposition(5) xor playerposition(7)) &
               (playerposition(0) xor playerposition(1) xor playerposition(3) xor playerposition(4)) ;
            end if;                                                        --! [2]
         elsif reset_strobe_in /= reset_strobe_out then                    --! [1]
            position <= XXX_153;
            reset_strobe_out <= reset_strobe_in;
         elsif ( position = XXX_INVALID or position = XXX_159) then        --! [1]
            position <= XXX_0;
         else                                                              --! [1]
            position <= (position(7) xor position(5) xor position(4) xor position(3)) & position(0 to 6);
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.tia_components.all;

entity tia is port
   (
      
      -- clocks
      clk :         in    std_logic; -- input, colorburst * 30, digikey ECS-P83-B-ND @ 107.386364 MHz
      phi2:         in    std_logic; -- input, from processor
      
      a   :         in    std_logic_vector(5 downto 0);
      d   :         inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";
      i   :         inout std_logic_vector(0 to 5) := "ZZZZZZ";
      r_w :         in    std_logic;
      cs  :         in    std_logic_vector(3 downto 0);
      rdy :         out   std_logic := '1';
      
      l   :         out   std_logic_vector(3 downto 0);
      r   :         out   std_logic_vector(3 downto 0);
      v   :         out   std_logic_vector(7 downto 0) := "00000000";
      
      phi0:         out   std_logic := '0';
      
      zero:out   std_logic := '0';
      one:out   std_logic := '1';
      buttons:in    std_logic_vector(0 to 4);
      debug:        buffer   std_logic
   );
   
end tia;

architecture behavioral of tia is
   signal phaselfsr       : std_logic_vector(4 downto 0) := "11111";
   signal slowlfsr        : std_logic_vector(5 downto 0) := "011011";
   signal slowout         : std_logic := '0';
   
   type hat_state_type is (h1, idle1, h2, idle2);
   signal hatphase        : hat_state_type;
   
   signal cb_shifted      : std_logic_vector(1 to 15) := "100000001111111";
   signal h_at            : std_logic_vector(1 to 2) := "10";                --   output, colorburst/4, 12.5% duty cycle
   
   type hmove_delay_type is (d1, d2, d3);
   signal hmove_delay : hmove_delay_type := d1;
   
   type video_state_type is (vs0, vs1, vs2, vs3, vs4, vs5, vs6, vs7);
   signal video_state : video_state_type;
   signal serration : std_logic;
   
   signal horizontal_sync_counter : std_logic_vector(0 to 5) := "111111";
   
   -- declaring ram and strobes over the entire addressable range
   -- may seem wasteful, but a good synthesizer will optimize all
   -- the unused bits away, and it makes the code below MUCH cleaner.
   
   type regtype is array(0 to 63) of std_logic_vector(7 downto 0);
   signal regs : regtype :=
   (
      x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", -- 00 through 07
      x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", -- 08 through 0F
      x"00", x"00", x"00", x"00", x"00", x"0F", x"0F", x"00", -- 10 through 17
      x"00", x"0F", x"0F", x"00", x"00", x"00", x"00", x"00", -- 18 through 1F
      x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", -- 20 through 27
      x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", -- 28 through 2F
      x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", -- 30 through 37
      x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"  -- 38 through 3F
   );
   
   type strobetype is array(0 to 63) of std_logic_vector(1 downto 0);
   signal strobes : strobetype :=
   (
      "00", "00", "00", "00", "00", "00", "00", "00", -- 00 through 07
      "00", "00", "00", "00", "00", "00", "00", "00", -- 08 through 0F
      "00", "00", "00", "00", "00", "00", "00", "00", -- 10 through 17
      "00", "00", "00", "00", "00", "00", "00", "00", -- 18 through 1F
      "00", "00", "00", "00", "00", "00", "00", "00", -- 20 through 27
      "00", "00", "00", "00", "00", "00", "00", "00", -- 28 through 2F
      "00", "00", "00", "00", "00", "00", "00", "00", -- 30 through 37
      "00", "00", "00", "00", "00", "00", "00", "00"  -- 38 through 3F
   );
   
   signal cxM0P1 : std_logic := '0';
   signal cxM0P0 : std_logic := '0';
   signal cxM1P0 : std_logic := '0';
   signal cxM1P1 : std_logic := '0';
   signal cxP0PF : std_logic := '0';
   signal cxP0BL : std_logic := '0';
   signal cxP1PF : std_logic := '0';
   signal cxP1BL : std_logic := '0';
   signal cxM0PF : std_logic := '0';
   signal cxM0BL : std_logic := '0';
   signal cxM1PF : std_logic := '0';
   signal cxM1BL : std_logic := '0';
   signal cxBLPF : std_logic := '0';
   signal cxP0P1 : std_logic := '0';
   signal cxM0M1 : std_logic := '0';
   
   signal showM  : std_logic_vector(0 to 1) := "00";
   signal showP  : std_logic_vector(0 to 1) := "00";
   signal showPF : std_logic := '0';
   signal showBL : std_logic := '0';
   
   signal colu_out : std_logic_vector(7 downto 0);
   signal left : std_logic := '1';
   
   signal aclk : std_logic := '1';
   attribute clock_signal : string ;
   attribute clock_signal of aclk : signal is "yes";
   
   signal visible_clock : std_logic_vector(0 to 5);
   attribute clock_signal of visible_clock : signal is "yes";
   
   signal ilatch: std_logic_vector(4 to 5);
   
   type postype is array(0 to 1) of std_logic_vector(0 to 7);
   signal posP : postype;
   signal posM : postype;
   signal posBL : std_logic_vector(0 to 7);
   signal posPF : std_logic_vector(0 to 7);
   signal center : std_logic_vector(0 to 1);
   
   signal pfsync : std_logic;
   
   signal strobe_motion_counter : std_logic_vector(3 downto 0);
   signal hmove_ok : std_logic;
   signal hmove_complete : std_logic;
   
   signal button0mask : std_logic_vector(7 downto 0);
   signal button1mask : std_logic_vector(7 downto 0);
   signal button2mask : std_logic_vector(7 downto 0);
   signal button3mask : std_logic_vector(7 downto 0);
   signal button4mask : std_logic_vector(7 downto 0);
   
begin
   
   zero <= '0';
   one <= '1';
   
   --aco <= audio_clk;
   debug <= buttons(4);
   
   process (buttons)
   begin
      if buttons(0) = '0' then                                             --! [0]
         button0mask <= "11111111";
      else                                                                 --! [0]
         button0mask <= "00000000";
      end if;                                                              --! [0]
      if buttons(1) = '0' then                                             --! [1]
         button1mask <= "11111111";
      else                                                                 --! [1]
         button1mask <= "00000000";
      end if;                                                              --! [1]
      if buttons(2) = '0' then                                             --! [2]
         button2mask <= "11111111";
      else                                                                 --! [2]
         button2mask <= "00000000";
      end if;                                                              --! [2]
      if buttons(3) = '0' then                                             --! [3]
         button3mask <= "11111111";
      else                                                                 --! [3]
         button3mask <= "00000000";
      end if;                                                              --! [3]
      if buttons(4) = '0' then                                             --! [4]
         button4mask <= "00000000";
      else                                                                 --! [4]
         button4mask <= "11111111";
      end if;                                                              --! [4]
   end process;
   
   left_channel:  audiochannel port map
   (
      clk => aclk,
      f => regs(reg_AUDF0)(4 downto 0),
      v => regs(reg_AUDV0)(3 downto 0),
      c => regs(reg_AUDC0)(3 downto 0),
      o => l
   );
   
   right_channel: audiochannel port map
   (
      clk => aclk,
      f => regs(reg_AUDF1)(4 downto 0),
      v => regs(reg_AUDV1)(3 downto 0),
      c => regs(reg_AUDC1)(3 downto 0),
      o => r
   );
   
   playfield: playfielddraw port map
   (
      pf0 => regs(reg_PF0),
      pf1 => regs(reg_PF1),
      pf2 => regs(reg_PF2),
      position => posPF,
      sync => pfsync,
      clk => visible_clock(5),
      r => regs(reg_CTRLPF)(0),
      o => showPF,
      left => left
   );
   
   player0: playerdraw port map
   (
      clk => visible_clock(0),
      grold => regs(reg_GRP0old),
      grnew => regs(reg_GRP0),
      o_n => regs(reg_VDELP0)(0),
      r => regs(reg_REFP0)(3),
      o => showP(0),
      center => center(0),
      nusiz => regs(reg_NUSIZ0)(2 downto 0),
      position => posP(0),
      reset_strobe_in => strobes(reg_RESP0)(0),
      reset_strobe_out => strobes(reg_RESP0)(1)
   );
   
   player1: playerdraw port map
   (
      clk => visible_clock(1),
      grold => regs(reg_GRP1old),
      grnew => regs(reg_GRP1),
      o_n => regs(reg_VDELP1)(0),
      r => regs(reg_REFP1)(3),
      o => showP(1),
      center => center(1),
      nusiz => regs(reg_NUSIZ1)(2 downto 0),
      position => posP(1),
      reset_strobe_in => strobes(reg_RESP1)(0),
      reset_strobe_out => strobes(reg_RESP1)(1)
   );
   
   missile0: missiledraw port map
   (
      clk => visible_clock(2),
      en  => regs(reg_ENAM0)(1),
      lock => regs(reg_RESMP0)(1),
      o   => showM(0),
      nusiz => regs(reg_NUSIZ0)(2 downto 0),
      w => regs(reg_NUSIZ0)(5 downto 4),
      position => posM(0),
      playerposition => posP(0),
      reset_strobe_in => strobes(reg_RESM0)(0),
      reset_strobe_out => strobes(reg_RESM0)(1),
      playerlock => regs(reg_RESMP0)(1)
   );
   
   missile1: missiledraw port map
   (
      clk => visible_clock(3),
      en  => regs(reg_ENAM1)(1),
      lock => regs(reg_RESMP1)(1),
      o   => showM(1),
      nusiz => regs(reg_NUSIZ1)(2 downto 0),
      w => regs(reg_NUSIZ1)(5 downto 4),
      position => posM(1),
      playerposition => posP(1),
      reset_strobe_in => strobes(reg_RESM1)(0),
      reset_strobe_out => strobes(reg_RESM1)(1),
      playerlock => regs(reg_RESMP1)(1)
   );
   
   ball: balldraw port map
   (
      clk   => visible_clock(4),
      enold => regs(reg_ENABLold)(1),
      ennew => regs(reg_ENABL)(1),
      o_n   => regs(reg_VDELBL)(0),
      o     => showBL,
      w     => regs(reg_CTRLPF)(5 downto 4),
      position => posBL,
      reset_strobe_in => strobes(reg_RESBL)(0),
      reset_strobe_out => strobes(reg_RESBL)(1)
   );
   
   process (clk, horizontal_sync_counter)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if horizontal_sync_counter = HSC_0 or horizontal_sync_counter = HSC_28 then --! [1]
            aclk <= '1';
         elsif horizontal_sync_counter = HSC_14 or horizontal_sync_counter = HSC_42 then --! [1]
            aclk <= '0';
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(cb_shifted, showP, showM, showBL, showPF, regs(reg_VBLANK)(1), regs(reg_CTRLPF)(2 downto 1), left, regs(reg_COLUP0), regs(reg_COLUP1), regs(reg_COLUPF), regs(reg_COLUBK))
   begin
      if regs(reg_VBLANK)(1) = '1' then                                    --! [0]
         colu_out <= "00000000";
      else                                                                 --! [0]
         if (regs(reg_CTRLPF)(2) = '1') then                               --! [1]
            if (showPF = '1' or showBL = '1') then                         --! [2]
               if (regs(reg_CTRLPF)(1) = '1') then                         --! [3]
                  if (left = '1') then                                     --! [4]
                     colu_out <= regs(reg_COLUP0) xor button4mask;
                  else                                                     --! [4]
                     colu_out <= regs(reg_COLUP1) xor button4mask;
                  end if;                                                  --! [4]
               else                                                        --! [3]
                  colu_out <= regs(reg_COLUPF) xor button4mask;
               end if;                                                     --! [3]
            else                                                           --! [2]
               if (showM(0) = '1') then                                    --! [5]
                  colu_out <= regs(reg_COLUP0) xor button1mask;
               elsif (showP(0) = '1') then                                 --! [5]
                  colu_out <= regs(reg_COLUP0) xor button0mask;
               elsif (showM(1) = '1') then                                 --! [5]
                  colu_out <= regs(reg_COLUP1) xor button3mask;
               elsif (showP(1) = '1') then                                 --! [5]
                  colu_out <= regs(reg_COLUP1) xor button2mask;
               else                                                        --! [5]
                  colu_out <= regs(reg_COLUBK);
               end if;                                                     --! [5]
            end if;                                                        --! [2]
         else                                                              --! [1]
            if (showM(0) = '1') then                                       --! [6]
               colu_out <= regs(reg_COLUP0) xor button1mask;
            elsif (showP(0) = '1') then                                    --! [6]
               colu_out <= regs(reg_COLUP0) xor button0mask;
            elsif (showM(1) = '1') then                                    --! [6]
               colu_out <= regs(reg_COLUP1) xor button3mask;
            elsif (showP(1) = '1') then                                    --! [6]
               colu_out <= regs(reg_COLUP1) xor button2mask;
            else                                                           --! [6]
               if (showPF = '1' or showBL = '1') then                      --! [7]
                  if (regs(reg_CTRLPF)(1) = '1') then                      --! [8]
                     if (left = '1') then                                  --! [9]
                        colu_out <= regs(reg_COLUP0) xor button4mask;
                     else                                                  --! [9]
                        colu_out <= regs(reg_COLUP1) xor button4mask;
                     end if;                                               --! [9]
                  else                                                     --! [8]
                     colu_out <= regs(reg_COLUPF) xor button4mask;
                  end if;                                                  --! [8]
               else                                                        --! [7]
                  colu_out <= regs(reg_COLUBK);
               end if;                                                     --! [7]
            end if;                                                        --! [6]
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(clk)
   begin
      if (clk'event and clk = '1') then                                    --! [0]
         if (strobes(reg_CXCLR)(0) /= strobes(reg_CXCLR)(1)) then          --! [1]
            cxM0P0 <= '0';
            cxM0P1 <= '0';
            cxM0PF <= '0';
            cxM0BL <= '0';
            cxM1P0 <= '0';
            cxM1P1 <= '0';
            cxM1PF <= '0';
            cxM1BL <= '0';
            cxP0PF <= '0';
            cxP0BL <= '0';
            cxP1PF <= '0';
            cxP1BL <= '0';
            cxM0M1 <= '0';
            cxP0P1 <= '0';
            cxBLPF <= '0';
            strobes(reg_CXCLR)(1) <= strobes(reg_CXCLR)(0);
         else                                                              --! [1]
            cxM0P0 <= (cxM0P0 or (showM(0) and showP(0)));
            cxM0P1 <= (cxM0P1 or (showM(0) and showP(1)));
            cxM0PF <= (cxM0PF or (showM(0) and showPF));
            cxM0BL <= (cxM0BL or (showM(0) and showBL));
            cxM1P0 <= (cxM1P0 or (showM(1) and showP(0)));
            cxM1P1 <= (cxM1P1 or (showM(1) and showP(1)));
            cxM1PF <= (cxM1PF or (showM(1) and showPF));
            cxM1BL <= (cxM1BL or (showM(1) and showBL));
            cxP0PF <= (cxP0PF or (showP(0) and showPF));
            cxP0BL <= (cxP0BL or (showP(0) and showBL));
            cxP1PF <= (cxP1PF or (showP(1) and showPF));
            cxP1BL <= (cxP1BL or (showP(1) and showBL));
            cxM0M1 <= (cxM0M1 or (showM(0) and showM(1)));
            cxP0P1 <= (cxP0P1 or (showP(0) and showP(1)));
            cxBLPF <= (cxBLPF or (showBL and showPF));
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(clk)
   begin
      if (clk'event and clk = '1') then                                    --! [0]
         if (phaselfsr = "00111" or phaselfsr = "00000") then              --! [1]
            phaselfsr <= "11111";
         else                                                              --! [1]
            phaselfsr <= phaselfsr(3 downto 0) & (phaselfsr(4) xor phaselfsr(2));
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(clk, phaselfsr)
   begin
      if (clk'event and clk = '1') then                                    --! [0]
         if (phaselfsr = "11111") then                                     --! [1]
            
            cb_shifted(1) <= '1';
            
            -- begin stuffing logic
            --if hatphase = h1 then
            --if hatphase = idle1 then
            if hatphase = h2 then                                          --! [2]
               --if hatphase = idle2 then
               
               if strobes(reg_HMOVE)(0) /= strobes(reg_HMOVE)(1)  then     --! [3]
                  case hmove_delay is
                     when d1 =>
                        hmove_delay <= d2;
                     when d2 =>
                        hmove_delay <= d3;
                     when d3 =>
                        hmove_delay <= d1;
                        strobe_motion_counter <= "0000";
                        hmove_complete <= '0';
                        strobes(reg_HMOVE)(1) <= strobes(reg_HMOVE)(0);
                     when others =>
                  end case;
               elsif hmove_complete = '0' then                             --! [3]
                  if strobe_motion_counter = "1111" then                   --! [4]
                     hmove_complete <= '1';
                  else                                                     --! [4]
                     strobe_motion_counter <= strobe_motion_counter + "0001";
                  end if;                                                  --! [4]
               end if;                                                     --! [3]
               
               if video_state /= vs6 then                                  --! [5]
                  if hmove_complete = '0' then                             --! [6]
                     
                     if strobe_motion_counter < ((not regs(reg_HMP0)(7)) & regs(reg_HMP0)(6 downto 4)) then --! [7]
                        -- actual pulse stuffing here
                        visible_clock(0) <= '1';
                     end if;                                               --! [7]
                     
                     if strobe_motion_counter < ((not regs(reg_HMP1)(7)) & regs(reg_HMP1)(6 downto 4)) then --! [8]
                        visible_clock(1) <= '1';
                     end if;                                               --! [8]
                     
                     if strobe_motion_counter < ((not regs(reg_HMM0)(7)) & regs(reg_HMM0)(6 downto 4)) then --! [9]
                        visible_clock(2) <= '1';
                     end if;                                               --! [9]
                     
                     if  strobe_motion_counter < ((not regs(reg_HMM1)(7)) & regs(reg_HMM1)(6 downto 4)) then --! [10]
                        visible_clock(3) <= '1';
                     end if;                                               --! [10]
                     
                     if strobe_motion_counter < ((not regs(reg_HMBL)(7)) & regs(reg_HMBL)(6 downto 4)) then --! [11]
                        visible_clock(4) <= '1';
                     end if;                                               --! [11]
                     
                     if strobe_motion_counter < ("1000") then              --! [12]
                        visible_clock(5) <= '1';
                     end if;                                               --! [12]
                     
                  end if;                                                  --! [6]
               end if;                                                     --! [5]
            end if;                                                        --! [2]
            -- end of stuffing logic
            
            if video_state = vs6 then                                      --! [13]
               visible_clock <= "111111";
            end if;                                                        --! [13]
            
            case hatphase is
               when h1 =>
                  h_at(1) <= '1';
                  hatphase <= idle1;
               when idle1 =>
                  hatphase <= h2;
               when h2 =>
                  h_at(2) <= '1';
                  hatphase <= idle2;
                  if                                                       --! [14]
                     (
                        horizontal_sync_counter = HSC_INVALID or
                        horizontal_sync_counter = HSC_56
                        -- or strobes(reg_RSYNC)(0) /= strobes(reg_RSYNC)(1)
                     ) then
                     horizontal_sync_counter <= HSC_0;
                     strobes(reg_RSYNC)(1) <= strobes(reg_RSYNC)(0);
                  else                                                     --! [14]
                     horizontal_sync_counter <= (horizontal_sync_counter(4) xor horizontal_sync_counter(5)) & horizontal_sync_counter(0 to 4);
                  end if;                                                  --! [14]
               when idle2 =>
                  hatphase <= h1;
            end case;
         elsif (phaselfsr = "11110") then                                  --! [1]
            cb_shifted(9) <= '0';
         elsif (phaselfsr = "11100") then                                  --! [1]
            cb_shifted(2) <= '1';
         elsif (phaselfsr = "11000") then                                  --! [1]
            cb_shifted(10) <= '0';
         elsif (phaselfsr = "10001") then                                  --! [1]
            cb_shifted(3) <= '1';
         elsif (phaselfsr = "00011") then                                  --! [1]
            cb_shifted(11) <= '0';
         elsif (phaselfsr = "00110") then                                  --! [1]
            cb_shifted(4) <= '1';
         elsif (phaselfsr = "01101") then                                  --! [1]
            cb_shifted(12) <= '0';
         elsif (phaselfsr = "11011") then                                  --! [1]
            cb_shifted(5) <= '1';
         elsif (phaselfsr = "10111") then                                  --! [1]
            cb_shifted(13) <= '0';
         elsif (phaselfsr = "01110") then                                  --! [1]
            cb_shifted(6) <= '1';
         elsif (phaselfsr = "11101") then                                  --! [1]
            cb_shifted(14) <= '0';
         elsif (phaselfsr = "11010") then                                  --! [1]
            cb_shifted(7) <= '1';
         elsif (phaselfsr = "10101") then                                  --! [1]
            cb_shifted(15) <= '0';
         elsif (phaselfsr = "01010") then                                  --! [1]
            cb_shifted(8) <= '1';
         elsif (phaselfsr = "10100") then                                  --! [1]
            cb_shifted(1) <= '0';
            h_at(1) <= '0';
            h_at(2) <= '0';
            visible_clock <= "000000";
         elsif (phaselfsr = "01000") then                                  --! [1]
            cb_shifted(9) <= '1';
         elsif (phaselfsr = "10000") then                                  --! [1]
            cb_shifted(2) <= '0';
         elsif (phaselfsr = "00001") then                                  --! [1]
            cb_shifted(10) <= '1';
         elsif (phaselfsr = "00010") then                                  --! [1]
            cb_shifted(3) <= '0';
         elsif (phaselfsr = "00100") then                                  --! [1]
            cb_shifted(11) <= '1';
         elsif (phaselfsr = "01001") then                                  --! [1]
            cb_shifted(4) <= '0';
         elsif (phaselfsr = "10010") then                                  --! [1]
            cb_shifted(12) <= '1';
         elsif (phaselfsr = "00101") then                                  --! [1]
            cb_shifted(5) <= '0';
         elsif (phaselfsr = "01011") then                                  --! [1]
            cb_shifted(13) <= '1';
         elsif (phaselfsr = "10110") then                                  --! [1]
            cb_shifted(6) <= '0';
         elsif (phaselfsr = "01100") then                                  --! [1]
            cb_shifted(14) <= '1';
         elsif (phaselfsr = "11001") then                                  --! [1]
            cb_shifted(7) <= '0';
         elsif (phaselfsr = "10011") then                                  --! [1]
            cb_shifted(15) <= '1';
         elsif (phaselfsr = "00111") then                                  --! [1]
            cb_shifted(8) <= '0';
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(clk, slowlfsr)
   begin
      if (clk'event and clk = '1') then                                    --! [0]
         if (slowlfsr = "011011" or slowlfsr = "000000") then              --! [1]
            slowlfsr <= "111111";
            slowout <= not slowout;
            phi0 <= not slowout;
         else                                                              --! [1]
            slowlfsr <= slowlfsr(4 downto 0) & (slowlfsr(5) xor slowlfsr(4));
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(phi2)
   begin
      if (phi2'event and phi2 = '1') then                                  --! [0]
         if (cs = "0010" and r_w = '1') then                               --! [1]
            case a(3 downto 0) is
               when "0000" =>
                  d(7) <= cxM0P1;
                  d(6) <= cxM0P0;
               when "0001" =>
                  d(7) <= cxM1P0;
                  d(6) <= cxM1P1;
               when "0010" =>
                  d(7) <= cxP0PF;
                  d(6) <= cxP0BL;
               when "0011" =>
                  d(7) <= cxP1PF;
                  d(6) <= cxP1BL;
               when "0100" =>
                  d(7) <= cxM0PF;
                  d(6) <= cxM0BL;
               when "0101" =>
                  d(7) <= cxM1PF;
                  d(6) <= cxM1BL;
               when "0110" =>
                  d(7) <= cxBLPF;
               when "0111" =>
                  d(7) <= cxP0P1;
                  d(6) <= cxM0M1;
               when "1000" =>
                  d(7) <= i(0);
               when "1001" =>
                  d(7) <= i(1);
               when "1010" =>
                  d(7) <= i(2);
               when "1011" =>
                  d(7) <= i(3);
               when "1100" =>
                  if regs(reg_VBLANK)(6) = '1' then                        --! [2]
                     d(7) <= ilatch(4);
                  else                                                     --! [2]
                     d(7) <= i(4);
                  end if;                                                  --! [2]
               when "1101" =>
                  if regs(reg_VBLANK)(6) = '1' then                        --! [3]
                     d(7) <= ilatch(5);
                  else                                                     --! [3]
                     d(7) <= i(5);
                  end if;                                                  --! [3]
               when others =>
                  d <= "ZZZZZZZZ";
            end case;
         else                                                              --! [1]
            d <= "ZZZZZZZZ";
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process(phi2)
   begin
      if (phi2'event and phi2 = '0') then                                  --! [0]
         if (cs = "0010" and r_w = '0') then                               --! [1]
            
            regs(CONV_INTEGER(a)) <= d;
            strobes(CONV_INTEGER(a))(0) <= not strobes(CONV_INTEGER(a))(0);
            
            if (CONV_INTEGER(a) = reg_GRP0) then                           --! [2]
               regs(reg_GRP1old) <= regs(reg_GRP1);
            end if;                                                        --! [2]
            
            if (CONV_INTEGER(a) = reg_GRP1) then                           --! [3]
               regs(reg_GRP0old) <= regs(reg_GRP0);
               regs(reg_ENABLold) <= regs(reg_ENABL);
            end if;                                                        --! [3]
            
            --if (CONV_INTEGER(a) = reg_HMCLR) then
            if a = "101011" then                                           --! [4]
               regs(reg_HMP0) <= "00000000";
               regs(reg_HMP1) <= "00000000";
               regs(reg_HMM0) <= "00000000";
               regs(reg_HMM1) <= "00000000";
               regs(reg_HMBL) <= "00000000";
            end if;                                                        --! [4]
            
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process (clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if strobes(reg_WSYNC)(0) /= strobes(reg_WSYNC)(1) then            --! [1]
            if horizontal_sync_counter = HSC_0 then                        --! [2]
               rdy <= '1';
               strobes(reg_WSYNC)(1) <= strobes(reg_WSYNC)(0);
            else                                                           --! [2]
               rdy <= '0';
            end if;                                                        --! [2]
         else                                                              --! [1]
            rdy <= '1';
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process (strobes(reg_HMOVE), video_state)
   begin
      if                                                                   --! [0]
         (
            strobes(reg_HMOVE)(0) /= strobes(reg_HMOVE)(1) and
            video_state /= vs6 and
            horizontal_sync_counter /= HSC_19 and
            horizontal_sync_counter /= HSC_18 and
            horizontal_sync_counter /= HSC_17 and
            horizontal_sync_counter /= HSC_16
         ) then
         hmove_ok <= '1';
      elsif video_state = vs6 then                                         --! [0]
         hmove_ok <= '0';
      end if;                                                              --! [0]
   end process;
   
   process (clk)
   begin
      if clk'event and clk = '1' then                                      --! [0]
         if horizontal_sync_counter = HSC_3 then                           --! [1]
            video_state <= vs0;
         elsif horizontal_sync_counter = HSC_4 then                        --! [1]
            video_state <= vs1;
         elsif horizontal_sync_counter = HSC_9 then                        --! [1]
            video_state <= vs2;
         elsif horizontal_sync_counter = HSC_10 then                       --! [1]
            video_state <= vs3;
         elsif horizontal_sync_counter = HSC_12 then                       --! [1]
            video_state <= vs4;
         elsif horizontal_sync_counter = HSC_13 then                       --! [1]
            video_state <= vs5;
         elsif horizontal_sync_counter = HSC_17 then                       --! [1]
            if hmove_ok = '0' then                                         --! [2]
               video_state <= vs6;
            end if;                                                        --! [2]
            pfsync <= '0';
         elsif horizontal_sync_counter = HSC_19 then                       --! [1]
            video_state <= vs6;
         elsif horizontal_sync_counter = HSC_0 then                        --! [1]
            video_state <= vs7;
            pfsync <= '1';
         end if;                                                           --! [1]
      end if;                                                              --! [0]
   end process;
   
   process (clk, horizontal_sync_counter)
   begin
      if horizontal_sync_counter = HSC_3 then                              --! [0]
         serration <= '0';
      elsif horizontal_sync_counter = HSC_27 then                          --! [0]
         serration <= '1';
      elsif horizontal_sync_counter = HSC_31 then                          --! [0]
         serration <= '0';
      elsif horizontal_sync_counter = HSC_56 then                          --! [0]
         serration <= '1';
      end if;                                                              --! [0]
   end process;
   
   process (video_state, cb_shifted, colu_out,regs(reg_VSYNC)(1), serration)
   begin
      if regs(reg_VSYNC)(1) = '0' then                                     --! [0]
         case video_state is
            when vs0 =>
               -- front porch
               v <= IRE_0;
            when vs1 =>
               -- sync
               v <= IRE_n40;
            when vs2 =>
               -- back start
               v <= IRE_0;
            when vs3 =>
               -- colorburst
               if cb_shifted(1) = '0' then                                 --! [1]
                  v <= IRE_n20;
               else                                                        --! [1]
                  v <= IRE_p20;
               end if;                                                     --! [1]
            when vs4 =>
               -- back end
               v <= IRE_0;
            when vs5 =>
               -- left edge
               v <= IRE_p10;
            when vs6 =>
               -- active video
               if colu_out(7 downto 4) = "0000" then                       --! [2]
                  case colu_out(3 downto 1) is
                     when "000" =>
                        v <= IRE_p10;
                     when "001" =>
                        v <= IRE_p20;
                     when "010" =>
                        v <= IRE_p30;
                     when "011" =>
                        v <= IRE_p40;
                     when "100" =>
                        v <= IRE_p50;
                     when "101" =>
                        v <= IRE_p60;
                     when "110" =>
                        v <= IRE_p70;
                     when "111" =>
                        v <= IRE_p80;
                     when others =>
                  end case;
               else                                                        --! [2]
                  case colu_out(3 downto 1) is
                     when "000" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [3]
                           v <= IRE_n10;
                        else                                               --! [3]
                           v <= IRE_p30;
                        end if;                                            --! [3]
                     when "001" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [4]
                           v <= IRE_0;
                        else                                               --! [4]
                           v <= IRE_p40;
                        end if;                                            --! [4]
                     when "010" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [5]
                           v <= IRE_p10;
                        else                                               --! [5]
                           v <= IRE_p50;
                        end if;                                            --! [5]
                     when "011" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [6]
                           v <= IRE_p20;
                        else                                               --! [6]
                           v <= IRE_p60;
                        end if;                                            --! [6]
                     when "100" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [7]
                           v <= IRE_p30;
                        else                                               --! [7]
                           v <= IRE_p70;
                        end if;                                            --! [7]
                     when "101" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [8]
                           v <= IRE_p40;
                        else                                               --! [8]
                           v <= IRE_p80;
                        end if;                                            --! [8]
                     when "110" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [9]
                           v <= IRE_p50;
                        else                                               --! [9]
                           v <= IRE_p90;
                        end if;                                            --! [9]
                     when "111" =>
                        if cb_shifted(CONV_INTEGER(colu_out(7 downto 4))) = '0' then --! [10]
                           v <= IRE_p60;
                        else                                               --! [10]
                           v <= IRE_p100;
                        end if;                                            --! [10]
                     when others =>
                  end case;
               end if;                                                     --! [2]
            when vs7 =>
               -- right edge
               v <= IRE_p10;
         end case;
      else                                                                 --! [0]
         if serration = '1' then                                           --! [11]
            v <= IRE_0;
         else                                                              --! [11]
            v <= IRE_n40;
         end if;                                                           --! [11]
      end if;                                                              --! [0]
   end process;
   
   process (regs(reg_VBLANK)(7), regs(reg_VBLANK)(6), i(4), i(5))
   begin
      if regs(reg_VBLANK)(7) = '1' then                                    --! [0]
         i(0 to 3) <= "0000";
      else                                                                 --! [0]
         i(0 to 3) <= "ZZZZ";
      end if;                                                              --! [0]
      if regs(reg_VBLANK)(6) = '1' then                                    --! [1]
         ilatch(4 to 5) <= "ZZ";
         ilatch(4) <= ilatch(4) and i(4);
         ilatch(5) <= ilatch(5) and i(5);
      else                                                                 --! [1]
         ilatch(4 to 5) <= "11";
      end if;                                                              --! [1]
   end process;
   
end behavioral;
