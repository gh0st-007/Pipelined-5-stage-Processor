module Pipeline_Top(
    input clk,rst
    );
    
    //Control signals
    
    //Control Unit
    //output - Decode
    wire RegWriteD,MemWriteD,MemReadD, JumpD,BranchD, ALUSrcD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    
    //output - Execute
    wire RegWriteE,MemWriteE,MemReadE, JumpE,BranchE, ALUSrcE;
    wire [1:0] ResultSrcE;
    wire [2:0] ALUControlE;
    wire PCSrcE;
    
    //Memory
    wire RegWriteM,MemWriteM,MemReadM;
    wire [1:0] ResultSrcM;
    
    //WB
    wire RegWriteW;
    wire [1:0] ResultSrcW;
    //input
    wire [7:0] op, funct7;
    wire [2:0] funct3;
    
    
    
    //hazard unit wires
    //output
    wire StallF,StallD,FlushD, FlushE;
    wire [1:0] ForwardAE, ForwardBE;
    
    
    
    //Data signals
    wire [31:0] PCTargetE,PCF_In,PCF_Out,PCD,PCE,PCPlus4F,PCPlus4D,PCPlus4E,PCPlus4M,PCPlus4W;
    wire [31:0] InstrF,InstrD;
    wire [31:0] ResultW;
    wire [31:0] ImmExtD, ImmExtE;
    wire [31:0] RD1D,RD2D,RD1E,RD2E;
    wire [31:0] SrcAE,SrcBE;
    wire [31:0] WriteDataE,WriteDataM;
    wire [31:0] ReadDataM, ReadDataW;
    wire [31:0] ALUResultM, ALUResultE,ALUResultW;
    wire ZeroE;
    wire [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdD,RdE,RdM,RdW;
    
    assign PCSrcE = JumpE | (BranchE & ZeroE);
    
    Mux2to1 PC_input_sel(
                .in1(PCPlus4F),
                .in2(PCTargetE),
                .sel(PCSrcE),
                .out(PCF_In)
                );
    
    Program_Counter PC(
                .clk(clk),
                .rst(rst),
                .En(StallF),
                .PC_Next(PCF_In),
                .PC(PCF_Out)
                );
    PC_Adder PC_Add(
                .a(PCF_Out),
                .b(32'd4),
                .c(PCPlus4F)
                );
    
    Instruction_Memory Instr_mem(
                .rst(rst),
                .A(PCF_Out),
                .RD(InstrF)
                );
    IF_ID_Reg FD_pipeline_reg(
                .clk(clk), 
                .Flush(FlushD),
                .Stall(StallD),
                .reset(rst),
                .PC_In(PCF_Out),
                .Instr_In(InstrF),
                .PC_plus4_In(PCPlus4F),
                .PC_Out(PCD),
                .Instr_Out(InstrD),
                .PC_plus4_Out(PCPlus4D)
                );
    Register_File RF(
                .clk(clk),
                .rst(rst),
                .WE3(RegWriteW),
                .A1(InstrD[19:15]),
                .A2(InstrD[24:20]),
                .A3(RdW),
                .WD3(ResultW),
                .RD1(RD1D),
                .RD2(RD2D)
                );
    Immediate_Generator IG(
                .In(InstrD[31:7]),
                .ImmSrcD(ImmSrcD),
                .ImmExtD(ImmExtD)
                );
    Control_Unit CU(
                .Op(InstrD[6:0]),
                .funct7(InstrD[31:25]),
                .funct3(InstrD[14:12]),
                .ImmSrc(ImmSrcD),
                .ALUSrc(ALUSrcD),
                .Jump(JumpD),
                .Branch(BranchD),
                .ALUControl(ALUControlD),
                .MemWrite(MemWriteD),
                .MemRead(MemReadD),
                .ResultSrc(ResultSrcD),
                .RegWrite(RegWriteD)
                );
                 assign RdD = InstrD[11:7];
                 assign Rs1D = InstrD[19:15];
                 assign Rs2D = InstrD[24:20];
    ID_IE_Reg DE_pipeline_reg(
                .clk(clk),
                .reset(rst),
                .flush(FlushE), //this flush inserts bubble into execute stage
                .PC_In(PCD),
                .PC_plus4_In(PCPlus4D),
                .RD1_In(RD1D),
                .RD2_In(RD2D),
                .Imm_In(ImmExtD),
                .Rd_In(RdD),
                .Rs1_In(Rs1D),
                .Rs2_In(Rs2D),
                .ALU_Src_In(ALUSrcD),
                .Branch_In(BranchD),
                .Jump_In(JumpD),
                .ALU_Control_In(ALUControlD),
                .Mem_Read_In(MemReadD),
                .Mem_Write_In(MemWriteD),
                .Reg_write_In(RegWriteD),
                .ResultSrc_In(ResultSrcD),
                .PC_Out(PCE),
                .PC_plus4_Out(PCPlus4E),
                .RD1_out(RD1E),
                .RD2_out(RD2E),
                .Imm_out(ImmExtE),
                .RD_out(RdE),
                .Rs1_Out(Rs1E),
                .Rs2_Out(Rs2E),
                .ALU_Src_Out(ALUSrcE),
                .Branch_Out(BranchE),
                .Jump_Out(JumpE),
                .ALU_Control_Out(ALUControlE),
                .Mem_Read_Out(MemReadE),
                .Mem_Write_Out(MemWriteE),
                .Reg_write_Out(RegWriteE),
                .ResultSrc_Out(ResultSrcE)
                );
    Mux4to1 ALU_Input_A(
                .in1(RD1E),
                .in2(ResultW),
                .in3(ALUResultM),
                .in4(32'b0),
                .sel(ForwardAE),
                .out(SrcAE)
                );
    Mux4to1 ALU_Input_B(
                .in1(RD2E),
                .in2(ResultW),
                .in3(ALUResultM),
                .in4(32'b0),
                .sel(ForwardBE),
                .out(WriteDataE)
                );
    Mux2to1 ALU_B_sel(
                .in1(WriteDataE),      
                .in2(ImmExtE),
                .sel(ALUSrcE),
                .out(SrcBE)
                );
    ALU alu_unit(
                .A(SrcAE),
                .B(SrcBE),
                .ALUControl(ALUControlE),
                .Result(ALUResultE),
                .Zero(ZeroE)
                );
    PC_Adder imm_adder(
                .a(PCE),
                .b(ImmExtE),
                .c(PCTargetE)
                );
    EX_MEM_Reg EM_pipeline_reg(
                .clk(clk),
                .reset(rst),
                .PC_plus4_In(PCPlus4E),
                .Write_Data_In(WriteDataE),
                .ALU_Result_In(ALUResultE),
                .Rd_In(RdE),
                .Mem_Read_In(MemReadE),
                .Mem_Write_In(MemWriteE),
                .Reg_write_In(RegWriteE),
                .ResultSrc_In(ResultSrcE),
                .PC_plus4_Out(PCPlus4M),
                .Write_Data_Out(WriteDataM),
                .ALU_Result_Out(ALUResultM),
                .RD_out(RdM),
                .Mem_Read_Out(MemReadM),
                .Mem_Write_Out(MemWriteM),
                .Reg_write_Out(RegWriteM),
                .ResultSrc_Out(ResultSrcM)
                );
    Data_Memory Data_Mem(
                .clk(clk),
                .WE(MemWriteM),
                .MemRead(MemReadM),
                .A(ALUResultM),
                .WD(WriteDataM),
                .RD(ReadDataM)
                );
    MEM_WB MW_pipeline_reg(
                .clk(clk),
                .reset(rst),
                .PC_plus4_In(PCPlus4M),
                .Read_Data_In(ReadDataM),
                .ALU_Result_In(ALUResultM),
                .Rd_In(RdM),
                .Reg_write_In(RegWriteM),
                .ResultSrc_In(ResultSrcM),
                .PC_plus4_Out(PCPlus4W),
                .Read_Data_Out(ReadDataW),
                .ALU_Result_Out(ALUResultW),
                .RD_out(RdW),
                .Reg_write_Out(RegWriteW),
                .ResultSrc_Out(ResultSrcW)
                );
     Mux4to1 Result_WB_sel(
                .in1(ALUResultW),
                .in2(ReadDataW),
                .in3(PCPlus4W),
                .in4(32'b0),
                .sel(ResultSrcW),
                .out(ResultW)
                );
    Hazard_Unit HU(
                .Rs1_D(Rs1D),
                .Rs2_D(Rs2D),
                .Rs1_E(Rs1E),
                .Rs2_E(Rs2E),
                .Rd_E(RdE),
                .Rd_M(RdM),
                .Rd_W(RdW),
                .PCSrcE(PCSrcE),
                .RegWriteM(RegWriteM),
                .RegWriteW(RegWriteW),
                .ResultSrcE(ResultSrcE[0]),
                .StallF(StallF),
                .StallD(StallD),
                .FlushD(FlushD),
                .FlushE(FlushE),
                .ForwardAE(ForwardAE),
                .ForwardBE(ForwardBE)
    );
    
endmodule
