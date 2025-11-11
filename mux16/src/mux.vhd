library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    port (
        sel : in  std_logic_vector(2 downto 0);
        a0 : in std_logic;
        a1 : in std_logic;
        a2 : in std_logic;
        a3 : in std_logic;
        a4 : in std_logic;
        a5 : in std_logic;
        a6 : in std_logic;
        a7 : in std_logic;
        z_out : out std_logic
    );
end mux;

architecture behavioral of mux is
begin
	BEH_PROCESS : process(all)
	begin
		if    sel = "000" then z_out <= a0;
		elsif sel = "001" then z_out <= a1;
		elsif sel = "010" then z_out <= a2;
		elsif sel = "011" then z_out <= a3;
		elsif sel = "100" then z_out <= a4;
		elsif sel = "101" then z_out <= a5;
		elsif sel = "110" then z_out <= a6;
		elsif sel = "111" then z_out <= a7;
		else  z_out <= 'X'; 
		end if;
	end process;			
end architecture behavioral;  
