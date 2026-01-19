module IF_ID_Reg(
        input clk, Flush , Stall, reset,    
        input [31:0] PC_In, Instr_In, PC_plus4_In,
        output reg [31:0] PC_Out, Instr_Out, PC_plus4_Out
    );
    localparam [31:0] NOP = 32'h00000013; // addi x0, x0, 0
    always @(posedge clk) begin
        if(~reset) begin
            PC_Out <= 32'b0;
            PC_plus4_Out <=32'b0;
            Instr_Out <= NOP;
        end
        if(Flush)   begin
            PC_Out <= 32'b0;
            PC_plus4_Out <=32'b0;
            Instr_Out <= NOP;
        end
        else if(~Stall) begin          //stall
            PC_Out <= PC_In;
            PC_plus4_Out <= PC_plus4_Out;
            Instr_Out <= Instr_In;
        end
    end
    initial begin
        PC_Out=32'b0; Instr_Out=32'b0; PC_plus4_Out=32'b0;
    end
endmodule
