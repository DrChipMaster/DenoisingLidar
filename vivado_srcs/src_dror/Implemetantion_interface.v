`timescale 1ns / 1ps



module Implementation_interface #(
    parameter N = 16,
    DISTANCE_MODULES = 32,
    CORE_NUMBER = 2,
    point_cloud_size = 1000
) (
    input wire clock,
    output wire done,
    output wire fifo_empty
);
reg[N*DISTANCE_MODULES-1:0]cache_feeder_x;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_y;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_z;




reg [N*CORE_NUMBER-1:0] cache_x;
reg [N*CORE_NUMBER-1:0] cache_y;
reg [N*CORE_NUMBER-1:0] cache_z;



reg read_fifo;
reg reset;


wire[N-1:0] outlier_from_fifo ;

wire[N-1:0] point_pos;

wire Controller_done;


reg[N-1:0] feeder_pos;

reg[N-1:0] cycle_counter;



integer i,l;
initial
begin
        reset <= 1;
        read_fifo <= 0;
        cycle_counter <=0;
        feeder_pos <= 0;
end



always @(posedge clock) begin
    if(cycle_counter !=0 && reset ==1)
    reset <= 0;
    if (feeder_pos > point_cloud_size-DISTANCE_MODULES*2 && Controller_done ==0)
    begin
        feeder_pos = 0;
    end
    else
        feeder_pos = feeder_pos +  DISTANCE_MODULES;

    cache_feeder_x= cycle_counter;
    cache_feeder_y= cycle_counter;
    cache_feeder_z= cycle_counter;
    for (l = 1; l<DISTANCE_MODULES;l=l+1)
    begin
    cache_feeder_x =(cache_feeder_x<<N)+cycle_counter;
    cache_feeder_y =(cache_feeder_y<<N)+cycle_counter;
    cache_feeder_z =(cache_feeder_z<<N)+cycle_counter;   
    
    end
end


always @(posedge clock) begin
    if (reset ==0 && Controller_done ==0) begin
        cache_x =  cycle_counter;
        cache_y =  cycle_counter;
        cache_z =  cycle_counter;
    for (i = 1 ;i < CORE_NUMBER ; i = i +1 ) begin
        cache_x = (cache_x<<N)+ cycle_counter;
        cache_y = (cache_y<<N)+ cycle_counter;
        cache_z = (cache_z<<N)+ cycle_counter;
    end
    end            
end




  always @(posedge clock) begin
  if(!Controller_done) begin
        cycle_counter = cycle_counter+1;
  end
  end


 Controller#(.CORE_NUMBER(CORE_NUMBER)) m0_controller(
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






endmodule