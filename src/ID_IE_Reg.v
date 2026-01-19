module ID_IE_Reg(
    input clk,reset, flush, //this flush inserts bubble into execute stage
    // data signals
    input [31:0] PC_In, PC_plus4_In, RD1_In, RD2_In, Imm_In,
        input [4:0]  Rd_In, Rs1_In,Rs2_In,

    // CONTROL SIGNALS
    // Execute stage
    input ALU_Src_In, Branch_In, Jump_In,
    input [2:0] ALU_Control_In,
    // Mem stage
    input  Mem_Read_In, Mem_Write_In,
    // Writeback stage
    input Reg_write_In,
    input [1:0] ResultSrc_In,
    
    // Outputs
    output reg [31:0] PC_Out, PC_plus4_Out, RD1_out, RD2_out, Imm_out,
    output reg [4:0]  RD_out, Rs1_Out, Rs2_Out,
    
    // Execute stage
    output reg ALU_Src_Out,  Branch_Out, Jump_Out,
    output reg [2:0] ALU_Control_Out,
    // Mem stage
    output reg Mem_Read_Out, Mem_Write_Out,
    // Writeback stage
    output reg Reg_write_Out,
    output reg [1:0] ResultSrc_Out
);

    always @(posedge clk) begin
        if (~reset || flush) begin
            //  data stuff
            PC_Out      <= 32'b0;
            PC_plus4_Out<= 32'b0;
            RD1_out     <= 32'b0;
            RD2_out     <= 32'b0;
            Imm_out     <= 32'b0;
            RD_out      <= 5'b0;
            Rs1_Out     <= 5'b0;
            Rs2_Out     <= 5'b0;

            // control stuff
            ALU_Src_Out   <= 1'b0;
            ALU_Control_Out<= 3'b0;
            Branch_Out    <= 1'b0;
            Jump_Out      <= 1'b0;
            Mem_Read_Out  <= 1'b0;
            Mem_Write_Out <= 1'b0;
            Reg_write_Out <= 1'b0;
            ResultSrc_Out  <= 2'b00;
        end
        else begin
            // data stuff
            PC_Out      <= PC_In;
            PC_plus4_Out<= PC_plus4_In;
            RD1_out     <= RD1_In;
            RD2_out     <= RD2_In;
            Imm_out     <= Imm_In;
            RD_out      <= Rd_In;
            Rs1_Out     <= Rs1_In;
            Rs2_Out     <= Rs2_In;
            // control stuff
            ALU_Src_Out   <= ALU_Src_In;
            ALU_Control_Out<= ALU_Control_In;
            Branch_Out    <= Branch_In;
            Jump_Out      <= Jump_In;
            Mem_Read_Out  <= Mem_Read_In;
            Mem_Write_Out <= Mem_Write_In;
            Reg_write_Out <= Reg_write_In;
            ResultSrc_Out  <= ResultSrc_In;
            
        end
        end
        initial begin
            ALU_Src_Out   = 1'b0;
            ALU_Control_Out= 3'b0;
            Branch_Out   = 1'b0;
            Jump_Out      = 1'b0;
            Mem_Read_Out  = 1'b0;
            Mem_Write_Out = 1'b0;
            Reg_write_Out = 1'b0;
            ResultSrc_Out  = 2'b00;
            PC_Out      = 32'b0;
            PC_plus4_Out= 32'b0;
            RD1_out     = 32'b0;
            RD2_out     = 32'b0;
            Imm_out     = 32'b0;
            RD_out      = 5'b0;
            Rs1_Out     = 5'b0;
            Rs2_Out     = 5'b0;
        
    end

endmodule
