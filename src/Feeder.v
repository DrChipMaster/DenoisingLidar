`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/12/2021 11:47:56 AM
// Design Name:
// Module Name: Fedder
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


module Feeder #(parameter N = 16,
                DISNTANCE_MODULES = 32)
              (input wire clock,
                input wire [N*DISNTANCE_MODULES-1:0]cache_x,
                input wire [N*DISNTANCE_MODULES-1:0]cache_y,
                input wire [N*DISNTANCE_MODULES-1:0]cache_z,
                output reg [N*DISNTANCE_MODULES-1:0] cp_x,
                output reg [N*DISNTANCE_MODULES-1:0] cp_y,
                output reg [N*DISNTANCE_MODULES-1:0] cp_z
                );
    integer i,j;

    always @(posedge clock)
    begin
        cp_x              <= cache_x;
        cp_y              <= cache_y;
        cp_z              <= cache_z;
    end
endmodule
    
    
