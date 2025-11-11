library ieee;
use ieee.std_logic_1164.all;

entity nand2 is
    port (
        a_in : in  std_logic;
        b_in : in  std_logic;
        z_out: out std_logic
    );
end entity nand2;

architecture rtl of nand2 is
begin
    z_out <= not (a_in and b_in) after 10ns;
end architecture rtl;