library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM256 is
    port (	
		data_in	 : in STD_LOGIC_VECTOR(15 downto 0);
		rd_addr   : in STD_LOGIC_VECTOR(7 downto 0);	 
		wr_addr	 : in STD_LOGIC_VECTOR(7 downto 0);	
        CLK 	 : in STD_LOGIC;   --Rising edge trigger
        write 	 : in STD_LOGIC;   --active high ('1' asserts write)
		data_out   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end RAM256;

architecture behavioral of RAM256 is	
    type storage is array (0 to 255) of std_logic_vector(15 downto 0);
    
    -- Use SIGNAL (not variable) so memory persists between clock cycles
    -- Initialize all memory locations to zero
    signal memory : storage := (others => (others => '0'));
begin
	BEH_PROCESS : process(all)
	    -- Define memory storage type

    
	variable din_v, dout_v : STD_LOGIC_VECTOR(15 downto 0); 
	variable rd_add_int, wr_add_int : INTEGER;	
	begin	   
		--Get indices for read/write addr
		rd_add_int := TO_INTEGER(UNSIGNED(rd_addr));		
		wr_add_int := TO_INTEGER(UNSIGNED(wr_addr));	
		
		-- capture read addr's data
		dout_v := memory(rd_add_int);

		
		-- Write to appropriate register
		if (clk'event) and (clk = '1') and (write = '1') then
			memory(wr_add_int) <= data_in; 
		end if;	  
		
		-- Push data out
		data_out <= memory(to_integer(unsigned(dout_v)));
					
	end process;			
end architecture behavioral;  
