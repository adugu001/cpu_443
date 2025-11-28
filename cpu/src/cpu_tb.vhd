-- ========================================================================
-- Processor Testbench
-- Tests the complete processor with the given program
-- ========================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity cpu_tb is
end entity cpu_tb;

architecture behavioral of cpu_tb is

    -- Component declaration
    component simple_processor is
        port (
            CLK                 : in  STD_LOGIC;
            RESET               : in  STD_LOGIC;
            enable              : in  STD_LOGIC;
            PC_debug            : out STD_LOGIC_VECTOR(7 downto 0);
            instruction_debug   : out STD_LOGIC_VECTOR(15 downto 0);
            r6_debug            : out STD_LOGIC_VECTOR(15 downto 0);
            r7_debug            : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    -- Clock and control signals
    signal CLK              : STD_LOGIC := '0';
    signal RESET            : STD_LOGIC := '1';
    signal enable           : STD_LOGIC := '0';
    
    -- Debug signals
    signal PC_debug         : STD_LOGIC_VECTOR(7 downto 0);
    signal instruction_debug: STD_LOGIC_VECTOR(15 downto 0);
    signal r6_debug         : STD_LOGIC_VECTOR(15 downto 0);
    signal r7_debug         : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Clock period
    constant CLK_PERIOD     : time := 100 ns;
    
    -- Simulation control
    signal sim_done         : boolean := false;
    
begin
    
    -- Instantiate the processor
    UUT : entity work.cpu
        port map (
            CLK                 => CLK,
            RESET               => RESET,
            enable              => enable,
            PC_debug            => PC_debug,
            instruction_debug   => instruction_debug,
            r6_debug            => r6_debug,
            r7_debug            => r7_debug
        );
    
    -- Clock generation
    CLK_PROCESS : process
    begin
        while not sim_done loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;
    
    -- Test stimulus
    STIMULUS : process
    begin
        -- Initial reset
        RESET <= '1';
        enable <= '0';
        wait for 200 ns;
        
        -- Release reset and enable processor
        RESET <= '0';
        enable <= '1';
        
        -- Wait for program to execute (15 instructions + some buffer)
        -- Each instruction takes 1 clock cycle in single-cycle processor
        wait for CLK_PERIOD * 20;
        
        -- Check results
        report "==========================================";
        report "Program execution complete!";
        report "==========================================";
        report "Expected Results:";
        report "  r0 = 10 (0x000A)";
        report "  r1 = 5  (0x0005)";
        report "  r2 = 15 (0x000F) = 10 + 5";
        report "  r3 = 50 (0x0032) = 10 * 5";
        report "  r4 = 5  (0x0005) = 10 - 5";
        report "  r6 = 5  (0x0005) = loaded from mem[0x0A]";
        report "  r7 = 50 (0x0032) = loaded from mem[0x0B]";
        report "==========================================";
        report "Note: To verify results, check waveform:";
        report "  - Register file contents after execution";
        report "  - Memory locations 0x0A and 0x0B";
        report "==========================================";
        
        -- Disable processor
        enable <= '0';
        
        -- End simulation
        sim_done <= true;
        wait;
    end process;
    
end architecture behavioral;


-- ========================================================================
-- Expected Program Flow:
-- ========================================================================
-- Instruction  | PC | Operation              | Result
-- -------------|----|-----------------------|------------------------
-- ldi $r0, 10  | 0  | r0 <= 10              | r0 = 0x000A
-- ldi $r1, 5   | 1  | r1 <= 5               | r1 = 0x0005
-- ldi $r2, 0   | 2  | r2 <= 0               | r2 = 0x0000
-- ldi $r3, 0   | 3  | r3 <= 0               | r3 = 0x0000
-- ldi $r4, 0   | 4  | r4 <= 0               | r4 = 0x0000
-- ldi $r5, 0   | 5  | r5 <= 0               | r5 = 0x0000
-- ldi $r6, 0   | 6  | r6 <= 0               | r6 = 0x0000
-- ldi $r7, 0   | 7  | r7 <= 0               | r7 = 0x0000
-- add $r2,$r0,$r1| 8  | r2 <= r0 + r1       | r2 = 0x000F (15)
-- mult $r3,$r0,$r1| 9 | r3 <= r0 * r1       | r3 = 0x0032 (50)
-- sub $r4,$r0,$r1| 10 | r4 <= r0 - r1       | r4 = 0x0005 (5)
-- sh $r3, 0x0B | 11 | mem[0x0B] <= r3       | mem[0x0B] = 0x0032
-- sh $r4, 0x0A | 12 | mem[0x0A] <= r4       | mem[0x0A] = 0x0005
-- lh $r6, 0x0A | 13 | r6 <= mem[0x0A]       | r6 = 0x0005 (5)
-- lh $r7, 0x0B | 14 | r7 <= mem[0x0B]       | r7 = 0x0032 (50)
-- ========================================================================