-- ========================================================================
-- Instruction Decoder (Structural Implementation)
-- Decodes 16-bit instructions and generates control signals
-- ========================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_decoder is
    port (
        instruction     : in  STD_LOGIC_VECTOR(15 downto 0);   -- 16-bit instruction
        
        -- Decoded fields/values
        opcode          : out STD_LOGIC_VECTOR(2 downto 0);    -- S2, S1, S0 for ALU
        rs_addr         : out STD_LOGIC_VECTOR(2 downto 0);    -- Register source A (for R-type)
        rt_addr         : out STD_LOGIC_VECTOR(2 downto 0);    -- Register source B (for R-type)
        rd_addr         : out STD_LOGIC_VECTOR(2 downto 0);    -- Register destination
        immediate       : out STD_LOGIC_VECTOR(7 downto 0);    -- Immediate value (for I-type)
        
        -- Control signals
        is_r_type       : out STD_LOGIC;                       -- '1' if R-type instruction
        is_i_type       : out STD_LOGIC;                       -- '1' if I-type instruction
        alu_enable      : out STD_LOGIC;                       -- Enable ALU
        mem_write       : out STD_LOGIC;                       -- Memory write enable
        mem_read        : out STD_LOGIC;                       -- Memory read enable
        reg_write       : out STD_LOGIC;                       -- Register write enable
        mem_to_reg      : out STD_LOGIC                        -- Select memory data for register write
    );
end instruction_decoder;

architecture structural of instruction_decoder is
    -- Internal signals for opcode bits
    signal S2, S1, S0 : STD_LOGIC;
    signal is_r_type_int : STD_LOGIC;
    signal is_i_type_int : STD_LOGIC;
begin
    
    -- Extract opcode bits (bits 14-12)
    S2 <= instruction(14);
    S1 <= instruction(13);
    S0 <= instruction(12);
    opcode <= S2 & S1 & S0;
    
    -- Extract register fields for R-type (bits 11-8, 7-4, 3-0)
    rd_addr <= instruction(11 downto 9);   -- c field (destination)
    rs_addr <= instruction(8 downto 6);    -- a field (source A)
    rt_addr <= instruction(5 downto 3);    -- b field (source B)
    
    -- For I-type, rd is in bits 11-8, immediate in bits 7-0
    -- (rd_addr already extracts bits 11-9, but for I-type we need 11-8)
    -- We'll handle this in the processor integration
    immediate <= instruction(7 downto 0);
    
    
    -- R-Type: opcodes 000, 001, 010, 011, 100 (S2='0' or S2='1' with S1='0' and S0='0')
    is_r_type_int <= '1' when (S2='0') or (S2='1' and S1='0' and S0='0') else '0';
    is_r_type <= is_r_type_int;
    -- I-Type: opcodes 101, 110, 111 (S2='1' and not 100)
    is_i_type_int <= '1' when (S2='1' and not (S1='0' and S0='0')) else '0';
    is_i_type <= is_i_type_int;
    
    -- ALU Enable: Active for all R-type instructions
    alu_enable <= is_r_type_int;
    
    -- Memory Write: Active for 'sh' (store halfword) instruction (opcode 110)
    mem_write <= '1' when (S2='1' and S1='1' and S0='0') else '0';
    
    -- Memory Read: Active for 'lh' (load halfword) instruction (opcode 111)
    mem_read <= '1' when (S2='1' and S1='1' and S0='1') else '0';
    
    -- Register Write: Active for most instructions except 'sh'
    -- Write enabled for: R-type (000-100), ldi (101), lh (111)
    -- Write disabled for: sh (110)
    reg_write <= '1' when (is_r_type_int='1' or 
                          (S2='1' and S1='0' and S0='1') or  -- ldi
                          (S2='1' and S1='1' and S0='1'))    -- lh
                 else '0';
    
    -- Mem to Reg Selects memory data for register write (for 'lh' instruction)
    mem_to_reg <= '1' when (S2='1' and S1='1' and S0='1') else '0';
    
end architecture structural;