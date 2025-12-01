library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerFile_tb is
end entity registerFile_tb;

architecture behavioral of registerFile_tb is

    signal data_in_sig : STD_LOGIC_VECTOR(15 downto 0);
    signal rs_out_sig  : STD_LOGIC_VECTOR(15 downto 0);
    signal rt_out_sig  : STD_LOGIC_VECTOR(15 downto 0);
    signal rs_num_sig  : STD_LOGIC_VECTOR(3 downto 0);	 	
	signal rt_num_sig  : STD_LOGIC_VECTOR(3 downto 0);	
	signal rd_num_sig  : STD_LOGIC_VECTOR(3 downto 0);	
	signal CLK_sig     : STD_LOGIC; 
	signal write_sig   : STD_LOGIC; 
    -- Clock period
    constant CLK_PERIOD     : time := 100 ns;
    
begin
    
    -- Instantiate the processor
    UUT : entity work.registerFile
        port map (
            data_in	 =>	data_in_sig, 
			rs_num   =>	rs_num_sig,  
			rt_num	 =>	rt_num_sig,
			rd_num	 =>	rd_num_sig, 
	        CLK 	 =>	CLK_sig,
	        write 	 =>	write_sig,
	        rs_out   =>	rs_out_sig,
			rt_out   =>	rt_out_sig
        );
    
    -- Test stimulus
    test_process : process
    begin
 		for i in 0 to 100 loop
			 wait for CLK_PERIOD;
		end loop;
        wait;
    end process;
    
end architecture behavioral;

