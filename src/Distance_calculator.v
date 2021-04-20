`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/31/2021 06:55:00 PM
// Design Name:
// Module Name: square_root
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


module distance_calculator #(parameter N = 16,
                             POINT_3D = 1)
                           (
                             input wire clock,
                             input wire [N-1:0] point_x1,
                             input wire [N-1:0] point_y1,
                             input wire [N-1:0] point_z1,
                             input wire [N-1:0] point_x2,
                             input wire [N-1:0] point_y2,
                             input wire [N-1:0] point_z2,
                             output wire [N-1:0] distance);
    
    reg[N*2-1:0] num_in;
    reg[N-1:0] vector_x;
    reg[N-1:0] vector_y;
    reg[N-1:0] vector_z;
    
    always @(clock)
    begin
        vector_x = point_x1-point_x2;
        if (vector_x[N-1] == 1'b1) begin
            vector_x = -vector_x;
        end
        vector_y = point_y1 - point_y2;
        if (vector_y[N-1] == 1'b1) begin
            vector_y = -vector_y;
        end
        
        if (POINT_3D)
        begin
            vector_z = point_z1- point_z2 ;  
            if (vector_z[N-1] == 1'b1) begin
                vector_z = -vector_z;
            end
            num_in <= ((vector_x**2)+ (vector_y**2)+(vector_z**2));
        end
        else
        begin
            num_in <= (vector_x**2)+ (vector_y**2);
        end
    end
    
    
    square_root #(.N(N*2)) find_sq_root
    (
    .clock(clock),
    .num(num_in),
    .sq_root(distance)
    );
    
    
endmodule
