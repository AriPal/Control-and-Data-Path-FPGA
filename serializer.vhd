
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity serializer is
	port(
			from_RAM : in std_logic_vector(7 downto 0);
			sL : in std_logic;
			sS : in std_logic;
			clk, reset : in std_logic;
			to_TDI : out std_logic
	);
end serializer;

architecture Behavioral of serializer is
	signal r_reg, r_next : std_logic_vector(7 downto 0);
begin
	--register
	process(clk, reset)
	begin
		if(reset = '1') then
			r_reg <= (others => '0');
		elsif(clk'event and clk = '1') then
			r_reg <= r_next;
		end if;
	end process;
	
	--next-state logic
	r_next <= 
		from_RAM(7 downto 0) when sL = '1' else
		from_RAM(7) & r_reg(7 downto 1) when sS = '1' else
		r_reg;
		
	--output to TDI
	to_TDI <= r_reg(0);

end Behavioral;

