													 -- ========================================================================
-- Instruction Memory (ROM) - 256 x 16-bit
-- Stores the program to be executed
-- ========================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is
    port (
        addr        : in  STD_LOGIC_VECTOR(7 downto 0);   -- Program Counter
        instruction : out STD_LOGIC_VECTOR(15 downto 0)   -- Instruction output
    );
end instruction_memory;

architecture behavioral of instruction_memory is
    -- Define memory type: 256 addresses x 16 bits
    type rom_type is array (0 to 255) of std_logic_vector(15 downto 0);
    
    -- Initialize ROM with the test program
    constant ROM : rom_type := (
        -- Program starts here
        0  => X"500A",  -- ldi $r0, 10
        1  => X"5105",  -- ldi $r1, 5
        2  => X"5200",  -- ldi $r2, 0
        3  => X"5300",  -- ldi $r3, 0
        4  => X"5400",  -- ldi $r4, 0
        5  => X"5500",  -- ldi $r5, 0
        6  => X"5600",  -- ldi $r6, 0
        7  => X"5700",  -- ldi $r7, 0
        8  => X"0201",  -- add $r2, $r0, $r1
        9  => X"1301",  -- mult $r3, $r0, $r1
        10 => X"4401",  -- sub $r4, $r0, $r1
        11 => X"630B",  -- sh $r3, 0x0B
        12 => X"640A",  -- sh $r4, 0x0A
        13 => X"760A",  -- lh $r6, 0x0A
        14 => X"770B",  -- lh $r7, 0x0B
        -- Rest of memory initialized to NOP (or zero)
        others => X"0000"
    );
    
begin
    -- Asynchronous read
    process(addr)
        variable addr_int : integer;
    begin
        addr_int := to_integer(unsigned(addr));
        instruction <= ROM(addr_int);
    end process;
    
end architecture behavioral;