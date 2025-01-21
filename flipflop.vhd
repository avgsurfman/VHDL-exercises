-------------------------------------------------------------------------------
--
-- Title       : flipflop
-- Design      : lab56
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : flipflop.vhd
-- Generated   : Tue Jan 14 12:29:14 2025
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {flipflop} architecture {flipflop}}

-- FPGA projects using VHDL/ VHDL 
-- fpga4student.com
-- VHDL code for D Flip FLop
-- VHDL code for rising edge D flip flop 
Library IEEE;
USE IEEE.Std_logic_1164.all;

entity RisingEdge_DFlipFlop is 
   port(  
   D :in  std_logic;
   Clk : in std_logic;
   Q: out std_logic;
   nQ: out std_logic
   );
end RisingEdge_DFlipFlop;				  

architecture Behavioral of RisingEdge_DFlipFlop is  
begin  
 process(Clk)
 begin 
    if(rising_edge(Clk)) then
   Q <= D; 
    end if;       
 end process;  
end Behavioral; 
