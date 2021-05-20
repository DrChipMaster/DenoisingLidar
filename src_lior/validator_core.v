`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/06/2021 05:39:58 PM
// Design Name:
// Module Name: validator_core
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
/*
Main goal of this module 

*/

module validator_core #(parameter N = 16,
                        DISTANCE_MODULES = 8,
                        NEIGHBOR_TRESHOLD = 5,
                        SEARCH_RADIUS = 50,
                        INTENSITY_TRESHOLD = 4)
                       (input clock,
                        input reset,
                        input wire [N-1:0] point_x,
                        input wire [N-1:0] point_y,
                        input wire [N-1:0] point_z,
                        input wire [N-1:0] point_i,
                        input wire [N*2-1:0] point_cloud_size,
                        input wire [N*DISTANCE_MODULES-1:0] cp_x,
                        input wire [N*DISTANCE_MODULES-1:0] cp_y,
                        input wire [N*DISTANCE_MODULES-1:0] cp_z,
                        output reg inlier,
                        output reg outlier);
    
    wire [(N-1):0] distances[DISTANCE_MODULES-1:0];
    reg [N-1:0] neighbor_counter;
    reg [N-1:0] cycles;
    integer j,k ;

    
    always @(posedge clock)
    begin
        if (reset == 1)begin    
            cycles  <= 0;
            inlier  <= 0;
            outlier <= 0;
        end
        else
        begin
            cycles = cycles +DISTANCE_MODULES;

            if (point_i > INTENSITY_TRESHOLD) begin
                inlier  <= 1;
                outlier <= 0;
            end    
            else
            begin       
                if (neighbor_counter >= NEIGHBOR_TRESHOLD)  // check if niegbhor counter reached the treshold to be classified as a inlier
                begin
                    inlier  <= 1;
                    outlier <= 0;
                end
                else    //keep comparing 
                begin
                    inlier <= 0;
                    if (cycles >= point_cloud_size) // reached max comparisons and point is a outlier
                        outlier <= 1;
                    else
                        outlier <= 0;
                end
            end
        end
    end
    
    
    
    
    always @(posedge clock)
    begin
        if (reset)
            neighbor_counter = 0;
        else
        begin
            for (j = 0; j<DISTANCE_MODULES;j = j+1)  //compare all the results from the distance modules
            begin
                if (distances[j]<=SEARCH_RADIUS)
                    neighbor_counter = neighbor_counter+1;
            end
        end           
    end
            
            
            
            
            
            
            
    generate
    genvar aux;
    for (aux = 0; aux<DISTANCE_MODULES; aux = aux+1)
    begin
        
        distance_calculator
        #(.N(N)) calculate_distance(
        .clock(clock),
        .point_x1(point_x),
        .point_y1(point_y),
        .point_z1(point_z),
        
        .point_x2(cp_x[(aux+1)*(N)-1:aux*(N)]),
        .point_y2(cp_y[(aux+1)*(N)-1:aux*(N)]),
        .point_z2(cp_z[(aux+1)*(N)-1:aux*(N)]),
        .distance(distances[aux])
        );
    end
    endgenerate
    
    
    
    
endmodule
