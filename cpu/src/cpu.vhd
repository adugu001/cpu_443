																				-- ========================================================================
-- Simple Single-Cycle Processor
-- Integrates all components: Instruction Fetch, Decoder, ALU, 
-- Register File, and Data Memory
-- ========================================================================
library ieee;
library alu16;
library registerFile;
library ram256;	
library instructionfetch;
library instructiondecode; 
library instructionMemory;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use alu16.all;
use registerFile.all;
use ram256.all;	  
use instructionfetch.all;
use instructiondecode.all;	
use instructionmemory.all;

entity cpu is
    port (
        CLK             : in  STD_LOGIC;
        RESET           : in  STD_LOGIC;                    -- Active high reset
        enable          : in  STD_LOGIC;                    -- Processor enable
        
        -- Debug outputs (optional - can be removed for final version)
        PC_debug        : out STD_LOGIC_VECTOR(7 downto 0);
        instruction_debug : out STD_LOGIC_VECTOR(15 downto 0);
        r6_debug        : out STD_LOGIC_VECTOR(15 downto 0);
        r7_debug        : out STD_LOGIC_VECTOR(15 downto 0)
    );
end cpu;

architecture structural of cpu is
    
    -- =============================================
    -- COMPONENT DECLARATIONS
    -- =============================================
    
    component instruction_memory is
        port (
            addr        : in  STD_LOGIC_VECTOR(7 downto 0);
            instruction : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    component instruction_fetch is
        port (
            CLK         : in  STD_LOGIC;
            RESET       : in  STD_LOGIC;
            enable      : in  STD_LOGIC;
            PC_out      : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
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
    
    -- =============================================
    -- INTERNAL SIGNALS
    -- =============================================
    
    -- Program Counter and Instruction
    signal PC               : STD_LOGIC_VECTOR(7 downto 0);
    signal instruction      : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Decoded instruction fields
    signal opcode           : STD_LOGIC_VECTOR(2 downto 0);
    signal rs_addr          : STD_LOGIC_VECTOR(3 downto 0);
    signal rt_addr          : STD_LOGIC_VECTOR(3 downto 0);
    signal rd_addr          : STD_LOGIC_VECTOR(3 downto 0);
    signal rd_addr_final    : STD_LOGIC_VECTOR(3 downto 0);  -- Muxed for I-type
    signal immediate        : STD_LOGIC_VECTOR(7 downto 0);
    signal immediate_ext    : STD_LOGIC_VECTOR(15 downto 0); -- Sign-extended
    
    -- Control signals
    signal is_r_type        : STD_LOGIC;
    signal is_i_type        : STD_LOGIC;
    signal alu_enable       : STD_LOGIC;
    signal mem_write        : STD_LOGIC;
    signal mem_read         : STD_LOGIC;
    signal reg_write        : STD_LOGIC;
    signal mem_to_reg       : STD_LOGIC;
    
    -- Register file signals
    signal reg_data_in      : STD_LOGIC_VECTOR(15 downto 0);
    signal rs_data          : STD_LOGIC_VECTOR(15 downto 0);
    signal rt_data          : STD_LOGIC_VECTOR(15 downto 0);
    
    -- ALU signals
    signal alu_input_a      : STD_LOGIC_VECTOR(15 downto 0);
    signal alu_input_b      : STD_LOGIC_VECTOR(15 downto 0);
    signal alu_result       : STD_LOGIC_VECTOR(15 downto 0);
    signal alu_status       : STD_LOGIC_VECTOR(2 downto 0);
    
    -- Memory signals
    signal mem_addr         : STD_LOGIC_VECTOR(7 downto 0);
    signal mem_data_out     : STD_LOGIC_VECTOR(15 downto 0);
    signal mem_data_in      : STD_LOGIC_VECTOR(15 downto 0);
    
begin
    
    -- =============================================
    -- INSTRUCTION FETCH STAGE
    -- =============================================
    
    FETCH_UNIT : instruction_fetch
        port map (
            CLK         => CLK,
            RESET       => RESET,
            enable      => enable,
            PC_out      => PC
        );
    
    INSTR_MEM : instruction_memory
        port map (
            addr        => PC,
            instruction => instruction
        );
    
    -- =============================================
    -- INSTRUCTION DECODE STAGE
    -- =============================================
    
    DECODER : instruction_decoder
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
    
    -- For I-type instructions, destination register is in bits 11-8 (not 11-9)
    -- Extract 4-bit register address and use only lower 3 bits
    rd_addr_final <= instruction(11 downto 8) when is_i_type = '1' else rd_addr;
    
    -- Sign-extend immediate value to 16 bits (though for this project we don't need sign extension)
    immediate_ext <= X"00" & immediate;
    
    -- =============================================
    -- REGISTER FILE
    -- =============================================
    
    REG_FILE : entity registerFile.registerFile(behavioral)
        port map (
            data_in     => reg_data_in,
            rs_num      => rs_addr,
            rt_num      => rt_addr,
            rd_num      => rd_addr_final,
            CLK         => CLK,
            write       => reg_write,
            rs_out      => rs_data,
            rt_out      => rt_data
        );
    
    -- =============================================
    -- ALU INPUT MULTIPLEXING
    -- =============================================
    
    -- For ldi instruction, ALU is bypassed; for R-type, use register values
    alu_input_a <= rs_data;
    alu_input_b <= rt_data;
    
    -- =============================================
    -- ALU
    -- =============================================
    
    ALU : entity alu16.alu16(behavioral)
        port map (
            A       => alu_input_a,
            B       => alu_input_b,
            S2      => opcode(2),
            S1      => opcode(1),
            S0      => opcode(0),
            status  => alu_status,
            R       => alu_result
        );
    
    -- =============================================
    -- DATA MEMORY
    -- =============================================
    
    -- Memory address comes from immediate value for sh/lh instructions
    mem_addr <= immediate;
    
    -- Memory data input comes from rt_data for sh instruction
    mem_data_in <= rt_data;
    
    DATA_MEM : entity ram256.RAM256(behavioral)
        port map (
            data_in     => mem_data_in,
            rd_addr     => mem_addr,
            wr_addr     => mem_addr,
            CLK         => CLK,
            write       => mem_write,
            data_out    => mem_data_out
        );
    
    -- =============================================
    -- WRITE-BACK MULTIPLEXING
    -- =============================================
    
    -- Select data to write back to register file:
    -- - For lh: memory data
    -- - For ldi: immediate value
    -- - For R-type: ALU result
    reg_data_in <= mem_data_out when mem_to_reg = '1' else
                   immediate_ext when (opcode = "101") else  -- ldi
                   alu_result;
    
    -- =============================================
    -- DEBUG OUTPUTS
    -- =============================================
    
    PC_debug <= PC;
    instruction_debug <= instruction;
    
    -- For debugging: output r6 and r7 values
    -- These would normally require additional read ports on the register file
    -- For now, we'll just connect to dummy signals
    -- In a real implementation, you'd add debug read ports to the register file
    r6_debug <= (others => '0');  -- Placeholder
    r7_debug <= (others => '0');  -- Placeholder
    
end architecture structural;