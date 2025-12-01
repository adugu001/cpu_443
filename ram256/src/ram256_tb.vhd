library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ram256_tb is
end entity ram256_tb;

architecture behavioral of ram256_tb is

    signal data_in_sig	: STD_LOGIC_VECTOR(15 downto 0);
    signal data_out_sig : STD_LOGIC_VECTOR(15 downto 0);
    signal rd_addr_sig  : STD_LOGIC_VECTOR(7 downto 0);
    signal wr_addr_sig  : STD_LOGIC_VECTOR(7 downto 0);	 
	signal CLK          : STD_LOGIC; 
	signal write_sig    : STD_LOGIC; 
    -- Clock period
    constant CLK_PERIOD     : time := 100 ns;
    
begin
    
    -- Instantiate the processor
    UUT : entity work.ram256
        port map (
            data_in	 => data_in_sig,
			rd_addr   => rd_addr_sig,	 
			wr_addr	 => wr_addr_sig,
	        CLK 	 => clk,
	        write 	 => write_sig,
			data_out   => data_out_sig
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

