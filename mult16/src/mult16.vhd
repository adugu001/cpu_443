library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult16 is
    port (
        a_in     : in  std_logic_vector(15 downto 0);
        b_in     : in  std_logic_vector(15 downto 0);
        r_out    : out std_logic_vector(15 downto 0);
        overflow : out std_logic
    );
end entity mult16;

architecture behavioral of mult16 is
    signal a_signed          : signed(15 downto 0);
    signal b_signed          : signed(15 downto 0);
    signal mult_result_32bit : signed(31 downto 0);


    constant MIN_S16_VAL : signed(31 downto 0) := to_signed(-32768, 32);
    constant MAX_S16_VAL : signed(31 downto 0) := to_signed(32767, 32);

begin

    a_signed <= signed(a_in);
    b_signed <= signed(b_in);


    mult_result_32bit <= a_signed * b_signed;


    r_out <= std_logic_vector(mult_result_32bit(15 downto 0));

    overflow <= '1' when (mult_result_32bit < MIN_S16_VAL) or (mult_result_32bit > MAX_S16_VAL) else
                '0';

end architecture behavioral;