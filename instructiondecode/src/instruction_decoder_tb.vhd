-- ========================================================================
-- COMPREHENSIVE Instruction Decoder Testbench
-- Thoroughly tests all instruction types and control signal generation
-- ========================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.TEXTIO.all;

entity instruction_decoder_tb is
end entity instruction_decoder_tb;

architecture behavioral of instruction_decoder_tb is

    -- Component declaration
    component instruction_decoder is
        port (
            instruction     : in  STD_LOGIC_VECTOR(15 downto 0);
            opcode          : out STD_LOGIC_VECTOR(2 downto 0);
            rs_addr         : out STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
            rt_addr         : out STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
            rd_addr         : out STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
            immediate       : out STD_LOGIC_VECTOR(7 downto 0);
            is_r_type       : out STD_LOGIC;
            is_i_type       : out STD_LOGIC;
            alu_enable      : out STD_LOGIC;
            mem_write       : out STD_LOGIC;
            mem_read        : out STD_LOGIC;
            reg_write       : out STD_LOGIC;
            mem_to_reg      : out STD_LOGIC
        );
    end component;
    
    -- Test signals
    signal instruction      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal opcode           : STD_LOGIC_VECTOR(2 downto 0);
    signal rs_addr          : STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
    signal rt_addr          : STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
    signal rd_addr          : STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
    signal immediate        : STD_LOGIC_VECTOR(7 downto 0);
    signal is_r_type        : STD_LOGIC;
    signal is_i_type        : STD_LOGIC;
    signal alu_enable       : STD_LOGIC;
    signal mem_write        : STD_LOGIC;
    signal mem_read         : STD_LOGIC;
    signal reg_write        : STD_LOGIC;
    signal mem_to_reg       : STD_LOGIC;
    
    -- Test tracking
    signal test_num         : integer := 0;
    signal tests_passed     : integer := 0;
    signal tests_failed     : integer := 0;
    
    -- Helper procedure for checking control signals
    procedure check_controls(
        constant test_name : in string;
        constant exp_opcode : in std_logic_vector(2 downto 0);
        constant exp_is_r : in std_logic;
        constant exp_is_i : in std_logic;
        constant exp_alu_en : in std_logic;
        constant exp_mem_wr : in std_logic;
        constant exp_mem_rd : in std_logic;
        constant exp_reg_wr : in std_logic;
        constant exp_mem_to_reg : in std_logic;
        signal test_num : inout integer;
        signal passed : inout integer;
        signal failed : inout integer
    ) is
        variable all_ok : boolean := true;
    begin
        test_num <= test_num + 1;
        
        if opcode /= exp_opcode then
            report "FAIL [" & test_name & "]: opcode = " & 
                   integer'image(to_integer(unsigned(opcode))) & 
                   ", expected " & integer'image(to_integer(unsigned(exp_opcode)))
                   severity error;
            all_ok := false;
        end if;
        
        if is_r_type /= exp_is_r then
            report "FAIL [" & test_name & "]: is_r_type incorrect" severity error;
            all_ok := false;
        end if;
        
        if is_i_type /= exp_is_i then
            report "FAIL [" & test_name & "]: is_i_type incorrect" severity error;
            all_ok := false;
        end if;
        
        if alu_enable /= exp_alu_en then
            report "FAIL [" & test_name & "]: alu_enable incorrect" severity error;
            all_ok := false;
        end if;
        
        if mem_write /= exp_mem_wr then
            report "FAIL [" & test_name & "]: mem_write incorrect" severity error;
            all_ok := false;
        end if;
        
        if mem_read /= exp_mem_rd then
            report "FAIL [" & test_name & "]: mem_read incorrect" severity error;
            all_ok := false;
        end if;
        
        if reg_write /= exp_reg_wr then
            report "FAIL [" & test_name & "]: reg_write incorrect" severity error;
            all_ok := false;
        end if;
        
        if mem_to_reg /= exp_mem_to_reg then
            report "FAIL [" & test_name & "]: mem_to_reg incorrect" severity error;
            all_ok := false;
        end if;
        
        if all_ok then
            report "PASS [" & test_name & "]";
            passed <= passed + 1;
        else
            failed <= failed + 1;
        end if;
    end procedure;
    
