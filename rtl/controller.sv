`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 01:20:52 PM
// Design Name: 
// Module Name: controller
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


module controller(input  logic clk, reset,
                  input  logic [6:0] op,
                  input  logic [2:0] funct3,
                  input  logic funct7b5,
                  input  logic Zero,
                  input  logic lt_zero,
                  output logic [1:0] ImmSrc,
                  output logic [1:0] ALUSrcA, ALUSrcB,
                  output logic [1:0] ResultSrc,
                  output logic AdrSrc,
                  output logic [3:0] ALUControl,
                  output logic IRWrite, PCWrite,
                  output logic RegWrite, MemWrite
                  );

  logic [1:0] ALUOp;
  logic       Branch, PCUpdate;
  
  // Instantiate the main FSM
	main_fsm fsm_inst (
	  .clk(clk),
	  .reset(reset),
	  .op(op),
	  .Zero(Zero),
	  .ALUSrcA(ALUSrcA),
	  .ALUSrcB(ALUSrcB),
	  .ALUOp(ALUOp),
	  .ResultSrc(ResultSrc),
	  .AdrSrc(AdrSrc),
	  .IRWrite(IRWrite),
	  .PCUpdate(PCUpdate),
	  .MemWrite(MemWrite), 
	  .RegWrite(RegWrite),
	  .Branch(Branch)
	);


  aludec aludec_inst(op[5], funct3, funct7b5, ALUOp, ALUControl);
  instrdec instrdec_inst(op, ImmSrc);
  
  assign PCWrite = Branch & ((funct3 == 3'b000) ? Zero : lt_zero) | PCUpdate;
endmodule
