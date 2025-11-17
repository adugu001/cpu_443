library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register16 is
    port (
        data_in	 : in  STD_LOGIC_VECTOR(15 downto 0);
        CLK 	 : in STD_LOGIC;   --Rising edge trigger
        rst  	 : in STD_LOGIC;   --active high ('1' asserts reset), asynchronous to clk
        write 	 : in STD_LOGIC;   --active high ('1' asserts write)
        data_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end register16;

architecture behavioral of register16 is
begin
	BEH_PROCESS : process(all) 
	variable data_v : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
	begin
		if rst = '1' then 
			data_v := X"0000";
		elsif (clk'event) and (clk = '1') and (write = '1') then
			data_v := data_in; 
		end if;
		data_out <= data_v;			
	end process;			
end architecture behavioral;  
