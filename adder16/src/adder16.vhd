library ieee;
library fullAdder;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use fullAdder.all;

entity adder16 is
    port (
        A : 	in  STD_LOGIC_VECTOR(15 downto 0);
        B : 	in  STD_LOGIC_VECTOR(15 downto 0);
        c_in:  	in  STD_LOGIC;
        R:   	out STD_LOGIC_VECTOR(15 downto 0);
        c_out: 	out STD_LOGIC
    );
end adder16;

architecture behavioral of adder16 is
begin
    beh_process: process (A, B, c_in)
	    variable A_int, B_int, c_int, R_int : INTEGER;
		variable R_v : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
    begin	
		--convert to int
        A_int := TO_INTEGER(UNSIGNED(A));
        B_int := TO_INTEGER(UNSIGNED(B));   	
		if c_in = '1' then c_int := 1;
		else c_int := 0; 
		end if;
		--calc
        R_int := A_int + B_int + c_int;
		R_v   := STD_LOGIC_VECTOR(TO_UNSIGNED(R_int,17));  
		-- assign
		c_out <= R_v(16);
        R     <= R_v(15 downto 0);
    end process;
end architecture behavioral;	   

architecture structural of adder16 is
signal CARRY : STD_LOGIC_VECTOR(16 downto 0)  := (others => '0');  	   --to feed c_in to generate
--fa crit path = 40ns 
--16 full adders in series
--crit path = 16*40ns = 640ns
begin
	CARRY(0) <= c_in;
	c_out <= CARRY(16);
	GEN1: for i in 15 downto 0 generate					 
		fa: entity fullAdder.fullAdder(structural)		 
        	port map ( 
				a_in  => A(i), 
				b_in  => B(i), 
				c_in => CARRY(i), 
				sum => R(i), 
				c_out => CARRY(i+1)
			);	
	end generate GEN1;
end architecture structural;
