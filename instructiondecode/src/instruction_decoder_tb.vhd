-- ========================================================================
-- Instruction Decoder Testbench
-- Tests instruction decoding for all instruction types
-- ========================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity instruction_decoder_tb is
end entity instruction_decoder_tb;

architecture behavioral of instruction_decoder_tb is

    component instruction_decoder is
        port (
            instruction     : in  STD_LOGIC_VECTOR(15 downto 0);
            opcode          : out STD_LOGIC_VECTOR(2 downto 0);
            rs_addr         : out STD_LOGIC_VECTOR(3 downto 0);
            rt_addr         : out STD_LOGIC_VECTOR(3 downto 0);
            rd_addr         : out STD_LOGIC_VECTOR(3 downto 0);
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
    
    -- Signals
    signal instruction      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal opcode           : STD_LOGIC_VECTOR(2 downto 0);
    signal rs_addr          : STD_LOGIC_VECTOR(3 downto 0);
    signal rt_addr          : STD_LOGIC_VECTOR(3 downto 0);
    signal rd_addr          : STD_LOGIC_VECTOR(3 downto 0);
    signal immediate        : STD_LOGIC_VECTOR(7 downto 0);
    signal is_r_type        : STD_LOGIC;
    signal is_i_type        : STD_LOGIC;
    signal alu_enable       : STD_LOGIC;
    signal mem_write        : STD_LOGIC;
    signal mem_read         : STD_LOGIC;
    signal reg_write        : STD_LOGIC;
    signal mem_to_reg       : STD_LOGIC;
    
begin
    
    UUT : entity work.instruction_decoder
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
    
    STIMULUS : process
    begin
        report "==========================================";
        report "Testing Instruction Decoder";
        report "==========================================";
        
        -- Test R-Type Instructions
        wait for 100 ns;
        report "Testing R-Type: add $r2, $r0, $r1 (0x0201)";
        instruction <= X"0201";  -- add $r2, $r0, $r1
        wait for 100 ns;
        assert opcode = "000" report "Error: Wrong opcode for add" severity error;
        assert is_r_type = '1' report "Error: Should be R-type" severity error;
        assert alu_enable = '1' report "Error: ALU should be enabled" severity error;
        assert reg_write = '1' report "Error: Register write should be enabled" severity error;
        
        wait for 100 ns;
        report "Testing R-Type: mult $r3, $r0, $r1 (0x1301)";
        instruction <= X"1301";  -- mult $r3, $r0, $r1
        wait for 100 ns;
        assert opcode = "001" report "Error: Wrong opcode for mult" severity error;
        
        wait for 100 ns;
        report "Testing R-Type: sub $r4, $r0, $r1 (0x4401)";
        instruction <= X"4401";  -- sub $r4, $r0, $r1
        wait for 100 ns;
        assert opcode = "100" report "Error: Wrong opcode for sub" severity error;
        
        -- Test I-Type Instructions
        wait for 100 ns;
        report "Testing I-Type: ldi $r0, 10 (0x500A)";
        instruction <= X"500A";  -- ldi $r0, 10
        wait for 100 ns;
        assert opcode = "101" report "Error: Wrong opcode for ldi" severity error;
        assert is_i_type = '1' report "Error: Should be I-type" severity error;
        assert immediate = X"0A" report "Error: Wrong immediate value" severity error;
        assert reg_write = '1' report "Error: Register write should be enabled for ldi" severity error;
        
        wait for 100 ns;
        report "Testing I-Type: sh $r3, 0x0B (0x630B)";
        instruction <= X"630B";  -- sh $r3, 0x0B
        wait for 100 ns;
        assert opcode = "110" report "Error: Wrong opcode for sh" severity error;
        assert mem_write = '1' report "Error: Memory write should be enabled" severity error;
        assert reg_write = '0' report "Error: Register write should be disabled for sh" severity error;
        
        wait for 100 ns;
        report "Testing I-Type: lh $r6, 0x0A (0x760A)";
        instruction <= X"760A";  -- lh $r6, 0x0A
        wait for 100 ns;
        assert opcode = "111" report "Error: Wrong opcode for lh" severity error;
        assert mem_read = '1' report "Error: Memory read should be enabled" severity error;
        assert mem_to_reg = '1' report "Error: Mem-to-reg should be enabled" severity error;
        assert reg_write = '1' report "Error: Register write should be enabled for lh" severity error;
        
        wait for 100 ns;
        report "==========================================";
        report "Decoder tests complete!";
        report "==========================================";
        
        wait;
    end process;
    
end architecture behavioral;