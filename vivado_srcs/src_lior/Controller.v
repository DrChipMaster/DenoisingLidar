`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/12/2021 11:47:56 AM
// Design Name:
// Module Name: Controller
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


module Controller #(parameter N = 16,
                    DISTANCE_MODULES = 16,
                    CORE_NUMBER = 16)
                   (input wire clock,
                    input wire reset,
                    input wire [N*DISTANCE_MODULES-1:0]cache_feeder_x,
                    input wire [N*DISTANCE_MODULES-1:0]cache_feeder_y,
                    input wire [N*DISTANCE_MODULES-1:0]cache_feeder_z,
                    input wire [N*CORE_NUMBER-1:0] cache_x,
                    input wire [N*CORE_NUMBER-1:0] cache_y,
                    input wire [N*CORE_NUMBER-1:0] cache_z,
                    input wire [N*CORE_NUMBER-1:0] cache_i,
                    input wire [N*2-1:0] point_cloud_size,
                    input wire read_fifo,
                    output wire[N-1:0] outlier_pos_fifo,
                    output reg[N*2-1:0] point_pos,
                    output wire empty,
                    output reg done);
    
    
    reg [N-1:0] point_x [CORE_NUMBER-1:0];
    reg [N-1:0] point_y [CORE_NUMBER-1:0];
    reg [N-1:0] point_z [CORE_NUMBER-1:0];
    reg [N-1:0] point_i [CORE_NUMBER-1:0];

    reg [N*2-1:0] fifo_buffer[CORE_NUMBER*2-1:0];
    reg [N*2-1:0] point_pos_buffer [CORE_NUMBER-1:0];
    
    reg [N-1:0]fifo_write_size;
        
    reg [CORE_NUMBER-1:0]reset_core;
    
    reg write_fifo;
    
    wire [N*DISTANCE_MODULES-1:0] cp_x;
    wire [N*DISTANCE_MODULES-1:0] cp_y;
    wire [N*DISTANCE_MODULES-1:0] cp_z;
    
    wire inlier [CORE_NUMBER-1:0];
    wire outlier [CORE_NUMBER-1:0];
    
    
    reg [N-1:0] output_to_fifo ;
    
    wire full;
    
    reg[N-1:0]  finish_counter;    
    
    
    integer i,k;
    
    always @(posedge clock)
    begin
        if (reset == 1)
        begin
            finish_counter     <= 0;
            done               <= 0;
            output_to_fifo     <= 0;
            write_fifo         <= 0;
            fifo_write_size    <= 0;
            for (i = 0;i<CORE_NUMBER;i = i+1)   // Give points to all cores
            begin
                reset_core[i] <= 1;
                point_x[i]    <= cache_x[(i+1)*N-1 -:N];
                point_y[i]    <= cache_y[(i+1)*N-1 -:N];
                point_z[i]    <= cache_z[(i+1)*N-1 -:N];
                point_i[i]    <= cache_i[(i+1)*N-1 -:N];
                point_pos_buffer[i] =i;

            end
            for (i = 0;i<CORE_NUMBER*2;i = i+1)
            begin
                fifo_buffer[i] <= 0;     // Clear the fifo buffer
            end
            point_pos <=CORE_NUMBER-1;
            //point_pos_buffer[0] = i;
        end
        else if (done == 0)  // Prevent controller from overdoing point validation 
        begin



            finish_counter     = 0;
            for (i = 0;i<CORE_NUMBER;i = i+1)    // Analize every core output
            begin
                if ((inlier[i] == 1 || outlier[i] == 1) &&  reset_core[i] == 0)   // core finished and needs new point
                begin
                    
                    if (outlier[i] == 1)   // if the point is an outlier save it in the fif o buffer and update the fif o buffer size
                    begin
                        fifo_buffer[fifo_write_size] = point_pos_buffer[i];
                        fifo_write_size              = fifo_write_size +1;
                    end
                    point_pos           = point_pos + 1;   //update core base point and saves the pointer
                    point_pos_buffer[i] = point_pos  ;
                    point_x[i] <= cache_x[(finish_counter+1)*N-1 -:N];
                    point_y[i] <= cache_y[(finish_counter+1)*N-1 -:N];
                    point_z[i] <= cache_z[(finish_counter+1)*N-1 -:N];
                    point_i[i] <= cache_i[(finish_counter+1)*N-1 -:N];

                    finish_counter = finish_counter+1;   // update core finish counter to know wich point of the cache needs to be loaded
                    reset_core[i] <= 1;  //put core in a reset state 
                end
                else
                    begin
                        if (reset_core[i] == 1)  
                            reset_core[i] <= 0;
                    end
            end
            if (fifo_write_size >= 1 )   // fifo_buffer has enough points to store
            begin
                write_fifo = 1;
                output_to_fifo = fifo_buffer[fifo_write_size-1];
                fifo_write_size <= fifo_write_size-1; // update fifo buffer lenght
            end
            else write_fifo = 0;  //disable fifo write
            
            if (point_pos>=point_cloud_size)  // check if point cloud validation was finished
            begin
                write_fifo = 0; 
                done       <= 1;  // flag that controller has finished
            end
                
            end
        end
            
            
            
            
            
            
            
            fifo_generator_0 my_fifo (
            .clk(clock),                  // input wire clk
            .srst(reset),                // input wire srst
            .din(output_to_fifo),                  // input wire [31 : 0] din
            .wr_en(write_fifo),              // input wire wr_en
            .rd_en(read_fifo),              // input wire rd_en
            .dout(outlier_pos_fifo),                // output wire [15 : 0] dout
            .full(full),                // output wire full
            .empty(empty)              // output wire empty
            );
            
            
            
            
            
            
            Feeder
            #(.N(N),.DISTANCE_MODULES(DISTANCE_MODULES)) m_feeder(
            .clock(clock),
            .cache_x(cache_feeder_x),
            .cache_y(cache_feeder_y),
            .cache_z(cache_feeder_z),
            .cp_x(cp_x),
            .cp_y(cp_y),
            .cp_z(cp_z)
            );
            
            
            
            
            generate
            genvar j;
            for (j = 0; j<CORE_NUMBER; j = j+1)
            begin
                validator_core
                #(.N(N),.DISTANCE_MODULES(DISTANCE_MODULES)) core(
                .clock(clock),
                .reset(reset_core[j]),
                .point_x(point_x[j]),
                .point_y(point_y[j]),
                .point_z(point_z[j]),
                .point_i(point_i[j]),
                .point_cloud_size(point_cloud_size),
                .cp_x(cp_x),
                .cp_y(cp_y),
                .cp_z(cp_z),
                .inlier(inlier[j]),
                .outlier(outlier[j])
                );
            end
            endgenerate
            
            endmodule
