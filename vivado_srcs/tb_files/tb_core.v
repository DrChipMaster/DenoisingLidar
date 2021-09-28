module tb_core;

reg Clock;
parameter N = 16;
parameter M = 32;
parameter point_cloud_size = 17500;
parameter neighbor_treshold = 30;
parameter search_radius =200;

parameter Clock_period = 4; 
integer error,actual_result;
reg [N-1:0] point_x1;
reg [N-1:0] point_y1;
reg [N-1:0] point_z1;

reg [N-1:0] point_x2;
reg [N-1:0] point_y2;
reg [N-1:0] point_z2;


reg reset;
reg point3d;
wire [N/2-1:0] distance;
wire done;
wire inlier;
wire outlier;
integer i,j,l;



reg[N-1:0] vector_x;
reg[N-1:0] vector_y;
reg[N-1:0] vector_z;

reg [N-1:0] x_array [point_cloud_size-1:0];
reg [N-1:0] y_array [point_cloud_size-1:0];
reg [N-1:0] z_array [point_cloud_size-1:0];


  reg [N*M-1:0] cp_x;
  reg [N*M-1:0] cp_y;
  reg [N*M-1:0] cp_z;
integer f_x,f_y,f_z;
initial
begin
    
    Clock = 1;
    error = 0;
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_x.txt",x_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_y.txt",y_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\SnowStopped_z.txt",z_array);
    f_x = $fopen("output_x.txt","w");
    f_y = $fopen("output_y.txt","w");
    f_z = $fopen("output_z.txt","w");
    
    
 for (l=0;l<=point_cloud_size-1;l=l+1)
 begin
    point_x1 = x_array[l];
    point_y1 = y_array[l];
    point_z1 = z_array[l];
    reset =1;
    #Clock_period; 
    reset =0;
    for (i = 0; i<=point_cloud_size-1;i = i+1)
    begin
        apply_input(i);
    end
end
    #Clock_period;
    $fclose(f_x); 
    $fclose(f_y); 
    $fclose(f_z); 

    $stop;
end

task apply_input;
    input [N:0] in;
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
 for(j=i*M; j<((i+1)*(M));j = j+1)
 begin
 if (j == i*M)
 begin
    cp_x = x_array[j];
    cp_y = y_array[j];
    cp_z = z_array[j];
end
 else
 begin
  cp_x = (cp_x <<N) + x_array[j];
  cp_y = (cp_y <<N) + y_array[j];
  cp_z = (cp_z <<N) + z_array[j];
 end
 end
reset =0;




//actual_result <= ($floor($sqrt($pow((vector_x),2)+$pow(vector_y,2)+$pow(vector_z,2)))); //Calculate the actual result.

#Clock_period;
wait(~Clock);  
if(inlier == 1 || outlier==1)
begin
if(inlier ==1)
begin
$fwrite(f_x,"%h\n",point_x1);
$fwrite(f_y,"%h\n",point_y1);
$fwrite(f_z,"%h\n",point_z1);
end
i = point_cloud_size+1;
end
//wait(done);
//#Clock_period;
//wait(~Clock);  




end
endtask




always #(Clock_period/2) Clock <= ~Clock;





validator_core #(.N(N),.M(M)) core
(
  .clock(Clock),
  .reset(reset),
 .point_x(point_x1),
 .point_y(point_y1),
 .point_z(point_z1),
 .point_cloud_size(point_cloud_size),
 .cp_x(cp_x),
 .cp_y(cp_y),
 .cp_z(cp_z),
 .inlier(inlier),
 .outlier(outlier)
 
);
endmodule