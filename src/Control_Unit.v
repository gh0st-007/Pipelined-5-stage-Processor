module Control_Unit(
        input [6:0] Op, funct7,
        input [2:0] funct3,
        //decode
        output [1:0]ImmSrc,
        //execute
        output ALUSrc,Jump, Branch,
        output [2:0] ALUControl, 
        //MEM stage
        output  MemWrite,MemRead,
        //WB
        output  [1:0]ResultSrc, 
        output RegWrite
        
    );
    wire [2:0]ALUOp;

    Main_Decoder Main_Decoder(
                .Op(Op),
                .funct3(funct3),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp),
                .MemRead(MemRead),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .RegWrite(RegWrite),
                .Jump(Jump),
                .Branch(Branch)                
    );

    ALU_Decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(funct3),
                            .funct7(funct7),
                            .ALUControl(ALUControl)
    );
    
    Instr_Decoder Instr_Decode(
                            .Op(Op),
                            .ImmSrc(ImmSrc)
    );


endmodule
