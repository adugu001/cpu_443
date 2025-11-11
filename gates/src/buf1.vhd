library ieee;
use ieee.std_logic_1164.all;

entity buf1 is
    port (
        a_in : in  std_logic;
        z_out: out std_logic
    );
end entity buf1;

architecture rtl of buf1 is
begin
    z_out <= a_in after 10ns;
end architecture rtl;