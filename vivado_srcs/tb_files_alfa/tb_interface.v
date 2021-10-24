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
parameter DISTANCE_MODULES = 2;
parameter CORE_NUMBER = 4;
parameter point_cloud_size = 17096;
//parameter point_cloud_size = 122804;
parameter Clock_period = 10; 
parameter N = 16;
parameter BUS_SIZE =32;
parameter BRAM_SHIFT=2;

reg[N*DISTANCE_MODULES-1:0]cache_feeder_x;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_y;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_z;



reg [N*CORE_NUMBER-1:0] cache_x;
reg [N*CORE_NUMBER-1:0] cache_y;
reg [N*CORE_NUMBER-1:0] cache_z;
reg [N*CORE_NUMBER-1:0] cache_i;
reg reset;

reg read_fifo;

reg cache_updated;


 reg[7:0] filter_selector;   

reg [N*2-1:0] x_array [point_cloud_size-1:0];
reg [N*2-1:0] y_array [point_cloud_size-1:0];
reg [N*2-1:0] z_array [point_cloud_size-1:0];
reg [N*2-1:0] i_array [point_cloud_size-1:0];



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
 reg[31:0] addr_i;
reg[N*CORE_NUMBER-1:0] test;
reg clear_cache;
wire [N*2-1:0] point_pos;

reg [N-1:0] point_pointer;
reg [N-1:0] point_pointer_bram;


wire[N-1:0] outlier_from_fifo;

wire update_cache;

reg cache_update;

reg[N-1:0] point_updated;
reg[N-1:0] test_point;
reg[BUS_SIZE-1:0] read_out_x;
reg[BUS_SIZE-1:0] read_out_y;
reg[BUS_SIZE-1:0] read_out_z;
reg[BUS_SIZE-1:0] read_out_i;

reg in_midle_cache;
reg wait_1c;


initial
begin
    reset = 1;
    read_fifo = 0;
    clock = 1;
    cycle_counter =0;
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_x.txt",x_array);
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_y.txt",y_array);
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_z.txt",z_array);
//    $readmemh("/home/andre/DenoisingLidar/Points/teste_int_x_32.txt",x_array);
//    $readmemh("/home/andre/DenoisingLidar/Points/teste_int_y_32.txt",y_array);
//    $readmemh("/home/andre/DenoisingLidar/Points/teste_int_z_32.txt",z_array);
//     $readmemh("/home/andre/DenoisingLidar/Points/teste_int_i_32.txt",i_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_x_32.txt",x_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_z_32.txt",z_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_y_32.txt",y_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_i_32.txt",i_array);
    f_x = $fopen("output_x.txt","w");
    f_y = $fopen("output_y.txt","w");
    f_z = $fopen("output_z.txt","w");
    f_point = $fopen("point_pos.txt","w");
end



always @(posedge clock) begin
        point_updated = point_pos +1;
        //test_point = (point_updated - (point_updated&((BUS_SIZE/N)-1)))/(BUS_SIZE/N);
    if (point_updated[0]==1) begin
        point_pointer = ((point_updated-1)/2) ;
        point_pointer_bram = (((point_updated-1)/2)<<BRAM_SHIFT)+(2<<BRAM_SHIFT) ;

    end
    else
    begin
        point_pointer = ((point_updated)/2);
        point_pointer_bram = (((point_updated)/2)<<BRAM_SHIFT)+(2<<BRAM_SHIFT);

    end
end

always @(posedge clock) begin
    read_out_x <= x_array[addr_x];
    read_out_y <= y_array[addr_y];
    read_out_z <= z_array[addr_z];
    read_out_i <= i_array[addr_i];
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
            if(update_cache && cache_updated==0)
            begin
                pause =1;
                addr_x <= point_pointer;
                addr_y <= point_pointer;
                addr_z <= point_pointer;
                addr_i <= point_pointer;

                core_cache_status <=1;
  

            end
            else
            begin
                addr_x <= feeder_pos;
                addr_y <= feeder_pos;
                addr_z <= feeder_pos;
                addr_i <= feeder_pos;
        if(node_cache_status>=DISTANCE_MODULES/(BUS_SIZE/N))
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
        if(clear_cache ==1)
        begin
            cache_feeder_x<=0;
            cache_feeder_y<=0;
            cache_feeder_z<=0;
            clear_cache<=0;  
            pause <=1;
        end
        else begin 
  
        //test <= (((x_array[addr_x+1]<<16+x_array[addr_x])<<(16*(node_cache_status))));
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
//        cache_x <= read_out_x;
//        cache_y <= read_out_y;
//        cache_z <= read_out_z;
        
        if(wait_1c==1)
        begin
        addr_x <= point_pointer;
        addr_y <= point_pointer;
        addr_z <= point_pointer;
        addr_i <= point_pointer;
        wait_1c <=0;
        end
        else
        begin
        addr_y <= point_pointer+(1);
        addr_x <= point_pointer+(1);
        addr_z <= point_pointer+(1);
        addr_i <= point_pointer+(1);
        end
        
       
    end
    else if(state==7)
    begin
     test =(BUS_SIZE/N)-(point_updated&((BUS_SIZE/N)-1));
        cache_x=0;
        cache_y=0;
        cache_z=0;
        cache_i=0;

         for ( i=0;i<(BUS_SIZE/N); i = i +1 ) begin
        if(i<(BUS_SIZE/N)-(point_updated&((BUS_SIZE/N)-1)))
        begin
            cache_x = cache_x +(read_out_x[(i+(point_updated&((BUS_SIZE/N)-1))+1)*N-1 -:N]<<(i*N));
            cache_y = cache_y +(read_out_y[(i+(point_updated&((BUS_SIZE/N)-1))+1)*N-1 -:N]<<(i*N));
            cache_z = cache_z +(read_out_z[(i+(point_updated&((BUS_SIZE/N)-1))+1)*N-1 -:N]<<(i*N));
            cache_i = cache_i +(read_out_i[(i+(point_updated&((BUS_SIZE/N)-1))+1)*N-1 -:N]<<(i*N));

        end
        end
        if(point_updated[0]==1)
        begin
            in_midle_cache <=1;
            core_cache_status <= 0; 
