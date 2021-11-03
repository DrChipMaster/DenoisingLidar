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
                        MIN_SEARCH_RADIUS = 1,
                        ANGULAR_RESOLUTION=1   //Manually calculate, suposed to be 0.3 
                        )

                       (
                        input i_clock,
                        input i_reset,
                        input wire [N-1:0] point_pos,
                        input wire [N-1:0] i_point_x,
                        input wire [N-1:0] i_point_y,
                        input wire [N-1:0] i_point_z,
                        input wire [N-1:0] i_point_i,
                        input wire [N*2-1:0] i_point_cloud_size,
                        input wire [N*DISTANCE_MODULES-1:0] i_cp_x,
                        input wire [N*DISTANCE_MODULES-1:0] i_cp_y,
                        input wire [N*DISTANCE_MODULES-1:0] i_cp_z,
                        input wire [3:0] filter_selector,
                        input wire [7:0] i_neighbor_treshold,
                        input wire [7:0] i_search_radius,
                        input wire [3:0] i_filtertype,
		                input wire [3:0] i_intensity_treshold,
		                input wire [3:0] i_multi_parameter,
                        input wire pause,
                        output reg o_inlier,
                        output reg o_outlier);
    
    wire [(N-1):0] distances[DISTANCE_MODULES-1:0];
    reg [N-1:0] neighbor_counter;
    reg [N-1:0] cycles;
    wire [N-1:0] distance_to_sensor;
    reg [N-1:0]search_radius;
    integer j,k ;

    always @(posedge i_clock)
    begin
        if (i_reset)
            neighbor_counter = 0;
        else
        begin
            if(pause==0) begin
                for (j = 0; j<DISTANCE_MODULES;j = j+1)  //compare all the results from the distance modules
                begin
                    if (distances[j]<=search_radius)
                        neighbor_counter = neighbor_counter+1;
                end
            end
        end           
    end


    always @(posedge i_clock)
    begin
        if(filter_selector != 1 )
        begin   
            if (distance_to_sensor < MIN_SEARCH_RADIUS) begin
                search_radius <= MIN_SEARCH_RADIUS;
            end
            else begin
                search_radius <= (distance_to_sensor/ANGULAR_RESOLUTION)/i_multi_parameter; //Calculate search radius
            end
        end
        else
        begin
            search_radius <= i_search_radius;
        end
    end
    
    always @(posedge i_clock)
    begin
        if (i_reset == 1)begin    
            cycles  <= 0;
            o_inlier  <= 0;
            o_outlier <= 0;
        end
        else if(pause==0&& o_inlier ==0 && o_outlier==0)
        begin
            cycles = cycles +DISTANCE_MODULES;
            if((filter_selector >=1) && (i_point_i > i_intensity_treshold)) begin                      //0->DROR 1->LIOR 2->DLIOR
                o_inlier  <= 1;
                o_outlier <= 0;
            end
            else
            begin
                if(filter_selector ==1 && neighbor_counter > i_neighbor_treshold)
                begin
                    o_inlier  <= 1;
                    o_outlier <= 0;
                end
                else
                if (filter_selector!=1 && neighbor_counter > i_neighbor_treshold)  // check if niegbhor counter reached the treshold to be classified as a o_inlier
                begin
                    o_inlier  <= 1;
                    o_outlier <= 0;
                end
                else    //keep comparing 
                begin
                    o_inlier <= 0;
                    if (cycles >= (i_point_cloud_size-64)) // reached max comparisons and point is a o_outlier
                        o_outlier <= 1;
                    else
                        o_outlier <= 0;
                end
            end
        end
    end
    
    
    
    

            
            
            
            
            
            
            
    generate
    genvar aux;
    for (aux = 0; aux<DISTANCE_MODULES; aux = aux+1)
    begin
        
        distance_calculator
        #(.N(N)) calculate_distance(
        .clock(i_clock),
        .point_x1(i_point_x),
        .point_y1(i_point_y),
        .point_z1(i_point_z),
        
        .point_x2(i_cp_x[(aux+1)*(N)-1:aux*(N)]),
        .point_y2(i_cp_y[(aux+1)*(N)-1:aux*(N)]),
        .point_z2(i_cp_z[(aux+1)*(N)-1:aux*(N)]),
        .distance(distances[aux])
        );
    end
    endgenerate
    
    distance_calculator #(.N(N), .POINT_3D(0)) point_distance
    (
        .clock(i_clock),
        .point_x1(i_point_x),
        .point_y1(i_point_y),   
        .point_z1(0),     
        .point_x2(0),
        .point_y2(0),
        .point_z2(0),
        .distance(distance_to_sensor)
    );
    
    
endmodule
