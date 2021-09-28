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


module tb_controller_b;

reg clock;
parameter N = 16;
parameter M = 32;
parameter point_cloud_size = 17500;
parameter Clock_period = 10; 
parameter core_number = 2;
reg reset;

reg [N-1:0] x_array [point_cloud_size-1:0];
reg [N-1:0] y_array [point_cloud_size-1:0];
reg [N-1:0] z_array [point_cloud_size-1:0];


reg[N*M-1:0]cache_feeder_x;
reg[N*M-1:0]cache_feeder_y;
reg[N*M-1:0]cache_feeder_z;




reg [N*core_number-1:0] cache_x;
reg [N*core_number-1:0] cache_y;
reg [N*core_number-1:0] cache_z;



reg read_fifo;

wire[N-1:0] outlier_from_fifo ;

wire[N-1:0] point_pos;

wire Controller_done;

wire fifo_empty;






integer i,j,l,cycle_counter;
integer f_x,f_y,f_z;



reg[N-1:0] feeder_pos;

initial
begin
    reset = 1;
    read_fifo = 0;
    clock = 1;
    cycle_counter =0;
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_x.txt",x_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_y.txt",y_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_z.txt",z_array);
    f_x = $fopen("output_x.txt","w");
    f_y = $fopen("output_y.txt","w");
    f_z = $fopen("output_z.txt","w");

    cache_x =  x_array[0];
    cache_y =  y_array[0];
    cache_z =  z_array[0];

    for (i = 1; i< core_number; i = i+1)
    begin
        cache_x =  (cache_x<<N)+x_array[i];
        cache_y =  (cache_y<<N)+y_array[i];
        cache_z =  (cache_z<<N)+z_array[i];
    end

    cache_feeder_x= x_array[0];
    cache_feeder_y= y_array[0];
    cache_feeder_z= z_array[0];    

    for (j = 1; j< M; j = j+1)
    begin
    cache_feeder_x= (cache_feeder_x<<N)+ x_array[j];
    cache_feeder_y= (cache_feeder_y<<N)+ y_array[j];
    cache_feeder_z= (cache_feeder_z<<N)+ z_array[j];
    end
    feeder_pos = 0;
    #Clock_period;
   
    reset = 0; 
end




always @(posedge clock) begin
    if (reset ==0 && Controller_done ==0) begin
        cache_x =  x_array[point_pos];
        cache_y =  y_array[point_pos];
        cache_z =  z_array[point_pos];
    for (i = 1 ;i < core_number ; i = i +1 ) begin
        cache_x = (cache_x<<N)+ x_array[point_pos+i];
        cache_y = (cache_y<<N)+ y_array[point_pos+i];
        cache_z = (cache_z<<N)+ z_array[point_pos+i];
    end
    end            
end



always @(posedge clock) begin
    if (feeder_pos > point_cloud_size-M*2 && Controller_done ==0)
    begin
        feeder_pos = 0;
    end
    else
        feeder_pos = feeder_pos +  M;

    cache_feeder_x= x_array[feeder_pos];
    cache_feeder_y= y_array[feeder_pos];
    cache_feeder_z= z_array[feeder_pos];
    for (l = feeder_pos+1; l<feeder_pos +M;l=l+1)
    begin
    cache_feeder_x =(cache_feeder_x<<N)+x_array[l];
    cache_feeder_y =(cache_feeder_y<<N)+y_array[l];
    cache_feeder_z =(cache_feeder_z<<N)+z_array[l];   
    
    end
end
                    
                    
                    
 always @(posedge clock) begin
     if(Controller_done) begin
         if (!fifo_empty) begin
            read_fifo =1;
         end
         else 
         begin
             read_fifo = 0;
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
            $stop;
         end
     end
     else  begin
        read_fifo =0;
     end

     
 end

 always @(outlier_from_fifo) begin
     if (Controller_done && !fifo_empty) begin
        x_array[outlier_from_fifo]=0;
        x_array[outlier_from_fifo]=0;
        x_array[outlier_from_fifo]=0;
     end

 end                   
                
                
  always @(posedge clock) begin
  if(!Controller_done) begin
        cycle_counter = cycle_counter+1;
  end
end               



 Controller#(.CORE_NUMBER(core_number)) m_controller(
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
        .outlier_pos_fifo(outlier_from_fifo),
        .point_pos(point_pos),
        .empty(fifo_empty),
        .done(Controller_done)
    );


always #(Clock_period/2) clock <= ~clock;

endmodule
