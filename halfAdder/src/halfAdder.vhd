library ieee; 
library gates;
use gates.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity halfAdder is
    port (
        a_in : in std_logic;
        b_in : in std_logic;
        sum: out std_logic;
        c_out: out std_logic
    );
end halfAdder;

architecture behavioral of halfAdder is
begin
    sum <= a_in xor b_in;
    c_out <= a_in and b_in;
end architecture behavioral;	 

architecture structural of halfAdder is	   -- critical path = 20ns	  
begin			
    uut_xor1 : entity gates.xor2(rtl)				 
        port map ( a_in  => a_in, b_in  => b_in, z_out => sum );	 
    uut_and1 : entity gates.and2(rtl)
        port map ( a_in  => a_in, b_in  => b_in, z_out => c_out  );
end architecture structural;