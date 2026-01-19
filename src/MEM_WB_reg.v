module MEM_WB(
    input clk,reset,
    // data signals
    input [31:0] PC_plus4_In, Read_Data_In, ALU_Result_In,
    input [4:0]  Rd_In,

    // CONTROL SIGNALS
    input Reg_write_In,
    input [1:0] ResultSrc_In,
    
    // Outputs
    output reg [31:0] PC_plus4_Out, Read_Data_Out, ALU_Result_Out,
    output reg [4:0]  RD_out, 
  
    output reg Reg_write_Out,
    output reg [1:0] ResultSrc_Out
);

    always @(posedge clk) begin
        if (~reset) begin
            //  data stuff
            PC_plus4_Out<= 32'b0;
            Read_Data_Out     <= 32'b0;
            ALU_Result_Out     <= 32'b0;
            RD_out      <= 5'b0;

            // control stuff
            Reg_write_Out <= 1'b0;
            ResultSrc_Out  <= 2'b00;
        end
        else begin
            // data stuff
            
            PC_plus4_Out<= PC_plus4_In;
            Read_Data_Out     <= Read_Data_In;
            ALU_Result_Out     <= ALU_Result_In;
            RD_out      <= Rd_In;
            
            // control stuff
            Reg_write_Out   <= Reg_write_In;
            ResultSrc_Out   <= ResultSrc_In;
            
        end
    end
    initial begin
            PC_plus4_Out= 32'b0;
            Read_Data_Out    = 32'b0;
            ALU_Result_Out     = 32'b0;
            RD_out      = 5'b0;

            // control stuff
            Reg_write_Out = 1'b0;
            ResultSrc_Out  = 2'b00;
    end

endmodule