begin
    
    -- Instantiate Unit Under Test
    UUT : instruction_decoder
        port map (
            instruction     => instruction,
            opcode          => opcode,
            rs_addr         => rs_addr,
            rt_addr         => rt_addr,
            rd_addr         => rd_addr,
            immediate       => immediate,
            is_r_type       => is_r_type,
            is_i_type       => is_i_type,
            alu_enable      => alu_enable,
            mem_write       => mem_write,
            mem_read        => mem_read,
            reg_write       => reg_write,
            mem_to_reg      => mem_to_reg
        );
    
    -- Test stimulus
    STIMULUS : process
    begin
        report "========================================================================";
        report "COMPREHENSIVE INSTRUCTION DECODER TEST";
        report "========================================================================";
        report "";
        
        -- ====================================================================
        -- TEST SUITE 1: R-TYPE INSTRUCTIONS
        -- ====================================================================
        report "TEST SUITE 1: R-Type Instructions";
        report "--------------------------------------------------------------------";
        
        -- Test 1: ADD instruction (000)
        wait for 100 ns;
        report "Test 1: add $r2, $r0, $r1 (0x0201)";
        instruction <= X"0201";
        wait for 50 ns;
        check_controls("ADD", "000", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(2, 4)) report "FAIL: rd_addr should be 2" severity error;
        assert rs_addr = std_logic_vector(to_unsigned(0, 4)) report "FAIL: rs_addr should be 0" severity error;
        assert rt_addr = std_logic_vector(to_unsigned(1, 4)) report "FAIL: rt_addr should be 1" severity error;
        
        -- Test 2: MULT instruction (001)
        wait for 100 ns;
        report "Test 2: mult $r3, $r0, $r1 (0x1301)";
        instruction <= X"1301";
        wait for 50 ns;
        check_controls("MULT", "001", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(3, 4)) report "FAIL: rd_addr should be 3" severity error;
        assert rs_addr = std_logic_vector(to_unsigned(0, 4)) report "FAIL: rs_addr should be 0" severity error;
        assert rt_addr = std_logic_vector(to_unsigned(1, 4)) report "FAIL: rt_addr should be 1" severity error;
        
        -- Test 3: PA (PassThrough A) instruction (010)
        wait for 100 ns;
        report "Test 3: pa $r5, $r2, $r0 (0x2520)";
        instruction <= X"2520";
        wait for 50 ns;
        check_controls("PA", "010", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(5, 4)) report "FAIL: rd_addr should be 5" severity error;
        assert rs_addr = std_logic_vector(to_unsigned(2, 4)) report "FAIL: rs_addr should be 2" severity error;
        assert rt_addr = std_logic_vector(to_unsigned(0, 4)) report "FAIL: rt_addr should be 0" severity error;
        
        -- Test 4: PB (PassThrough B) instruction (011)
        wait for 100 ns;
        report "Test 4: pb $r6, $r0, $r3 (0x3603)";
        instruction <= X"3603";
        wait for 50 ns;
        check_controls("PB", "011", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(6, 4)) report "FAIL: rd_addr should be 6" severity error;
        assert rs_addr = std_logic_vector(to_unsigned(0, 4)) report "FAIL: rs_addr should be 0" severity error;
        assert rt_addr = std_logic_vector(to_unsigned(3, 4)) report "FAIL: rt_addr should be 3" severity error;
        
        -- Test 5: SUB instruction (100)
        wait for 100 ns;
        report "Test 5: sub $r4, $r0, $r1 (0x4401)";
        instruction <= X"4401";
        wait for 50 ns;
        check_controls("SUB", "100", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(4, 4)) report "FAIL: rd_addr should be 4" severity error;
        assert rs_addr = std_logic_vector(to_unsigned(0, 4)) report "FAIL: rs_addr should be 0" severity error;
        assert rt_addr = std_logic_vector(to_unsigned(1, 4)) report "FAIL: rt_addr should be 1" severity error;
        
        -- Test 6: R-Type with all registers different
        wait for 100 ns;
        report "Test 6: add $r7, $r5, $r3 (0x0753)";
        instruction <= X"0753";
        wait for 50 ns;
        check_controls("ADD (r7,r5,r3)", "000", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(7, 4)) report "FAIL: rd_addr should be 7" severity error;
        assert rs_addr = std_logic_vector(to_unsigned(5, 4)) report "FAIL: rs_addr should be 5" severity error;
        assert rt_addr = std_logic_vector(to_unsigned(3, 4)) report "FAIL: rt_addr should be 3" severity error;
        
        report "";
        
        -- ====================================================================
        -- TEST SUITE 2: I-TYPE INSTRUCTIONS
        -- ====================================================================
        report "TEST SUITE 2: I-Type Instructions";
        report "--------------------------------------------------------------------";
        
        -- Test 7: LDI instruction (101)
        wait for 100 ns;
        report "Test 7: ldi $r0, 10 (0x500A)";
        instruction <= X"500A";
        wait for 50 ns;
        check_controls("LDI (r0,10)", "101", '0', '1', '0', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(0, 4)) report "FAIL: rd_addr should be 0" severity error;
        assert immediate = std_logic_vector(to_unsigned(10, 8)) report "FAIL: immediate should be 0x0A" severity error;
        
        -- Test 8: LDI with different register and value
        wait for 100 ns;
        report "Test 8: ldi $r7, 255 (0x57FF)";
        instruction <= X"57FF";
        wait for 50 ns;
        check_controls("LDI (r7,255)", "101", '0', '1', '0', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(7, 4)) report "FAIL: rd_addr should be 7" severity error;
        assert immediate = std_logic_vector(to_unsigned(255, 8)) report "FAIL: immediate should be 0xFF" severity error;
        
        -- Test 9: SH (Store Halfword) instruction (110)
        wait for 100 ns;
        report "Test 9: sh $r3, 0x0B (0x630B)";
        instruction <= X"630B";
        wait for 50 ns;
        check_controls("SH (r3,0x0B)", "110", '0', '1', '0', '1', '0', '0', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(3, 4)) report "FAIL: rd_addr should be 3 (source reg)" severity error;
        assert immediate = std_logic_vector(to_unsigned(11, 8)) report "FAIL: immediate should be 0x0B" severity error;
        
        -- Test 10: SH with different values
        wait for 100 ns;
        report "Test 10: sh $r5, 0xFF (0x65FF)";
        instruction <= X"65FF";
        wait for 50 ns;
        check_controls("SH (r5,0xFF)", "110", '0', '1', '0', '1', '0', '0', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(5, 4)) report "FAIL: rd_addr should be 5" severity error;
        assert immediate = std_logic_vector(to_unsigned(255, 8)) report "FAIL: immediate should be 0xFF" severity error;
        
        -- Test 11: LH (Load Halfword) instruction (111)
        wait for 100 ns;
        report "Test 11: lh $r6, 0x0A (0x760A)";
        instruction <= X"760A";
        wait for 50 ns;
        check_controls("LH (r6,0x0A)", "111", '0', '1', '0', '0', '1', '1', '1',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(6, 4)) report "FAIL: rd_addr should be 6" severity error;
        assert immediate = std_logic_vector(to_unsigned(10, 8)) report "FAIL: immediate should be 0x0A" severity error;
        
        -- Test 12: LH with address 0
        wait for 100 ns;
        report "Test 12: lh $r0, 0x00 (0x7000)";
        instruction <= X"7000";
        wait for 50 ns;
        check_controls("LH (r0,0x00)", "111", '0', '1', '0', '0', '1', '1', '1',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(0, 4)) report "FAIL: rd_addr should be 0" severity error;
        assert immediate = std_logic_vector(to_unsigned(0, 8)) report "FAIL: immediate should be 0x00" severity error;
        
        report "";
        
        -- ====================================================================
        -- TEST SUITE 3: ACTUAL TEST PROGRAM INSTRUCTIONS
        -- ====================================================================
        report "TEST SUITE 3: Test Program Instructions";
        report "--------------------------------------------------------------------";
        
        -- Instructions from the actual test program
        wait for 100 ns;
        report "Test 13: ldi $r0, 10 (0x500A) - Program instruction 0";
        instruction <= X"500A";
        wait for 50 ns;
        check_controls("Prog[0]", "101", '0', '1', '0', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 14: ldi $r1, 5 (0x5105) - Program instruction 1";
        instruction <= X"5105";
        wait for 50 ns;
        check_controls("Prog[1]", "101", '0', '1', '0', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 15: add $r2, $r0, $r1 (0x0201) - Program instruction 8";
        instruction <= X"0201";
        wait for 50 ns;
        check_controls("Prog[8]", "000", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 16: mult $r3, $r0, $r1 (0x1301) - Program instruction 9";
        instruction <= X"1301";
        wait for 50 ns;
        check_controls("Prog[9]", "001", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 17: sub $r4, $r0, $r1 (0x4401) - Program instruction 10";
        instruction <= X"4401";
        wait for 50 ns;
        check_controls("Prog[10]", "100", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 18: sh $r3, 0x0B (0x630B) - Program instruction 11";
        instruction <= X"630B";
        wait for 50 ns;
        check_controls("Prog[11]", "110", '0', '1', '0', '1', '0', '0', '0',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 19: sh $r4, 0x0A (0x640A) - Program instruction 12";
        instruction <= X"640A";
        wait for 50 ns;
        check_controls("Prog[12]", "110", '0', '1', '0', '1', '0', '0', '0',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 20: lh $r6, 0x0A (0x760A) - Program instruction 13";
        instruction <= X"760A";
        wait for 50 ns;
        check_controls("Prog[13]", "111", '0', '1', '0', '0', '1', '1', '1',
                      test_num, tests_passed, tests_failed);
        
        wait for 100 ns;
        report "Test 21: lh $r7, 0x0B (0x770B) - Program instruction 14";
        instruction <= X"770B";
        wait for 50 ns;
        check_controls("Prog[14]", "111", '0', '1', '0', '0', '1', '1', '1',
                      test_num, tests_passed, tests_failed);
        
        report "";
        
        -- ====================================================================
        -- TEST SUITE 4: EDGE CASES AND BOUNDARY VALUES
        -- ====================================================================
        report "TEST SUITE 4: Edge Cases and Boundary Values";
        report "--------------------------------------------------------------------";
        
        -- Test 22: All zeros
        wait for 100 ns;
        report "Test 22: Instruction 0x0000 (add $r0, $r0, $r0)";
        instruction <= X"0000";
        wait for 50 ns;
        check_controls("All zeros", "000", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        
        -- Test 23: Immediate value = 0
        wait for 100 ns;
        report "Test 23: ldi $r0, 0 (0x5000)";
        instruction <= X"5000";
        wait for 50 ns;
        check_controls("Imm=0", "101", '0', '1', '0', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert immediate = std_logic_vector(to_unsigned(0, 8)) report "FAIL: immediate should be 0x00" severity error;
        
        -- Test 24: Immediate value = 255 (max)
        wait for 100 ns;
        report "Test 24: ldi $r7, 255 (0x57FF)";
        instruction <= X"57FF";
        wait for 50 ns;
        check_controls("Imm=255", "101", '0', '1', '0', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert immediate = std_logic_vector(to_unsigned(255, 8)) report "FAIL: immediate should be 0xFF" severity error;
        
        -- Test 25: All registers = 7 (max)
        wait for 100 ns;
        report "Test 25: add $r7, $r7, $r7 (0x0777)";
        instruction <= X"0777";
        wait for 50 ns;
        check_controls("All regs=7", "000", '1', '0', '1', '0', '0', '1', '0',
                      test_num, tests_passed, tests_failed);
        assert rd_addr = std_logic_vector(to_unsigned(7, 4)) report "FAIL: rd_addr should be 7" severity error;
        assert rs_addr = std_logic_vector(to_unsigned(7, 4)) report "FAIL: rs_addr should be 7" severity error;
        assert rt_addr = std_logic_vector(to_unsigned(7, 4)) report "FAIL: rt_addr should be 7" severity error;
        
        report "";
        
        -- ====================================================================
        -- TEST SUITE 5: CONTROL SIGNAL TRUTH TABLE VERIFICATION
        -- ====================================================================
        report "TEST SUITE 5: Control Signal Truth Table";
        report "--------------------------------------------------------------------";
        report "Opcode | Inst | is_R | is_I | ALU | MW | MR | RW | M2R |";
        report "-------|------|------|------|-----|----|----|----|----|";
        
        -- Generate truth table by testing each opcode
        for i in 0 to 7 loop
            wait for 100 ns;
            -- Create a test instruction with the current opcode
            instruction <= std_logic_vector(to_unsigned(i, 3)) & "0" & X"201";
            wait for 50 ns;
            
            -- Use if-elsif for VHDL-93 compatibility
            if i = 0 then
                report "0      | add  | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            elsif i = 1 then
                report "1      | mult | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            elsif i = 2 then
                report "2      | pa   | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            elsif i = 3 then
                report "3      | pb   | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            elsif i = 4 then
                report "4      | sub  | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            elsif i = 5 then
                report "5      | ldi  | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            elsif i = 6 then
                report "6      | sh   | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            elsif i = 7 then
                report "7      | lh   | " & std_logic'image(is_r_type) &
                       "    | " & std_logic'image(is_i_type) &
                       "    | " & std_logic'image(alu_enable) &
                       "   | " & std_logic'image(mem_write) &
                       "  | " & std_logic'image(mem_read) &
                       "  | " & std_logic'image(reg_write) &
                       "  | " & std_logic'image(mem_to_reg) & " |";
            end if;
        end loop;
        
        report "";
        
        -- ====================================================================
        -- FINAL SUMMARY
        -- ====================================================================
        report "========================================================================";
        report "TEST SUMMARY";
        report "========================================================================";
        report "Total Tests:  " & integer'image(test_num);
        report "Tests Passed: " & integer'image(tests_passed);
        report "Tests Failed: " & integer'image(tests_failed);
        
        if tests_failed = 0 then
            report "========================================================================";
            report "ALL TESTS PASSED! Decoder is working correctly!";
            report "========================================================================";
        else
            report "========================================================================";
            report "SOME TESTS FAILED! Check error messages above.";
            report "========================================================================";
        end if;
        
        report "";
        report "Simulation complete. You can now verify timing and waveforms.";
        
        wait;
    end process;
    
end architecture behavioral;