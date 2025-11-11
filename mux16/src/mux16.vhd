library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux16 is
    port ( 
		SEL: 	 in STD_LOGIC_VECTOR(2 downto 0);
        A0 : 	 in STD_LOGIC_VECTOR(15 downto 0);
        A1 : 	 in STD_LOGIC_VECTOR(15 downto 0);
		A2 : 	 in STD_LOGIC_VECTOR(15 downto 0);
		A3 : 	 in STD_LOGIC_VECTOR(15 downto 0);
		A4 : 	 in STD_LOGIC_VECTOR(15 downto 0);
		A5 : 	 in STD_LOGIC_VECTOR(15 downto 0);
		A6 : 	 in STD_LOGIC_VECTOR(15 downto 0);
		A7 : 	 in STD_LOGIC_VECTOR(15 downto 0); 
        R : 	 out STD_LOGIC_VECTOR(15 downto 0)
    );
end mux16;	   

architecture behavioral of mux16 is	
begin
    process(all)
	variable sel_int : INTEGER;	
	variable R_v     : STD_LOGIC_VECTOR(15 downto 0);
	begin	
		sel_int := TO_INTEGER(UNSIGNED(SEL));
		if 	  sel_int = 0 then R_v := A0;
		elsif sel_int = 1 then R_v := A1;
		elsif sel_int = 2 then R_v := A2;
		elsif sel_int = 3 then R_v := A3;
		elsif sel_int = 4 then R_v := A4;
		elsif sel_int = 5 then R_v := A5;
		elsif sel_int = 6 then R_v := A6;
		elsif sel_int = 7 then R_v := A7;
		end if;
		R <= R_v;			
	end process;
end architecture behavioral;	

architecture structural of mux16 is	
begin	   						  	
	-- GENERATE ARRAY OF MUX TO SPECIFY WHICH CALCULATION TO PROPOGATE
	GEN_OUTPUT_MUX : for i in 0 to 15 generate
		THE_MUX: entity work.mux(behavioral)		 
        	port map(
		        sel 	=> SEL,
		        a0 		=> A0(i),
		        a1 		=> A1(i),
		        a2 		=> A2(i),
		        a3 		=> A3(i),
		        a4 		=> A4(i),
		        a5 		=> A5(i),
		        a6 		=> A6(i),
		        a7 		=> A7(i),
		        z_out 	=> R(i)
		    );
	end generate;
end architecture structural;