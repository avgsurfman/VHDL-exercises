library IEEE;

USE IEEE.Std_logic_1164.all;

entity TrafficLight is
port(
W,Clk : in BIT;
Czerwony, Zolty, Zielony : out BIT
);
end entity;

architecture TrafficLightBIT of TrafficLight is
component Opis_D_FF
	port (D,Clk : in BIT;
	Q : out BIT := '0';
	nQ : out BIT := '0';	
	R : in BIT := '0';
	R_sync : in BIT := '0'
);
end component;

--deklaracje sygna³ów
signal stan: bit_vector(1 downto 0); --stan: new state	
signal Q : bit_vector(1 downto 0);
signal nQ : bit_vector(1 downto 0); --nQ -> present negated state
signal R : BIT;
signal R_sync : BIT;


begin
	R <= '0';
	R_sync <= '0';
	process(Clk) begin
			if now < 1ps then
			---- https://www.edaboard.com/threads/whats-vhdl-equivalent-to-verilog-initial-block.28862/
			-- VHDL's initial
			stan <= "00";
		else
			stan(1) <= (Q(0) and W) or (Q(0) and Q(1)) or (Q(1) and not(W));
			stan(0) <= (Q(1) and W) or (nQ(0) and Q(1)) or (Q(1) and not(W));
			assert ((Q(0) and W)='1') report "Triggered" severity note;
		end if;
	end process;
	S1 : entity D_FF port map(stan(1), Clk, Q(1), nQ(1), R, R_sync);
	S0 : entity D_FF port map(stan(0), Clk, Q(0), nQ(0), R, R_sync);
		-- ABOVE DOESN'T WORK IN ALDEC 13
		----https://groups.google.com/g/eda-playground/c/MtEqk-pbwuE
		----Signals are like semaphores, can't write to them from multiple sources
		----bit type causes a compilation error, and the STD_Logic shows a short-circut
	--end process;
	-- Stan_1 <= (nQ(0) nor not(W)) or  (nQ(0) nor nQ(2)) or  (nQ(1) nor W) --> Simplified and optimized expr
	-- Stan_0 <= (nQ(1) nor not(W)) or (nQ and not(nQ(1))) or (nQ(1) nor W)
	--stan(1) <= (nQ(0) nor not(W)) or  (nQ(0) nor nQ(1)) or  (nQ(1) nor W); --> Simplified and optimized expr
	--stan(0) <= (nQ(1) nor not(W)) or (nQ(0) and Q(1)) or (nQ(1) nor W);
	

	-- https://stackoverflow.com/questions/19412165/how-to-ignore-output-ports-with-port-maps
	-- ((0) nor Q(1))
	Czerwony <= (stan(0) nor stan(1)) or (not(stan(1)) and stan(0) and not(W)) or (stan(1) and not(stan(0)) and W);
	Zolty <= ((stan(0) nor stan(1)) and W) or (not(stan(0)) and stan(1) and not(W)) or (stan(0) and stan(1) and W) or (stan(0) and not(stan(0)) and not(W));
	Zielony <= (not(stan(0)) and stan(1) and W) or (stan(0) and stan(1) and not(W));
end architecture;

		
