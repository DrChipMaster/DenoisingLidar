module tb;

reg Clock;
parameter N = 32;
parameter M = 17500;
parameter Clock_period = 10; 
integer error,actual_result;
reg [N-1:0] point_x1;
reg [N-1:0] point_y1;
reg [N-1:0] point_z1;

reg [N-1:0] point_x2;
reg [N-1:0] point_y2;
reg [N-1:0] point_z2;
reg point3d;
wire [N/2-1:0] distance;
wire done;
integer i;



reg[N-1:0] vector_x;
reg[N-1:0] vector_y;
reg[N-1:0] vector_z;

reg [N-1:0] x_array [M-1:0];
reg [N-1:0] y_array [M-1:0];
reg [N-1:0] z_array [M-1:0];

initial
begin

    Clock = 1;
    error = 0;
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_x.txt",x_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_y.txt",y_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_z.txt",z_array);
    point_x1 = x_array[0];
    point_y1 = y_array[0];
    point_z1 = z_array[0];
    #Clock_period;
    for (i = 1; i<=M-1;i = i+1)
    begin
        apply_input(i);
    end
    #Clock_period;
    $stop;
end

task apply_input;
    input [N:0] i;
begin
point3d = 1;

//point_x1 = 43.54*100;
//point_y1 = 8.18*100;
//point_z1 = 1.707*100;

//point_x2 = 65.74*100;
//point_y2 = 8.44*100;
//point_z2 = 2.45*100;

//point_x1 = 43;
//point_y1 = 8;
//point_z1 = 1;

point_x2 = x_array[i]; 
point_y2 = y_array[i];
point_z2 = z_array[i];


vector_x = point_x1-point_x2;
 if (vector_x[N-1] == 1'b1) begin
    vector_x = -vector_x;
  end


vector_y = point_y1 - point_y2;
 if (vector_y[N-1] == 1'b1) begin
    vector_y = -vector_y;
  end



vector_z =point_z1- point_z2 ;    
 if (vector_z[N-1] == 1'b1) begin
    vector_z = -vector_z;
  end

actual_result <= ($floor($sqrt($pow((vector_x),2)+$pow(vector_y,2)+$pow(vector_z,2)))); //Calculate the actual result.
if(actual_result != distance) 
error = error + 1; 
#Clock_period;
wait(~Clock);  
//wait(done);
//#Clock_period;
//wait(~Clock);  




end
endtask
always #(Clock_period/2) Clock <= ~Clock;

distance_calculator
 #(.N(N)) calculate_distance(
 .point_x1(point_x1),
 .point_y1(point_y1),
 .point_z1(point_z1),
 
 .point_x2(point_x2),
 .point_y2(point_y2),
 .point_z2(point_z2),
 .point_3d(point3d),
 .distance(distance)
);
endmodule