`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 11:34:12 AM
// Design Name: 
// Module Name: tb_controller
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


module tb_interface;

reg clock;
parameter DISTANCE_MODULES = 4;
parameter CORE_NUMBER = 4;
parameter point_cloud_size = 17096;
//parameter point_cloud_size = 122804;
parameter Clock_period = 10; 
parameter N = 16;

reg[N*DISTANCE_MODULES-1:0]cache_feeder_x;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_y;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_z;



reg [N*CORE_NUMBER-1:0] cache_x;
reg [N*CORE_NUMBER-1:0] cache_y;
reg [N*CORE_NUMBER-1:0] cache_z;
reg reset;

reg read_fifo;

reg cache_updated;



reg [N-1:0] x_array [point_cloud_size-1:0];
reg [N-1:0] y_array [point_cloud_size-1:0];
reg [N-1:0] z_array [point_cloud_size-1:0];




wire Controller_done;

wire fifo_empty;



reg pause;

reg[N-1:0] feeder_pos;

reg cache_ready;
integer i,j;

reg [N-1:0] core_cache_status;
reg [N-1:0] node_cache_status;


integer i,j,l,k,cycle_counter;
integer f_x,f_y,f_z,f_point;

 reg[6:0] state;
reg[31:0] addr_x;
 reg[31:0] addr_y;
 reg[31:0] addr_z;
reg[N*CORE_NUMBER-1:0] test;
reg clear_cache;
wire [N*2-1:0] point_pos;

wire[N-1:0] outlier_from_fifo;

wire update_cache;

reg cache_update;

initial
begin
    reset = 1;
    read_fifo = 0;
    clock = 1;
    cycle_counter =0;
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_x.txt",x_array);
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_y.txt",y_array);
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_z.txt",z_array);
    //$readmemh("/home/andre/DenoisingLidar/Points/teste_int_x.txt",x_array);
    //$readmemh("/home/andre/DenoisingLidar/Points/teste_int_y.txt",y_array);
    //$readmemh("/home/andre/DenoisingLidar/Points/teste_int_z.txt",z_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_x.txt",x_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_z.txt",z_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_y.txt",y_array);
    f_x = $fopen("output_x.txt","w");
    f_y = $fopen("output_y.txt","w");
    f_z = $fopen("output_z.txt","w");
    f_point = $fopen("point_pos.txt","w");
end





 
always @(posedge clock)
begin
    if(state ==2)
    begin
            if(update_cache && cache_updated==0)
            begin
                pause <=1;
                addr_x <= (point_pos+1);
                addr_y <= (point_pos+1);
                addr_z <= (point_pos+1);
                core_cache_status <=2;
  

            end
            else
            begin

        if(node_cache_status>=DISTANCE_MODULES)
        begin
            node_cache_status <=0;
            pause <=0;
            clear_cache <=1;
//            cache_feeder_x<=0;
//            cache_feeder_y<=0;
//            cache_feeder_z<=0;
        end
        else
        begin
            if ((feeder_pos) > point_cloud_size && Controller_done ==0)
            begin
                    feeder_pos <= 0;
            end
            else
                feeder_pos <= feeder_pos + 2;
                
                
        if(clear_cache ==1)
        begin
            cache_feeder_x<=0;
            cache_feeder_y<=0;
            cache_feeder_z<=0;
            clear_cache<=0;  
            pause <=1;
        end
        else begin        
        addr_x <= feeder_pos;
        addr_y <= feeder_pos;
        addr_z <= feeder_pos;
        //test <= (((x_array[addr_x+1]<<16+x_array[addr_x])<<(16*(node_cache_status))));
        test <= (x_array[feeder_pos+1]<<16)+x_array[feeder_pos];

         cache_feeder_x <= cache_feeder_x + (((x_array[addr_x+1]<<16)+x_array[addr_x])<<(16*(node_cache_status)));
         cache_feeder_y <=  cache_feeder_y + (((y_array[addr_y+1]<<16)+x_array[addr_y])<<(16*(node_cache_status)));
         cache_feeder_z <=  cache_feeder_z + (((z_array[addr_z+1]<<16)+x_array[addr_z])<<(16*(node_cache_status)));
          pause <= 1;
          node_cache_status <= node_cache_status +2;
          cache_updated<=0;  
        end
        end


    end
    end
    
    else if(state ==1)
    begin
        cache_x <= ((x_array[addr_x+1]<<16)+x_array[addr_x]);
        cache_y <= ((y_array[addr_y+1]<<16)+y_array[addr_y]);
        cache_z <= ((z_array[addr_z+1]<<16)+z_array[addr_z]);
        core_cache_status <= 2;
        addr_y <= point_pos+2+1;
        addr_x <= point_pos+2+1;
        addr_z <= point_pos+2+1;

    end
    else  if(state == 3)
    begin
        if(!fifo_empty)
        begin
        if(outlier_from_fifo != 0)
        begin
            x_array[outlier_from_fifo]=0;
            y_array[outlier_from_fifo]=0;
            z_array[outlier_from_fifo]=0;
            $fwrite(f_point,"%d\n",outlier_from_fifo);
        end
        end
    end
    else if (state ==0) begin  
            addr_x <= (point_pos+1);
            addr_y <=(point_pos+1);
            addr_z <= (point_pos+1);
            feeder_pos <=0;
            pause <=1;
        feeder_pos <=0;
        node_cache_status <=0;
        core_cache_status <=0;
    end
    else if(state==4)begin
            addr_z <= 0;
            addr_x <=0;
            addr_y <=0;
    end
    else if(state == 5)begin
         addr_z <= 0;
    end
    else if(state == 6)begin
        if(core_cache_status<=CORE_NUMBER)
        begin

            node_cache_status <=2;
            //test <= ((((x_array[addr_x+1]<<16)+x_array[addr_x])<<(16*(core_cache_status))));
            cache_x <= cache_x + ((((x_array[addr_x+1]<<16)+x_array[addr_x])<<(16*(core_cache_status))));
            cache_y <= cache_y + ((((y_array[addr_y+1]<<16)+y_array[addr_y])<<(16*(core_cache_status))));
            cache_z <= cache_z + ((((z_array[addr_z+1]<<16)+z_array[addr_z])<<(16*(core_cache_status))));
            core_cache_status = core_cache_status+2;
            addr_y <= (point_pos+core_cache_status);
            addr_x <= (point_pos+core_cache_status);
            addr_z <= (point_pos+core_cache_status);
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
        end
    end
end

always @(posedge clock) begin
    
end

always @(posedge clock) begin
    case (state)
        0:begin
                state <= 1;
        end
        1:begin
        if(Controller_done==1)
        begin
                read_fifo <=1;
                state <= 3;
        end
        else
//        if (point_pos%CORE_NUMBER==0) begin
//            state <= 2;
//        end
//        else
         state <= 6;
                
        end
        2:begin
            if(update_cache && cache_updated ==0)
            begin
                state <=1;
            end else
             if (Controller_done) begin
                read_fifo <=1;
                state <= 3;                
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
            if(core_cache_status>CORE_NUMBER)
            begin
                state <= 2;
                reset <= 0;
            end
        end
        default: state <=0;         
    endcase
end    
                
                
  always @(posedge clock) begin
  if(!Controller_done) begin
        cycle_counter = cycle_counter+1;
  end
end               


 always @(posedge clock) begin
     if(Controller_done) begin
         if (!fifo_empty) begin
            read_fifo <=1;
         end
         else 
         begin
             read_fifo <= 0;
             for (i =0 ;i<point_cloud_size ; i = i+1 ) begin
                 if (x_array[i] !=0) begin
                 $fwrite(f_x,"%h\n",x_array[i]);
                 $fwrite(f_y,"%h\n",y_array[i]);
                 $fwrite(f_z,"%h\n",z_array[i]);
                 end
             end
                #Clock_period;
                $fclose(f_x); 
                $fclose(f_y); 
                $fclose(f_z); 
                $fclose(f_point); 
    
            $stop;
         end
     end
     else  begin
        read_fifo =0;
     end

     
 end

 Controller#(.CORE_NUMBER(CORE_NUMBER),.DISTANCE_MODULES(DISTANCE_MODULES)) m_controller(
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


always #(Clock_period/2) clock <= ~clock;

endmodule
