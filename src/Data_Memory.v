module Data_Memory(
        input clk,WE,MemRead,
        input [31:0]A,WD,
        output [31:0]RD
    );

    reg [31:0] mem [1023:0];
    
    //Write on clock edge
    always @ (posedge clk)
    begin
        if(WE)
            mem[A[11:2]] <= WD;
    end

    assign RD = (MemRead) ?  mem[A[11:2]]: 32'd0 ;

    
    
    // Initialize memory from hex file
   initial begin
        $readmemh("dmem.hex", mem);
    end

endmodule
