-- ========================================================================
-- Instruction Fetch Unit
-- Includes Program Counter (PC) and instruction fetch logic
-- ========================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_fetch is
    port (
        CLK         : in  STD_LOGIC;
        RESET       : in  STD_LOGIC;                        -- Active high reset
        enable      : in  STD_LOGIC;                        -- Enable PC increment
        PC_out      : out STD_LOGIC_VECTOR(7 downto 0)      -- Current PC value
    );
end instruction_fetch;

architecture behavioral of instruction_fetch is
    signal PC : unsigned(7 downto 0) := (others => '0');    -- Program Counter register
begin
    -- Program Counter process
    PC_PROCESS : process(CLK, RESET)
    begin
        if RESET = '1' then
            PC <= (others => '0');                          -- Reset PC to 0
        elsif rising_edge(CLK) then
            if enable = '1' then
                PC <= PC + 1;                               -- Increment PC
            end if;
        end if;
    end process;
    
    -- Output current PC
    PC_out <= std_logic_vector(PC);
    
end architecture behavioral;