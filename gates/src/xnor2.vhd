library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xnor2 is
    port (
        a_in : in  std_logic;
        b_in : in  std_logic;
        z_out: out std_logic
    );
end xnor2;

architecture rtl of xnor2 is

begin
    z_out <= not (a_in xor b_in) after 10ns;
end architecture rtl;