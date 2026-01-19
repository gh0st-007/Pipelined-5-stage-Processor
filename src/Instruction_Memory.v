module Instruction_Memory(
                  input rst,
                  input [31:0]A,
                  output [31:0]RD
                  );

    reg [31:0] mem [1023:0];
  
    assign RD = (~rst) ? {32{1'b0}} : mem[A[11:2]]; //31:2 because the instructions will be word-aligned.
    initial begin
        $readmemh("imem.hex",mem);
    end
endmodule
