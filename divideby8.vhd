library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is like magic trick, if you divide 8 by any binary bits. You will notice that we shift the numerator 
-- three bits to the left, and add three zeros. Look at this example, 
-- 11110111 / 1000 = 0001 1110. Notice we shift in 000 to left, and shift out 111. Take notice the remainder is the
-- first three bits in the numerator 111. 
-- Since this "magic" works everytime. We applie this to our code.  

entity divideby8 is
  
  port ( 
  
	clk, reset : in std_logic; 
	RAM : in std_logic_vector(7 downto 0); -- If 1111 0111
	q : out std_logic_vector(7 downto 3); --  Then 0001 1101
	r : out std_logic_vector(2 downto 0) -- Then 111
  
  ); 

end divideby8;

architecture Behavioral of divideby8 is 

begin
   -- register
	   process(clk,reset)
	   begin
		  if (reset='1') then
			 q <= (others => '0');
			 r <= (others => '0');
		  elsif (clk'event and clk='1') then
			 q <= RAM(7 downto 3); -- 0001 1101
			 r <= RAM(2 downto 0); -- 111
		  end if;
	   end process;


	
end Behavioral;