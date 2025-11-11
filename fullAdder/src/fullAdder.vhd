library ieee; 
library halfAdder;	
library gates;
use halfAdder.all;	
use gates.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	


entity fullAdder is
    port (
        a_in : in std_logic;
        b_in : in std_logic;
        c_in: in std_logic;
        sum: out std_logic;
        c_out: out std_logic
    );
end fullAdder;

architecture behavioral of fullAdder is
begin
    sum <= a_in xor b_in xor c_in;
    c_out <= (a_in and b_in) or (c_in and (a_in xor b_in));
end architecture behavioral;	 

architecture structural of fullAdder is		--critical path = 40ns
signal sum_half   	   : std_logic;		 
signal c_out_half 	   : std_logic; 
signal ain_xor_bin     : std_logic;
signal cin_and_sum_half: std_logic;	
begin 		 	 	 
		
	-- sum_half   =   a_in xor b_in
	-- c_out_half =   a_in and b_in
    u1_half : entity halfAdder.halfadder(structural)				 
        port map ( a_in  => a_in, b_in  => b_in, sum => sum_half, c_out => c_out_half ); -- u1_delay = 20ns	   
    
	-- sum = sum_half xor c_in = a_in xor b_in xor c_in
    u2_xor : entity gates.xor2(rtl)	  
        port map ( a_in  => sum_half, b_in  => c_in, z_out => sum );  -- sum_delay = 10ns + u1_delay = 30ns
		
	--cin_and_sum_half	= c_in and (a_in xor b_in)
    u3_and : entity gates.and2(rtl)
        port map ( a_in  => c_in, b_in  => sum_half, z_out => cin_and_sum_half  );	-- u3_delay = 10ns + u1_delay = 30ns  
		
	--c_out = c_out_half or cin_and_sum_half = (a_in and b_in) or (c_in and (sum_half))	= (a_in and b_in) or (c_in and (a_in xor b_in))
    u4_or  : entity gates.or2(rtl)
        port map ( a_in  => c_out_half, b_in  => cin_and_sum_half, z_out => c_out ); --c_out_delay = 10ns + max(u1_delay, u3_delay)	= 40ns	  
		
end architecture structural;