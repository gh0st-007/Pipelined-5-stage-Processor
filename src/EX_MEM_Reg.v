module EX_MEM_Reg(
      input clk,reset,
    // data signals
    input [31:0] PC_plus4_In, Write_Data_In, ALU_Result_In,
    input [4:0]  Rd_In,

    // CONTROL SIGNALS
    // Mem stage
    input  Mem_Read_In, Mem_Write_In,
    // Writeback stage
    input Reg_write_In,
    input [1:0] ResultSrc_In,
    
    // Outputs
    output reg [31:0] PC_plus4_Out, Write_Data_Out, ALU_Result_Out,
    output reg [4:0]  RD_out, 
    
    // Mem stage
    output reg Mem_Read_Out, Mem_Write_Out,
    // Writeback stage
    output reg Reg_write_Out,
    output reg [1:0] ResultSrc_Out
);

    always @(posedge clk) begin
        if (~reset) begin
            //  data stuff
            PC_plus4_Out<= 32'b0;
            Write_Data_Out     <= 32'b0;
            ALU_Result_Out     <= 32'b0;
            RD_out      <= 5'b0;

            // control stuff
            Mem_Read_Out  <= 1'b0;
            Mem_Write_Out <= 1'b0;
            Reg_write_Out <= 1'b0;
            ResultSrc_Out  <= 2'b00;
        end
        else begin
            // data stuff
            
            PC_plus4_Out<= PC_plus4_In;
            Write_Data_Out     <= Write_Data_In;
            ALU_Result_Out     <= ALU_Result_In;
            RD_out      <= Rd_In;
            
            // control stuff
            
            Mem_Read_Out    <= Mem_Read_In;
            Mem_Write_Out   <= Mem_Write_In;
            Reg_write_Out   <= Reg_write_In;
            ResultSrc_Out   <= ResultSrc_In;
            
        end
    end
    initial begin
        PC_plus4_Out= 32'b0;
            Write_Data_Out     = 32'b0;
            ALU_Result_Out     = 32'b0;
            RD_out      = 5'b0;

            // control stuff
            Mem_Read_Out  = 1'b0;
            Mem_Write_Out = 1'b0;
            Reg_write_Out= 1'b0;
            ResultSrc_Out  = 2'b00;
    end

endmodule
