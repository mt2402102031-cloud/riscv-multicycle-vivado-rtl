`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 02:00:27 PM
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath #(parameter Width = 32)(input  logic IR_SW,clk, reset,
                input  logic [1:0]  ResultSrc, 
                input  logic        RegWrite,
                input  logic [1:0]  ImmSrc,
                input  logic [3:0]  ALUControl,
                output logic        Zero,
		output logic		lt_zero,
                output logic [Width-1:0] Instr,
                output logic [Width-1:0] DataAdr, WriteData,
                input  logic [Width-1:0] ReadData,
					 input  logic  		IRWrite, PCWrite,
					 input  logic 			AdrSrc,
					 input  logic [1:0] 	ALUSrcA, ALUSrcB);

  logic [Width-1:0] PC, PCNext, OldPC;
  logic [Width-1:0] ImmExt;
  logic [Width-1:0] RD1, RD2, A, SrcA, SrcB, Data;
  logic [Width-1:0] Result, ALUReseult, ALUOut;
  
  logic IRWrite_i;
   
  assign IRWrite_i = IR_SW ? 1'b0 : IRWrite;

  assign PCNext = Result;
  flopenr #(Width) pcflop(clk, reset, PCWrite, PCNext, PC);
  mux2 #(Width) adrmux(PC, Result, AdrSrc, DataAdr); 
  
  flopenr #(Width) memflop1(clk, reset, IRWrite_i, PC, OldPC);
  flopenr #(Width) memflop2(clk, reset, IRWrite_i, ReadData, Instr);
  flopr #(Width) dataflop(clk, reset, ReadData, Data);
  
  regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, RD1, RD2);
  extend      ext(Instr[31:7], ImmSrc, ImmExt);
  
  flopr #(Width) reg_f1(clk, reset, RD1, A);
  flopr #(Width) reg_f2(clk, reset, RD2, WriteData);
  
  mux3 #(Width)  SrcAMux(PC, OldPC, A, ALUSrcA, SrcA);
  mux3 #(Width)  SrcBMux(WriteData, ImmExt, 32'd4, ALUSrcB, SrcB);
  
  alu alu(SrcA, SrcB, ALUControl, ALUReseult, Zero, lt_zero);
  
  flopr #(Width) alu_result_out(clk, reset, ALUReseult, ALUOut);
  mux3 #(Width)  resultMux(ALUOut, Data, ALUReseult, ResultSrc, Result);
  
endmodule
