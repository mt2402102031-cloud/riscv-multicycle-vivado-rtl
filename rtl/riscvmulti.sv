`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 05:23:56 PM
// Design Name: 
// Module Name: riscvmulti
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


module riscvmulti(input  logic       IR_SW ,clk, reset,
                   output logic        MemWrite,
                   output logic [31:0] DataAdr, WriteData,
                   input  logic [31:0] ReadData);

  logic        RegWrite, Zero, lt_zero, AdrSrc;
  logic [1:0] ResultSrc, ImmSrc;
  logic [1:0] ALUSrcA, ALUSrcB;
  logic 		  IRWrite, PCWrite;
  logic [3:0] ALUControl;
  logic [31:0] Instr;
  controller ctrl(clk, reset, Instr[6:0], Instr[14:12], Instr[30], Zero, lt_zero,
                ImmSrc, ALUSrcA, ALUSrcB, ResultSrc, AdrSrc, ALUControl,
                IRWrite, PCWrite, RegWrite, MemWrite);
  datapath dp(IR_SW,clk, reset, ResultSrc,
               RegWrite,
              ImmSrc, ALUControl,
              Zero, lt_zero, Instr,
              DataAdr, WriteData, ReadData, IRWrite, PCWrite, AdrSrc, ALUSrcA, ALUSrcB);

endmodule
