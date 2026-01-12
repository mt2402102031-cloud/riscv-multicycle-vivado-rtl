`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 01:53:08 PM
// Design Name: 
// Module Name: flopenr
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


module flopenr #(parameter WIDTH = 8)
		(input logic clk, reset, en, input logic [WIDTH-1:0] d, output logic [WIDTH-1:0] q);
	
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= '0;
		else if (en) q <= d;
		          else q <= q;

endmodule