`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 01:38:15 PM
// Design Name: 
// Module Name: alu
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


module alu(input  logic [31:0] a, b,
           input  logic [3:0]  alucontrol,
           output logic [31:0] result,
           output logic        Zero,
			  output logic			 lt_zero);

  logic [31:0] condinvb, sum;
 // logic        v;              // overflow
  logic        isAddSub;       // true when is add or subtract operation

  assign condinvb = alucontrol[0] ? ~b : b;
  assign sum = a + condinvb + alucontrol[0];
  //assign isAddSub = ~alucontrol[2] & ~alucontrol[1] |
  //                  ~alucontrol[1] & alucontrol[0];

  always_comb
    case (alucontrol)
      4'b0000:  result = sum;                 // add
      4'b0001:  result = sum;                 // subtract
      4'b0010:  result = a & b;               // and
      4'b0011:  result = a | b;       			 // or
      4'b0100:  result = a ^ b;       			 // xor
      4'b0101:  result = (a < b) ? 32'd1 : 32'd0;       // slt
      4'b0110:  result = a << b;       		 // sll
      4'b0111:  result = a >> b;       		 // srl
		4'b1001:  result = a >> b[4:0]; 			 //sra
      default: result = 32'b0;
    endcase

  assign Zero = (result == 32'b0);
  assign lt_zero = result[31];
 // assign v = ~(alucontrol[0] ^ a[31] ^ b[31]) & (a[31] ^ sum[31]) & isAddSub;
  
endmodule
