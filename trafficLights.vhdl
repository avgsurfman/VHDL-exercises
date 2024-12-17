library IEEE;

entity TrafficLight is
port(
W,Clk : in BIT;
Czerwony, Zolty, Zielony : out BIT
);
end entity;

architecture TrafficLight of TrafficLight is
component Opis_D_FF
	port (D,Clk : in BIT;
	Q : out BIT := '0';
	nQ : out BIT := '0';	
	R : in BIT := '0';
	R_sync : in BIT := '0'
);
end component;

--deklaracje sygnałów
signal stan: bit_vector(1 downto 0);
signal nQ : bit_vector(1 downto 0);
signal R : BIT;
signal R_sync : BIT;

begin
	R <= '0';
	R_sync <= '0';
	process
	begin
		-- https://www.edaboard.com/threads/whats-vhdl-equivalent-to-verilog-initial-block.28862/
		-- instead of initial
		stan <= "00";
		nQ <= "11";
		wait;
	end process;
	stan(1) <= (stan(0) and W) or (stan(0) and stan(1)) or (stan(1) and not(W));
	stan(0) <= (stan(1) and W) or (not(stan(0)) and stan(1)) or (stan(1) and not(W));
	S1 : entity Opis_D_FF port map(stan(1), Clk, );
	S0 : entity Opis_D_FF port map(stan(0), Clk, );
	Czerwony <= (stan(0) nor stan(1)) or (not(stan(1)) and stan(0) and not(W)) or (stan(1) and not(stan(0)) and W);
	Zolty <= ((stan(0) nor stan(1)) and W) or (not(stan(0)) and stan(1) and not(W)) or (stan(0) and stan(1) and W) or (stan(0) and not(stan(0)) and not(W));
	Zielony <= (not(stan(0)) and stan(1) and W) or (stan(0) and stan(1) and not(W));
end architecture;