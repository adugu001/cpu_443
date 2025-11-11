library ieee;
use ieee.std_logic_1164.all;

entity not1 is
    port (
        a_in : in  std_logic;
        z_out: out std_logic
    );
end entity not1;

architecture rtl of not1 is
begin
    z_out <= (not a_in) after 10ns;
end architecture rtl;