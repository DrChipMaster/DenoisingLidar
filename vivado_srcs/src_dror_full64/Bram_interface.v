

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
                    DISTANCE_MODULES = 4,
                    CORE_NUMBER = 4,
                    BUS_SIZE =64,
                    BRAM_SHIFT=2
                    )
                   (input wire clock,
                    output reg[31:0] addr_x,//Connectio to bram containing x
                    output reg[BUS_SIZE-1:0] write_in_x,
                    input wire[BUS_SIZE-1:0] read_out_x,
                    output reg en_x,
                    output reg  rst_x,
                    output reg[7:0] we_x,
                    output reg[31:0] addr_y,//Connectio to bram containing y
                    output reg[BUS_SIZE-1:0] write_in_y,
                    input wire[BUS_SIZE-1:0] read_out_y,
                    output reg en_y,
                    output reg  rst_y,
                    output reg[7:0] we_y,
                    output reg[31:0] addr_z,//Connectio to bram containing x
                    output reg[BUS_SIZE-1:0] write_in_z,
                    input wire[BUS_SIZE-1:0] read_out_z,
                    output reg en_z,
                    output reg  rst_z,
                    output reg[7:0] we_z                    
                    );
    


reg[N*DISTANCE_MODULES-1:0]cache_feeder_x;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_y;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_z;

reg[N-1:0] feeder_pos;

//reg [N*CORE_NUMBER-1:0] cache_x;
reg [N*CORE_NUMBER-1:0] cache_y;
reg [N*CORE_NUMBER-1:0] cache_z;
reg reset;

 reg[N-1:0] point_updated;
 
reg read_fifo;
wire update_cache;
reg cache_updated;
 reg[6:0] state;
wire[N*2-1:0] point_pos;
wire[N-1:0] outlier_from_fifo;
reg[N*CORE_NUMBER-1:0] cache_x;
reg [N-1:0] point_pointer;

reg [N-1:0] core_cache_status;
reg [N-1:0] node_cache_status;

reg [31:0] point_cloud_size;


wire Controller_done;

wire fifo_empty;



reg pause;



reg clear_cache;



reg cache_ready;
reg in_midle_cache;
integer i,k;

reg[N-1:0] aux;
reg [N-1:0] point_pointer_p;

reg wait_1c;

always @(posedge clock) begin
        point_updated = point_pos +1;
        //point_pointer_p = (point_updated - (point_updated&((BUS_SIZE/N-1))))/(BUS_SIZE/N);
        point_pointer = (((point_updated - (point_updated&((BUS_SIZE/N-1))))/(BUS_SIZE/N))<<BRAM_SHIFT)+(2<<BRAM_SHIFT) ;

//    if (point_updated[0]==1) begin
//    end
//    else
//    begin
//        point_pointer = (((point_updated)/(BUS_SIZE/N))<<BRAM_SHIFT)+(2<<BRAM_SHIFT);
//    end
end






always @(posedge clock)
begin

if(state ==2)
begin

  if ((feeder_pos) > (point_cloud_size/(BUS_SIZE/N)) && Controller_done ==0)
        begin
                feeder_pos = 0;
        end
        else
            if(clear_cache==0 & node_cache_status<DISTANCE_MODULES/(BUS_SIZE/N))
                feeder_pos = feeder_pos + 1;   
                
  end              
end



always @(posedge clock)
begin
    if(state ==2)
    begin
            if(update_cache )
            begin
                pause <=1;
                wait_1c<=1;
                
                //addr_x <= ((point_pos+1)<<BRAM_SHIFT);
                //addr_y <= ((point_pos+1)<<BRAM_SHIFT);
                //addr_z <= ((point_pos+1)<<BRAM_SHIFT);
                addr_x <= point_pointer;
                addr_y <= point_pointer;
                addr_z <= point_pointer;
                en_x <=1;
                en_y <=1;
                en_z <=1;
                core_cache_status <=1;
            end
            else
            begin
                addr_x <= feeder_pos<<BRAM_SHIFT;
                addr_y <= feeder_pos<<BRAM_SHIFT;
                addr_z <= feeder_pos<<BRAM_SHIFT;
        if(node_cache_status>=DISTANCE_MODULES/(BUS_SIZE/N))
            begin
                node_cache_status <=0;
                pause <=0;
                clear_cache <=1;
            end
        else
        begin                    //;
        if(clear_cache ==1)
        begin
            cache_feeder_x<=0;
            cache_feeder_y<=0;
            cache_feeder_z<=0;
            clear_cache<=0;  
            pause <=1;
        end
        else begin
           
            en_x <=1;
            en_y <=1;
            en_z <=1;
             cache_feeder_x <= cache_feeder_x +  (read_out_x<<(BUS_SIZE*(node_cache_status)));
            cache_feeder_y <=  cache_feeder_y + (read_out_y<<(BUS_SIZE*(node_cache_status)));
            cache_feeder_z <=  cache_feeder_z + (read_out_z<<(BUS_SIZE*(node_cache_status)));
             pause <= 1;
            node_cache_status <= node_cache_status +1;
            cache_updated<=0;  
    end
    end
    end
    end
    else if(state ==1)
    begin  
        //cache_x =0;
        //cache_y =0;
        //cache_z =0;
