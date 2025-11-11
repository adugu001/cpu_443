library ieee;
use ieee.std_logic_1164.all;

entity and2 is
    port (
        a_in : in  std_logic;
        b_in : in  std_logic;
        z_out: out std_logic
    );
end entity and2;

architecture rtl of and2 is
begin
    z_out <= a_in and b_in after 10ns;
end architecture rtl;