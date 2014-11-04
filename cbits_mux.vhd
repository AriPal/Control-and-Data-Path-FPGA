library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL; 


entity cbits_mux is

	generic(N : integer := 8);
	
	port(
		from_latch : in std_logic_vector(N-1 downto 0);
		from_RAM : in std_logic_vector(N-1 downto 0);
		cM : in std_logic;
		to_cbits_cntr : out std_logic_vector(N-1 downto 0)
	);
end cbits_mux;

architecture Behavioral of cbits_mux is

begin

process(from_latch, from_RAM ,cM)
begin
case cM is
  when '1' => to_cbits_cntr <= from_latch;
  when '0' => to_cbits_cntr <= from_RAM;
  when others => NULL;  
end case; 
end process;

end Behavioral;

