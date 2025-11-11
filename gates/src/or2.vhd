library ieee;
use ieee.std_logic_1164.all;

entity or2 is
    port (
        a_in : in  std_logic;
        b_in : in  std_logic;
        z_out: out std_logic
    );
end entity or2;

architecture rtl of or2 is
begin
    z_out <= a_in or b_in after 10ns;
end architecture rtl;