//            addr_y <= point_pointer+2;
//            addr_x <= point_pointer+2;
//            addr_z <= point_pointer+2;

        end
        else
        begin
         in_midle_cache <=0;  
         core_cache_status <= 1; 
//         addr_y <= point_pointer+2;
//         addr_x <= point_pointer+2;
//         addr_z <= point_pointer+2;
         end  
          addr_y <= point_pointer+2;
         addr_x <= point_pointer+2;
         addr_z <= point_pointer+2;
         addr_i <= point_pointer+2;

        
    end
    else  if(state == 3)
    begin
        if(!fifo_empty)
        begin
        if(outlier_from_fifo != 0)
        begin
        $fwrite(f_point,"%d\n",outlier_from_fifo);
        if(outlier_from_fifo[0]==0)
            begin
            x_array[outlier_from_fifo/2]=0;
            y_array[outlier_from_fifo/2]=0;
            z_array[outlier_from_fifo/2]=0;
            end
          else
            begin
            x_array[(outlier_from_fifo-1)/2]=0;
            y_array[(outlier_from_fifo-1)/2]=0;
            z_array[(outlier_from_fifo-1)/2]=0;
            
            end
        end
        end
    end
    else if (state ==0) begin  
            addr_x <= point_pointer;
            addr_y <=point_pointer;
            addr_z <= point_pointer;
            feeder_pos <=0;
            pause <=1;
        feeder_pos <=0;
        node_cache_status <=0;
        core_cache_status <=0;
        filter_selector <=2;
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
        if(core_cache_status<=CORE_NUMBER/(BUS_SIZE/N))
        begin
//           if(in_midle_cache==1)
//           begin
//                in_midle_cache <=0;                      
//              for (k =0  ;k<(BUS_SIZE/N); k =k +1 ) begin
//                 if(k<(point_updated&((BUS_SIZE/N)-1)))
//                 begin
//                     cache_x = cache_x +(read_out_x[(k+1)*N-1 -:N]<<((k+(point_updated&((BUS_SIZE/N)-1)))*N));
//                     cache_y = cache_y +(read_out_y[(k+1)*N-1 -:N]<<((k+(point_updated&((BUS_SIZE/N)-1)))*N));
//                     cache_z = cache_z +(read_out_z[(k+1)*N-1 -:N]<<((k+(point_updated&((BUS_SIZE/N)-1)))*N));
//                     end
//                 end
//           end
//           else
//           begin  
            node_cache_status <=0;
            
        if(in_midle_cache==1)
           begin
           in_midle_cache<=0;
           end
             for (k =0  ;k<(BUS_SIZE/N); k =k +1 ) begin
                 if(((point_updated&((BUS_SIZE/N)-1))+k+(core_cache_status*(BUS_SIZE/N)))<(CORE_NUMBER))
                 begin
                     cache_x = cache_x +(read_out_x[(k+1)*N-1 -:N]<<((((k+(point_updated&((BUS_SIZE/N)-1)))*N))+(BUS_SIZE*(core_cache_status))));
                     cache_y = cache_y +(read_out_y[(k+1)*N-1 -:N]<<((((k+(point_updated&((BUS_SIZE/N)-1)))*N))+(BUS_SIZE*(core_cache_status))));
                     cache_z = cache_z +(read_out_z[(k+1)*N-1 -:N]<<((((k+(point_updated&((BUS_SIZE/N)-1)))*N))+(BUS_SIZE*(core_cache_status))));
                     cache_i = cache_i +(read_out_i[(k+1)*N-1 -:N]<<((((k+(point_updated&((BUS_SIZE/N)-1)))*N))+(BUS_SIZE*(core_cache_status))));
                     end
                 end
            
            //test <= ((((x_array[addr_x+1]<<16)+x_array[addr_x])<<(16*(core_cache_status))));
//            cache_x <= cache_x + ((read_out_x<<(BUS_SIZE*(core_cache_status))));
//            cache_y <= cache_y + ((read_out_y<<(BUS_SIZE*(core_cache_status))));
//            cache_z <= cache_z + ((read_out_z<<(BUS_SIZE*(core_cache_status))));
            core_cache_status <= core_cache_status+1;

//            end
            addr_y <= (point_pointer+(core_cache_status+2));
            addr_x <= (point_pointer+(core_cache_status+2));
            addr_z <= (point_pointer+(core_cache_status+2));
            addr_i <= (point_pointer+(core_cache_status+2));

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
             addr_x <= feeder_pos;
             addr_y <= feeder_pos;
             addr_z <= feeder_pos;
              addr_i <= feeder_pos;

             clear_cache <=1;

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
         state <= 7; 
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
            if(core_cache_status>CORE_NUMBER/(BUS_SIZE/N))
            begin
                state <= 2;
                reset <= 0;
            end
        end
        7: begin
            state<=6;
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
        .cache_i(cache_i),
        .point_cloud_size(point_cloud_size),
        .read_fifo(read_fifo),
        .filter_selector(filter_selector),
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