//        test = point_pos&((BUS_SIZE/N)-1);        
//        for ( i=0;i<(BUS_SIZE/N); i = i +1 ) begin
//        if(i<test)
//        begin
//            cache_x = cache_x +(read_out_x[(i+test+1)*N-1 -:N]<<(i*N));
//            cache_y = cache_y +(read_out_y[(i+test+1)*N-1 -:N]<<(i*N));
//            cache_z = cache_z +(read_out_z[(i+test+1)*N-1 -:N]<<(i*N));
//        end
//        end
//        if(point_pos[0]==1)
//        begin
//            in_midle_cache <=1;
//        end
//        else in_midle_cache <=0;
/*         addr_x <= (point_pos+BUS_SIZE/N +1)<<BRAM_SHIFT;
        addr_y <= (point_pos+BUS_SIZE/N +1)<<BRAM_SHIFT;
        addr_z <= (point_pos+BUS_SIZE/N +1)<<BRAM_SHIFT; */
        if(wait_1c==1)
        begin
        addr_x <= point_pointer;
        addr_y <= point_pointer;
        addr_z <= point_pointer;
        wait_1c <=0;
        end
        else
        begin
        addr_y <= point_pointer+(1<<BRAM_SHIFT);
        addr_x <= point_pointer+(1<<BRAM_SHIFT);
        addr_z <= point_pointer+(1<<BRAM_SHIFT);
        end
        
        //cache_updated <=1;

    end
    else if(state==7)
    begin
    cache_x=0;
        cache_y=0;
        cache_z=0;
         for ( i=0;i<(BUS_SIZE/N); i = i +1 ) begin
        if(i<(BUS_SIZE/N)-(point_updated&((BUS_SIZE/N)-1)))
        begin
            cache_x = cache_x +(read_out_x[(i+(point_updated&((BUS_SIZE/N)-1))+1)*N-1 -:N]<<(i*N));
            cache_y = cache_y +(read_out_y[(i+(point_updated&((BUS_SIZE/N)-1))+1)*N-1 -:N]<<(i*N));
            cache_z = cache_z +(read_out_z[(i+(point_updated&((BUS_SIZE/N)-1))+1)*N-1 -:N]<<(i*N));
        end
        end
        if(point_updated[0]==1)
        begin
            in_midle_cache <=1;
            core_cache_status <= 0; 

        end
        else
        begin
         in_midle_cache <=0;  
         core_cache_status <= 1; 
         end  
        we_z <=0;
        we_y <= 0;
        we_x <= 0;
        //pause <=0;
        reset<=0;
        addr_y <= point_pointer+(2<<BRAM_SHIFT);
        addr_x <= point_pointer+(2<<BRAM_SHIFT);
        addr_z <= point_pointer+(2<<BRAM_SHIFT);
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
            if(outlier_from_fifo[0]==0)
            begin
                    addr_x <= ((outlier_from_fifo/(BUS_SIZE/N))<<BRAM_SHIFT)+(2<<BRAM_SHIFT);
                    addr_y <= ((outlier_from_fifo/(BUS_SIZE/N))<<BRAM_SHIFT)+(2<<BRAM_SHIFT);
                    addr_z <= ((outlier_from_fifo/(BUS_SIZE/N))<<BRAM_SHIFT)+(2<<BRAM_SHIFT);
            end
            else
            begin
                addr_x <= ((((outlier_from_fifo-1)/(BUS_SIZE/N)))<<BRAM_SHIFT)+(2<<BRAM_SHIFT);
                addr_y <= ((((outlier_from_fifo-1)/(BUS_SIZE/N)))<<BRAM_SHIFT)+(2<<BRAM_SHIFT);
                addr_z <= ((((outlier_from_fifo-1)/(BUS_SIZE/N)))<<BRAM_SHIFT)+(2<<BRAM_SHIFT);
            end
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
            wait_1c<=1;
        if (read_out_y[31:0]>0) begin
            point_cloud_size <= read_out_x[31:0];
            write_in_y[31:0] <=0;
            we_y <= 16'h000f;
