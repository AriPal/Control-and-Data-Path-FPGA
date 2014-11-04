	-- Modulus counter for the T FF adapted from P. Chu's Listing 4.11

	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

	entity rbits_ltch is
	   generic(
		  N: integer := 8     -- number of bits
	  );
	   port(
		  clk, reset, rL: in std_logic;
		  r: in std_logic_vector(2 downto 0);
		  r_bit_one: out std_logic_vector(N-1 downto 0); 
		  r_bit_zero: out std_logic ); 
		  
	end rbits_ltch;

	architecture Behavioral of rbits_ltch is
	   signal r_reg: unsigned(2 downto 0);
	   signal r_next: unsigned(2 downto 0);
	begin
	   -- register
	   process(clk,reset)
	   begin
		  if (reset='1') then
			 r_reg <=(others =>'0');
		  elsif (clk'event and clk='1') then
			 r_reg <= r_next;
		  end if;
	   end process; 

	-- next-state logic

	r_next <= 
				unsigned(r) when rL = '1' else -- We rL the bits into the component. 
			   r_reg;
				
	-- output logic
		 r_bit_zero <= '1' when r_reg = 0 else '0';
		 r_bit_one <= "00000" & std_logic_vector(r_reg) when r_reg > 0 else (others => '0'); -- 00000 + xxx
end Behavioral;