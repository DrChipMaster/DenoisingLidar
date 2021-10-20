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

integer f_x,f_y,f_z,f_point;
integer i,j,l,k;

reg [N-1:0] x_array [point_cloud_size-1:0];
reg [N-1:0] y_array [point_cloud_size-1:0];
reg [N-1:0] z_array [point_cloud_size-1:0];
reg [N-1:0] i_array [point_cloud_size-1:0];

reg [63:0] value_64bits[point_cloud_size-1:0];
integer i;


wire[31:0] o_write_address;
wire[63:0] o_write_payload;
wire[31:0] o_readAdress;
wire o_initwritetxn;
wire o_initreadtxn;
reg[63:0] i_AMU_P0;
reg[63:0] i_AMU_P1;
reg[63:0] i_AMU_P2;
reg[63:0] i_AMU_P3;
reg[63:0] i_AMU_P4;
reg[63:0] i_AMU_P5;
reg[63:0] i_AMU_P6;
reg[63:0] i_AMU_P7;
reg[63:0] i_AMU_P8;
reg[63:0] i_AMU_P9;
reg[63:0] i_AMU_P10;
reg[63:0] i_AMU_P11;
reg[63:0] i_AMU_P12;
reg[63:0] i_AMU_P13;
reg[63:0] i_AMU_P14;
reg rst;
reg i_write_TxnDone;
reg i_read_TxnDone;
reg i_start;
reg[31:0] i_pointcloud_size;
reg[3:0] i_filtertype;
wire[15:0] o_finish;

initial
begin
    clock = 1;
    cycle_counter =0;
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_x.txt",x_array);
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_y.txt",y_array);
//    $readmemh("/home/andre/ror_filter/Points/SnowStopped_z.txt",z_array);
//    $readmemh("/home/andre/DenoisingLidar/Points/teste_int_x_32.txt",x_array);
//    $readmemh("/home/andre/DenoisingLidar/Points/teste_int_y_32.txt",y_array);
//    $readmemh("/home/andre/DenoisingLidar/Points/teste_int_z_32.txt",z_array);
//     $readmemh("/home/andre/DenoisingLidar/Points/teste_int_i_32.txt",i_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_x.txt",x_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_z.txt",z_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_y.txt",y_array);
    $readmemh("C:\\Users\\andre\\Desktop\\Points\\teste_int_i.txt",i_array);
    f_x = $fopen("output_x.txt","w");
    f_y = $fopen("output_y.txt","w");
    f_z = $fopen("output_z.txt","w");
    f_point = $fopen("point_pos.txt","w");
    for (i = 0; i<point_cloud_size;i=i+1) begin
        value_64bits[i] = (i_array[i]<<(16*3))+(z_array[i]<<(16*2))+(y_array[i]<<(16))+(x_array[i]);
    end
    cycle_counter =0;
    rst =0;
    i_start = 1;
    i_pointcloud_size=point_cloud_size;
    i_write_TxnDone <=0;
    i_filtertype = 2;
    #10;
    rst =1;
end

reg [15:0] cycle_counter;
always @(posedge clock) begin
    if (o_initreadtxn) begin
        cycle_counter <=1;
        i_read_TxnDone<=0;
        i_AMU_P0 <= 0;
        i_AMU_P1 <= 0;
        i_AMU_P2 <= 0;
        i_AMU_P3 <= 0;
        i_AMU_P4 <= 0;
        i_AMU_P5 <= 0;
        i_AMU_P6 <= 0;
        i_AMU_P7 <= 0;
        i_AMU_P8 <= 0;
        i_AMU_P9 <= 0;
        i_AMU_P10 <=0;
        i_AMU_P11 <=0;
        i_AMU_P12 <=0;
        i_AMU_P13 <=0;
        i_AMU_P14 <=0;
    end
    else if (cycle_counter>0) begin
        if (cycle_counter >20) begin
            i_read_TxnDone<=1;
            cycle_counter <=0;
        end
        else if (cycle_counter==15) begin
            i_AMU_P0 <= value_64bits[o_readAdress];
            i_AMU_P1 <= value_64bits[o_readAdress+1];
            i_AMU_P2 <= value_64bits[o_readAdress+2];
            i_AMU_P3 <= value_64bits[o_readAdress+3];
            i_AMU_P4 <= value_64bits[o_readAdress+4];
            i_AMU_P5 <= value_64bits[o_readAdress+5];
            i_AMU_P6 <= value_64bits[o_readAdress+6];
            i_AMU_P7 <= value_64bits[o_readAdress+7];
            i_AMU_P8 <= value_64bits[o_readAdress+8];
            i_AMU_P9 <= value_64bits[o_readAdress+9];
            i_AMU_P10 <= value_64bits[o_readAdress+10];
            i_AMU_P11 <= value_64bits[o_readAdress+11];
            i_AMU_P12 <= value_64bits[o_readAdress+12];
            i_AMU_P13 <= value_64bits[o_readAdress+13];
            i_AMU_P14 <= value_64bits[o_readAdress+14];
            cycle_counter <= cycle_counter +1;
        end
        else begin
            cycle_counter <= cycle_counter +1;
        end
    end
end


reg[15:0] awnser_clocks;
always @(posedge clock) begin
    if(o_initwritetxn) begin
        awnser_clocks <=1;
        i_write_TxnDone <=0;
    end
    else if (awnser_clocks>0)begin
        if(awnser_clocks>20)begin
            i_write_TxnDone <=1;
            awnser_clocks<=0;
        end
        else if (awnser_clocks==15) begin
            x_array[o_write_address]=0;
            y_array[o_write_address]=0;
            z_array[o_write_address]=0;
            awnser_clocks <=awnser_clocks+1;
        end
        else begin
            awnser_clocks <=awnser_clocks+1;
        end
    end
end



 always @(posedge clock) begin
     if(o_finish>0)
         begin
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







ddr_interface m_interface(
                    .o_write_address(o_write_address),
                    .o_write_payload(o_write_payload),
                    .o_readAdress(o_readAdress),
                    .o_initwritetxn(o_initwritetxn),
                    .o_initreadtxn(o_initreadtxn),
                    .i_AMU_P0(i_AMU_P0),
                    .i_AMU_P1(i_AMU_P1),
                    .i_AMU_P2(i_AMU_P2),
                    .i_AMU_P3(i_AMU_P3),
                    .i_AMU_P4(i_AMU_P4),
                    .i_AMU_P5(i_AMU_P5),
                    .i_AMU_P6(i_AMU_P6),
                    .i_AMU_P7(i_AMU_P7),
                    .i_AMU_P8(i_AMU_P8),
                    .i_AMU_P9(i_AMU_P9),
                    .i_AMU_P10(i_AMU_P10),
                    .i_AMU_P11(i_AMU_P11),
                    .i_AMU_P12(i_AMU_P12),
                    .i_AMU_P13(i_AMU_P13),
                    .i_AMU_P14(i_AMU_P14),
                    .rst(rst),
                    .i_write_TxnDone(i_write_TxnDone),
                    .i_read_TxnDone(i_read_TxnDone),
                    //DDR_MODULE CONNECTION
                    //AXI lite Module
                    .i_start(i_start),
                    .i_pointcloud_size(i_pointcloud_size),
                    .i_filtertype(i_filtertype),
                    .o_finish(o_finish),
                    //AXI lite Module
                    .clock(clock)
);

always #(Clock_period/2) clock <= ~clock;

endmodule