//            addr_x <= point_pointer;
//            addr_y <= point_pointer;
//            addr_z <= point_pointer;
            addr_x <= 0;
            addr_y <= 0;
            addr_z <= 0;
        end
        else begin
        point_cloud_size<=0;
        clear_cache <=1;
        node_cache_status <=0;
        core_cache_status <=0;
        pause <=1;
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

    //if(core_cache_status<=CORE_NUMBER/(BUS_SIZE/N))
        if(core_cache_status<=CORE_NUMBER/(BUS_SIZE/N))
        begin
//           if(in_midle_cache==1)
//           begin
//                in_midle_cache <=0;                      
//              for (k =0  ;k<(BUS_SIZE/N); k =k +1 ) begin
//                 if(k<point_pos&((BUS_SIZE/N)-1))
//                 begin
//                     cache_x = cache_x +(read_out_x[(k+1)*N-1 -:N]<<((k+point_pos&((BUS_SIZE/N)-1))*N));
//                     cache_y = cache_y +(read_out_y[(k+1)*N-1 -:N]<<((k+point_pos&((BUS_SIZE/N)-1))*N));
//                     cache_z = cache_z +(read_out_z[(k+1)*N-1 -:N]<<((k+point_pos&((BUS_SIZE/N)-1))*N));
//                     end
//                 end
//           end
//           else
//           begin      
            node_cache_status <=0;
            //test <= ((((x_array[addr_x+1]<<16)+x_array[addr_x])<<(16*(core_cache_status))));
            if(in_midle_cache==1)
           begin
           in_midle_cache=0;
           end
             for (k =0  ;k<(BUS_SIZE/N); k =k +1 ) begin
                 if(((point_updated&((BUS_SIZE/N)-1))+k+(core_cache_status*(BUS_SIZE/N)))<(CORE_NUMBER))
                 begin
                     cache_x = cache_x +(read_out_x[(k+1)*N-1 -:N]<<((((k+(point_updated&((BUS_SIZE/N)-1)))*N))+(BUS_SIZE*(core_cache_status))));
                     cache_y = cache_y +(read_out_y[(k+1)*N-1 -:N]<<((((k+(point_updated&((BUS_SIZE/N)-1)))*N))+(BUS_SIZE*(core_cache_status))));
                     cache_z = cache_z +(read_out_z[(k+1)*N-1 -:N]<<((((k+(point_updated&((BUS_SIZE/N)-1)))*N))+(BUS_SIZE*(core_cache_status))));
                     end
                 end
            //end
            core_cache_status = core_cache_status+1;
            addr_y <= (point_pointer+((core_cache_status+2)<<BRAM_SHIFT));
            addr_x <= (point_pointer+((core_cache_status+2)<<BRAM_SHIFT));
            addr_z <= (point_pointer+((core_cache_status+2)<<BRAM_SHIFT));
            pause <=1;
            cache_updated <=1;
            
        end
        else
        begin
            pause <=1;
            cache_feeder_x<=0;
            cache_feeder_y<=0;
            cache_feeder_z<=0;
            cache_updated <=0;
            addr_x <= feeder_pos<<BRAM_SHIFT;
              addr_y <= feeder_pos<<BRAM_SHIFT;
             addr_z <= feeder_pos<<BRAM_SHIFT;
             clear_cache <=1;

        end

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
        // if (point_pos&&CORE_NUMBER==0) begin
        //     state <= 2;
        // end
        // else
        if(wait_1c==0)
         state <= 7;
        end
        2:begin
            if(update_cache && cache_updated ==0)
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
            //if(core_cache_status>CORE_NUMBER/(BUS_SIZE/N))
            if(core_cache_status>CORE_NUMBER/(BUS_SIZE/N))

            begin
                state <= 2;
                //reset <= 0;
            end
            
            
        end
         7: begin
            state<=6;
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


