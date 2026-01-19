
module Hazard_Unit(
    input [4:0] Rs1_D,Rs2_D,Rs1_E,Rs2_E,Rd_E,Rd_M,Rd_W,
    input PCSrcE,RegWriteM,RegWriteW,ResultSrcE,
    output reg StallF,StallD,FlushD,FlushE,
    output reg [1:0] ForwardAE, ForwardBE
    );
    reg lwstall;
    //Forward to solv data hazards when possible
    //Rs1_E and Rs2_E  are the addresses of the 2 operands required in the execute stage
    //Rd_M is the destination register address and RegWriteM indicates whether the instruction 
    // in the Memory stage requires a value to be written into the register file
    
    //Rd_W is the destination register address and RegWriteW indicates whether the instruction
    // in the WriteBack stage requires a value to be written into the register file.
    always @(*) begin
    //First, we are checking if the first input of ALU requires a value which is yet to be written
    // and so needs to be imported from the writeback or memory stage.
        if(((Rs1_E == Rd_M) & RegWriteM) & (Rs1_E != 0))
            ForwardAE=2'b10;
        else if (((Rs1_E == Rd_W) & RegWriteW) & (Rs1_E != 0))
            ForwardAE=2'b01;
        else
            ForwardAE=2'b00;
            
        if(((Rs2_E == Rd_M) & RegWriteM) & (Rs2_E != 0))
            ForwardBE=2'b10;
        else if (((Rs2_E == Rd_W) & RegWriteW) & (Rs2_E != 0))
            ForwardBE=2'b01;
        else
            ForwardBE=2'b00;
            
    end
    
    always @(*) begin
        //Stall when a load hazard occurs
        // stalling is done when there is a load word instruction in the execute stage and the destination register
        //matches the source operands of the instructions in the decode stage
        lwstall  = ResultSrcE & ((Rs1_D == Rd_E)|(Rs2_D == Rd_E));
        StallF = lwstall;
        StallD = lwstall;
        
        //Flush when a branch is taken or a load instroduces a bubble
        FlushE = lwstall | PCSrcE;
        FlushD = PCSrcE;
    end
    
    initial begin
    StallF=1'b0;StallD=1'b0;FlushD=1'b0;FlushE=1'b0;
    ForwardAE=2'b00; ForwardBE=2'b00;
    end
endmodule
