`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/12/2021 11:47:56 AM
// Design Name: Test
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


module Bram_interface #(parameter N = 16,
                    DISTANCE_MODULES = 8,
                    CORE_NUMBER = 8)
                   (input wire clock,
                    output reg[31:0] addr_x,//Connectio to bram containing x
                    output reg[127:0] write_in_x,
                    input wire[127:0] read_out_x,
                    output reg en_x,
                    output reg  rst_x,
                    output reg[15:0] we_x,
                    output reg[31:0] addr_y,//Connectio to bram containing y
                    output reg[127:0] write_in_y,
                    input wire[127:0] read_out_y,
                    output reg en_y,
                    output reg  rst_y,
                    output reg[15:0] we_y,
                    output reg[31:0] addr_z,//Connectio to bram containing x
                    output reg[127:0] write_in_z,
                    input wire[127:0] read_out_z,
                    output reg en_z,
                    output reg  rst_z,
                    output reg[15:0] we_z,
                    output reg[6:0] state,
                    output reg [31:0] point_cloud_size,
                    output wire[N*2-1:0] point_pos,
                    output wire update_cache,
                    output wire[N-1:0] outlier_from_fifo,
                    output reg [N*CORE_NUMBER-1:0] cache_x
                    );
    


reg[N*DISTANCE_MODULES-1:0]cache_feeder_x;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_y;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_z;



//reg [N*CORE_NUMBER-1:0] cache_x;
reg [N*CORE_NUMBER-1:0] cache_y;
reg [N*CORE_NUMBER-1:0] cache_z;
reg reset;

reg read_fifo;

reg cache_updated;






wire Controller_done;

wire fifo_empty;



reg pause;

reg[N-1:0] feeder_pos;

reg cache_ready;
integer i,k;
reg[4:0] test;

always @(posedge clock)
begin
    if(state ==2)
    begin
            if(update_cache )
            begin
                pause <=1;
                addr_x <= (point_pos)*2-1;
                addr_y <=(point_pos)*2-1;
                addr_z <= (point_pos)*2-1;
                en_x <=1;
                en_y <=1;
                en_z <=1;
            end
            else
            begin
         if ((feeder_pos) > point_cloud_size )
                begin
                    feeder_pos <= 0;
                end
                else
                    feeder_pos <= feeder_pos + 15;
        addr_x <= feeder_pos;
        addr_y <= feeder_pos;
        addr_z <= feeder_pos;
        en_x <=1;
        en_y <=1;
        en_z <=1;
         cache_feeder_x <=  read_out_x;
         cache_feeder_y <=  read_out_y;
         cache_feeder_z <=  read_out_z;
          pause <= 0;
          cache_updated<=0;
          reset<=0;
    end
    end
    
    else if(state ==1)
    begin
        
        cache_x =0;
        cache_y =0;
        cache_z =0;
        test = point_pos&(CORE_NUMBER-1);
        
        for ( i=0;i<CORE_NUMBER-test; i = i +1 ) begin
            cache_x = cache_x +(read_out_x[(i+test+1)*N-1 -:N]<<(i*N));
            cache_y = cache_y +(read_out_y[(i+test+1)*N-1 -:N]<<(i*N));
            cache_z = cache_z +(read_out_z[(i+test+1)*N-1 -:N]<<(i*N));
        end
        addr_x <= point_pos*2+15;
        addr_y <= point_pos*2+15;
        addr_z <= point_pos*2+15;
        we_z <=0;
        we_y <= 0;
        we_x <= 0;
        pause <=0;
        reset<=0;
        cache_updated <=1;

    end
    else  if(state == 3)
    begin
        if(!fifo_empty)
        begin
        we_z <= 16'hffff;
        we_y <= 16'hffff;
        we_x <= 16'hffff;
        if(outlier_from_fifo != 0)
        begin
        addr_x <= outlier_from_fifo*2-1;
        addr_y <= outlier_from_fifo*2-1;
        addr_z <= outlier_from_fifo*2-1;
        end
        write_in_x <= 0;
        write_in_y <= 0;
        write_in_z <= 0;
        end
        else begin
        we_z <=0;
        we_y <= 0;
        we_x <= 0;
        end
    end
    else if (state ==0) begin
            en_y <=1;
            en_x <=1;
            en_z <=1;
            addr_y <= 0;
            addr_x <= 0;
            addr_z <= 0;
            reset <=1;
        if (read_out_y[31:0]>0) begin
            point_cloud_size <= read_out_x[31:0];
            write_in_y[31:0] <=0;
            we_y <= 16'h000f;
            addr_x <= (point_pos)*2;
            addr_y <=(point_pos)*2;
            addr_z <= (point_pos)*2;
        end
        else begin
        point_cloud_size<=0;
        feeder_pos <=0;
        end
    end
    else if(state==4)begin
            we_z <= 16'hffff;
            addr_z <= 0;
            write_in_z <= 16'h00fff; 
            addr_x <=0;
            addr_y <=0;
    end
    else if(state == 5)begin
         we_z <= 0;
         addr_z <= 0;
    end
    else if(state == 6)begin
        
     for (k =0  ;k<CORE_NUMBER; k =k +1 ) begin
        if(k<point_pos&&(CORE_NUMBER-1))
        begin
            cache_x = cache_x +(read_out_x[(k+1)*N-1 -:N]<<((k+point_pos&&(CORE_NUMBER-1))*N));
            cache_y = cache_y +(read_out_y[(k+1)*N-1 -:N]<<((k+point_pos&&(CORE_NUMBER-1))*N));
            cache_z = cache_z +(read_out_z[(k+1)*N-1 -:N]<<((k+point_pos&&(CORE_NUMBER-1))*N));
            end
        end
        addr_y <= feeder_pos;
        addr_x <= feeder_pos;
        addr_z <= feeder_pos;
        pause <=0;

    end
end



always @(posedge clock) begin
    case (state)
        0:begin
            if (read_out_y[31:0]>0) begin
                state <= 1;
            end
        end
        1:begin
        if(Controller_done==1)
        begin
                read_fifo <=1;
                state <= 3;
        end
        else
        if (point_pos&&CORE_NUMBER==0) begin
            state <= 2;
        end
        else
         state <= 6;
                
        end
        2:begin
            if(update_cache)
            begin
                state <=1;
            end else
            begin
             if (Controller_done) begin
                read_fifo <=1;
                state <= 3;                
            end
            else state<=2;
           end
        end
        3:begin
            if(fifo_empty==1)
                begin
                    state <=4;
                    read_fifo <=0;
                end
        end
        4: begin  
            state <= 5;  
        end 
        5: begin
            state <=0;
            end
        6: begin
            state <= 2;
            
        end
        default: state <=0;         
    endcase
end

 Controller#(.N(N),.CORE_NUMBER(CORE_NUMBER),.DISTANCE_MODULES(DISTANCE_MODULES)) m_controller(
        .clock(clock),
        .reset(reset),
        .cache_feeder_x(cache_feeder_x),
        .cache_feeder_y(cache_feeder_y),
        .cache_feeder_z(cache_feeder_z),
        .cache_x(cache_x),
        .cache_y(cache_y),
        .cache_z(cache_z),
        .point_cloud_size(point_cloud_size),
        .read_fifo(read_fifo),
        .cache_updated(cache_update),
        .pause(pause),
        .outlier_pos_fifo(outlier_from_fifo),
        .point_pos(point_pos),
        .empty(fifo_empty),
        .update_cache(update_cache),
        .done(Controller_done)
    );
            
            
endmodule


