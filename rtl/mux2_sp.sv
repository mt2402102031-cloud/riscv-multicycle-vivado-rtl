`timescale 1ns / 1ps
module mux2_sp #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [6:0] y);
  logic [31:0] y1;
  assign y1 = s ? d1 : d0; 
  assign y = y1[8:2];
endmodule

