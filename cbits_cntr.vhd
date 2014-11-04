
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL; 

entity cbits_cntr is
   
	generic(N : integer := 8); -- Is this correct? 
	
	Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cL : in  STD_LOGIC;
           cD : in  STD_LOGIC;
           count_zero2 : out  STD_LOGIC;
           count_one2 : out  STD_LOGIC;
           from_mux : in  STD_LOGIC_VECTOR(N-1 downto 0));
			  
end cbits_cntr;

architecture Behavioral of cbits_cntr is

signal r_reg : unsigned(N-1 downto 0); 
signal r_next : unsigned(N-1 downto 0);  

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
				unsigned(from_mux) when cL = '1' else -- We load the bits into the component. 
				r_reg - 1 when cD = '1' else -- If decrement is 1, we count down. 
			   r_reg; 
				
-- output logic
		 count_one2 <= '1' when r_reg = "00000001" else '0';
		 count_zero2 <= '1' when r_reg = "00000000" else '0';
end Behavioral;