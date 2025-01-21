library IEEE;

USE IEEE.Std_logic_1164.all;

entity TrafficLight is
port(
W,Clk : in std_logic;
Czerwony, Zolty, Zielony : out std_logic
);
end entity;

architecture TrafficLightSTD of TrafficLight is
component RisingEdge_DFlipFlop
port(  
   D :in  std_logic;
   Clk : in std_logic;
   Q: out std_logic;
   nQ: out std_logic
   );
end component;

--deklaracje sygna³ów
signal stan: std_logic_vector(1 downto 0):= "00"; --stan: new state	
signal Q : std_logic_vector(1 downto 0) := "00";
signal nQ : std_logic_vector(1 downto 0) := "11"; --nQ -> present negated state

begin
	process begin 
		---- https://www.edaboard.com/threads/whats-vhdl-equivalent-to-verilog-initial-block.28862/
		-- VHDL's initial
		stan <= "00";
		Q <= "00";
        nQ <= "11";
		wait;
	end process;
	    ----NOTE: Doesn't work in Aldec 8. 
		----https://groups.google.com/g/eda-playground/c/MtEqk-pbwuE
		----Signals are treated like semaphores, can't write to them from multiple sources
		----Bit type causes a compilation error, and the STD_Logic shows a short-circut
	--end process;
	-- Stan_1 <= (nQ(0) nor not(W)) or  (nQ(0) nor nQ(2)) or  (nQ(1) nor W) --> Simplified and optimized expr
	-- Stan_0 <= (nQ(1) nor not(W)) or (nQ and not(nQ(1))) or (nQ(1) nor W)
	--stan(1) <= (nQ(0) nor not(W)) or  (nQ(0) nor nQ(1)) or  (nQ(1) nor W); --> Simplified and optimized expr
	--stan(0) <= (nQ(1) nor not(W)) or (nQ(0) and Q(1)) or (nQ(1) nor W);
	stan(1) <= (Q(0) and W) or (Q(0) and Q(1)) or (Q(1) and not(W));
	stan(0) <= (Q(1) and W) or (nQ(0) and Q(1)) or (Q(1) and not(W));
	-- work keyword necessary in Aldec 13 and above
	S1 : entity work.RisingEdge_DFlipFlop port map(stan(1), Clk, Q(1), nQ(1));
	S0 : entity work.RisingEdge_DFlipFlop port map(stan(0), Clk, Q(0), nQ(0));
	
	Czerwony <= (stan(0) nor stan(1)) or (not(stan(1)) and stan(0) and not(W)) or (stan(1) and not(stan(0)) and W);
	Zolty <= ((stan(0) nor stan(1)) and W) or (not(stan(0)) and stan(1) and not(W)) or (stan(0) and stan(1) and W) or (stan(0) and not(stan(0)) and not(W));
	Zielony <= (not(stan(0)) and stan(1) and W) or (stan(0) and stan(1) and not(W));
end architecture;

		