
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main is
generic(

      DATA_WIDTH : integer:=8;
		q_size : integer:=5;
		r_size : integer:=3
   );

port (
		clk, reset : in std_logic; 
		RAM_content : in std_logic_vector(DATA_WIDTH-1 downto 0);
		
		load : in std_logic;
		decrement : in std_logic; 
		shift : in std_logic; 
		cM : in std_logic; 
		X : in std_logic_vector(7 downto 0); 
		
		cnt_zero1 : out std_logic; 
		cnt_one1 : out std_logic; 
		
		cnt_zero2 : out std_logic; 
		cnt_one2 : out std_logic; 
		
		rbits_zero : out std_logic;
		
		B_TDI : out std_logic 
		); 
		
end main;

architecture Behavioral of main is

--------------------------divideby8---------------------------------------

component divideby8 is
  port ( 
	clk, reset : in std_logic; 
	RAM : in std_logic_vector(7 downto 0); -- If 1111 0111
	q : out std_logic_vector(7 downto 3); --  Then 0001 1101
	r : out std_logic_vector(2 downto 0) -- Then 111
  ); 
end component;

-----------------------------Iword_cntr------------------------------------

component Iword_cntr is
	generic( N : integer := 8);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  q : in std_logic_vector(N-1 downto 3); 
           iL : in  STD_LOGIC;
           iD : in  STD_LOGIC;
           count_one1 : out  STD_LOGIC; 
           count_zero1 : out  STD_LOGIC);
end component;

-----------------------------rbits_ltch------------------------------------

component rbits_ltch is
	   generic(
		  N: integer := 8     -- number of bits
	  );
	   port(
		  clk, reset, rL: in std_logic;
		  r: in std_logic_vector(2 downto 0);
		  r_bit_one: out std_logic_vector(N-1 downto 0); 
		  r_bit_zero: out std_logic ); 
end component;

-----------------------------cbits_mux------------------------------------

component cbits_mux is
	generic(N : integer := 8);
	port(
		from_latch : in std_logic_vector(N-1 downto 0);
		from_RAM : in std_logic_vector(N-1 downto 0);
		cM : in std_logic;
		to_cbits_cntr : out std_logic_vector(N-1 downto 0)
	);
end component;

-----------------------------cbits_cntr------------------------------------

component cbits_cntr is
generic(N : integer := 8); -- Is this correct? 
	Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cL : in  STD_LOGIC;
           cD : in  STD_LOGIC;
           count_zero2 : out  STD_LOGIC;
           count_one2 : out  STD_LOGIC;
           from_mux : in  STD_LOGIC_VECTOR(N-1 downto 0));
end component;

-----------------------------serializer------------------------------------

component serializer
	PORT(
		from_RAM : IN std_logic_vector(7 downto 0);
		sL : IN std_logic;
		sS : IN std_logic;
		clk : IN std_logic;
		reset : IN std_logic;          
		to_TDI : OUT std_logic
		);
end component;


signal quocient : std_logic_vector(7 downto 3);
signal remainder : std_logic_vector(2 downto 0);
signal rbits_one : std_logic_vector(7 downto 0);
signal cbits_mux_count : std_logic_vector(7 downto 0); 

begin

A0 : divideby8 port map(
								clk => clk,
								reset => reset,
								RAM => RAM_content, 
								q => quocient, 
								r => remainder 
								);
								
A1 : Iword_cntr 
					generic map(N => DATA_width) 
					port map(
								clk => clk, 
								reset => reset,
								q => quocient,
								iL => load, 
								iD => decrement, 
								count_one1 => cnt_one1,
								count_zero1 => cnt_zero1
								);
								
A2 : rbits_ltch 
					generic map(N => DATA_WIDTH) -- størrelse 8
					port map(
								clk => clk, 
								reset => reset,
								rL => load, 
								r => remainder, 
								r_bit_one => rbits_one, 
								r_bit_zero => rbits_zero
								);	

A3 : cbits_mux 
					generic map(N => DATA_WIDTH) -- størrelse 8
					port map(
								from_latch => rbits_one, 
								from_RAM => X,
								cM => cM, 
								to_cbits_cntr => cbits_mux_count 
								);	
								
A4 : cbits_cntr
				generic map(N => DATA_WIDTH) -- størrelse 8 
				port map(
							clk => clk, 
							reset => reset, 
							cL => load, 
							cD => decrement, 
							count_zero2 => cnt_zero2,
							count_one2 => cnt_one2, 
							from_mux => cbits_mux_count
							);
							
A5 : serializer port map( from_RAM => RAM_content,
								  sL => load, 
								  sS => shift,
								  clk => clk, 
								  reset => reset, 
								  to_TDI => B_TDI
								  );
								


								
								
								

end Behavioral;

