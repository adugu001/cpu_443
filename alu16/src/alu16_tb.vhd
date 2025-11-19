 library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity alu16_tb is
end entity alu16_tb;

architecture behavioral of alu16_tb is			 

--SIGNAL DECLARATIONS
	--input
    signal A_sig    : STD_LOGIC_VECTOR(15 downto 0); 
    signal B_sig    : STD_LOGIC_VECTOR(15 downto 0);
    signal sel      : STD_LOGIC_VECTOR(2 downto 0);    
	--outputs	 
	signal R_sig    : STD_LOGIC_VECTOR(15 downto 0);
    signal VZN_sig  : STD_LOGIC_VECTOR(2 downto 0);  	   
	--crit path
    constant DELTA_DELAY : time :=  650 ns;

begin	
	uut_str : entity work.alu16(structural)
        port map (A  => A_sig, B => B_sig, S2 => sel(2), S1 => sel(1), S0 => sel(0), status => VZN_sig, R => R_sig);

    test : process
    begin 
	   	for i in 0 to 7 loop
			wait for DELTA_DELAY; 
		end loop;
        wait;
    end process test;

end architecture behavioral;