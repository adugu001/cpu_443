library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is
    port (	
		data_in	 : in STD_LOGIC_VECTOR(15 downto 0);
		rs_num   : in STD_LOGIC_VECTOR(3 downto 0);	 
		rt_num	 : in STD_LOGIC_VECTOR(3 downto 0);	
		rd_num	 : in STD_LOGIC_VECTOR(3 downto 0);
        CLK 	 : in STD_LOGIC;   --Rising edge trigger
        write 	 : in STD_LOGIC;   --active high ('1' asserts write)
        rs_out   : out STD_LOGIC_VECTOR(15 downto 0);
		rt_out   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end registerFile;

architecture behavioral of registerFile is	
    type storage is array (0 to 7) of std_logic_vector(15 downto 0);
    
    -- Use SIGNAL (not variable) so registers persist between clock cycles
    -- Initialize all registers to zero
    signal regs : storage := (others => (others => '0'));
    
begin
	BEH_PROCESS : process(all)

	variable rsData, rtData : STD_LOGIC_VECTOR(15 downto 0); 
	variable rs_int, rt_int, rd_int : INTEGER;	
	begin	   
		--Get indices and read reg data
		rs_int := TO_INTEGER(UNSIGNED(rs_num(2 downto 0)));
		rsData := regs(rs_int);
		rt_int := TO_INTEGER(UNSIGNED(rt_num(2 downto 0)));	
		rtData := regs(rt_int);
		rd_int := TO_INTEGER(UNSIGNED(rd_num(2 downto 0)));	
		
		-- Write to appropriate register
		if (clk'event) and (clk = '1') and (write = '1') then
			regs(rd_int) <= data_in; 
		end if;	  
		
		-- Push data out
    rs_out <= regs(rs_int);
    rt_out <= regs(rt_int);
					
	end process;			
end architecture behavioral;  
