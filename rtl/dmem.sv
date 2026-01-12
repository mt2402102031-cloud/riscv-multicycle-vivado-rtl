`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 04:11:50 PM
// Design Name: 
// Module Name: dmem
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
module  dmem #(Width = 32)(
    input  logic        clk,
    input  logic        we,
    input  logic [6:0] a,
    input  logic [Width-1:0] wd,
    output logic [Width-1:0] rd
);
    logic [Width-1:0] RAM[0:127];
  
    always_comb begin
     rd = RAM[a];
    end
    
    always_ff @(posedge clk) begin
     if (we) RAM[a] <= wd;
    end

endmodule

