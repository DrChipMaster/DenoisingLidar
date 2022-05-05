// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1.1 (lin64) Build 3286242 Wed Jul 28 13:09:46 MDT 2021
// Date        : Tue Dec  7 14:24:38 2021
// Host        : andre running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/andre/DenoisingLidar/vivado_projects/project_ddr_new/project_ddr_new.gen/sources_1/bd/design_1/ip/design_1_ddr_interface_0_0_1/design_1_ddr_interface_0_0_stub.v
// Design      : design_1_ddr_interface_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ddr_interface,Vivado 2021.1.1" *)
module design_1_ddr_interface_0_0(o_write_address, o_write_payload, 
  o_readAdress, o_initwritetxn, o_initreadtxn, i_AMU_P, rst, i_write_TxnDone, i_read_TxnDone, 
  i_start, i_pointcloud_size, i_filtertype, i_neighbor_treshold, i_search_radius, 
  i_intensity_treshold, i_multi_parameter, i_finish_read, o_finish, frame_id, new_frame_id, 
  clock)
/* synthesis syn_black_box black_box_pad_pin="o_write_address[31:0],o_write_payload[63:0],o_readAdress[31:0],o_initwritetxn,o_initreadtxn,i_AMU_P[2047:0],rst,i_write_TxnDone,i_read_TxnDone,i_start,i_pointcloud_size[31:0],i_filtertype[3:0],i_neighbor_treshold[3:0],i_search_radius[7:0],i_intensity_treshold[3:0],i_multi_parameter[7:0],i_finish_read[15:0],o_finish[15:0],frame_id[31:0],new_frame_id[31:0],clock" */;
  output [31:0]o_write_address;
  output [63:0]o_write_payload;
  output [31:0]o_readAdress;
  output o_initwritetxn;
  output o_initreadtxn;
  input [2047:0]i_AMU_P;
  input rst;
  input i_write_TxnDone;
  input i_read_TxnDone;
  input i_start;
  input [31:0]i_pointcloud_size;
  input [3:0]i_filtertype;
  input [3:0]i_neighbor_treshold;
  input [7:0]i_search_radius;
  input [3:0]i_intensity_treshold;
  input [7:0]i_multi_parameter;
  input [15:0]i_finish_read;
  output [15:0]o_finish;
  output [31:0]frame_id;
  input [31:0]new_frame_id;
  input clock;
endmodule
