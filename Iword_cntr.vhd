
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL; 

entity Iword_cntr is

	generic( N : integer := 8);
	
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  q : in std_logic_vector(N-1 downto 3); 
           iL : in  STD_LOGIC;
           iD : in  STD_LOGIC;
           count_one1 : out  STD_LOGIC; 
           count_zero1 : out  STD_LOGIC);
end Iword_cntr;

architecture Behavioral of Iword_cntr is

signal r_reg : unsigned(N-1 downto 3); 
signal r_next : unsigned(N-1 downto 3);  

begin
-- register 

	process(clk, reset)
	begin 
		if(reset = '1') then
			r_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			r_reg <= r_next; 
		end if; 
	end process; 


	r_next <= 
				unsigned(q) when iL = '1' else -- We iL the bits into the component. 
				r_reg - 1 when iD = '1' else -- If iD is 1, we count down. 
			   r_reg; 
				
-- output logic
		 count_one1 <= '1' when r_reg = "00001" else '0';
		 count_zero1 <= '1' when r_reg = "00000" else '0';
end Behavioral;

