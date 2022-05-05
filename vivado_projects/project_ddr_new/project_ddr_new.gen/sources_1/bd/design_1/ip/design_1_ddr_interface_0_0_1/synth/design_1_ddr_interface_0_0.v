// (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:ddr_interface:1.0
// IP Revision: 1

(* X_CORE_INFO = "ddr_interface,Vivado 2021.1.1" *)
(* CHECK_LICENSE_TYPE = "design_1_ddr_interface_0_0,ddr_interface,{}" *)
(* CORE_GENERATION_INFO = "design_1_ddr_interface_0_0,ddr_interface,{x_ipProduct=Vivado 2021.1.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=ddr_interface,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,N=16,DISTANCE_MODULES=1,CORE_NUMBER=16,CACHE_MULTIPLIER=1,CACHE_FEEDER_MULTIPLIER=1,AXI_MODULE_OUTPUTS=32,DDR_BASE_ADDRESS=0x0F000000}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_ddr_interface_0_0 (
  o_write_address,
  o_write_payload,
  o_readAdress,
  o_initwritetxn,
  o_initreadtxn,
  i_AMU_P,
  rst,
  i_write_TxnDone,
  i_read_TxnDone,
  i_start,
  i_pointcloud_size,
  i_filtertype,
  i_neighbor_treshold,
  i_search_radius,
  i_intensity_treshold,
  i_multi_parameter,
  i_finish_read,
  o_finish,
  frame_id,
  new_frame_id,
  clock
);

output wire [31 : 0] o_write_address;
output wire [63 : 0] o_write_payload;
output wire [31 : 0] o_readAdress;
output wire o_initwritetxn;
output wire o_initreadtxn;
input wire [2047 : 0] i_AMU_P;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
input wire i_write_TxnDone;
input wire i_read_TxnDone;
input wire i_start;
input wire [31 : 0] i_pointcloud_size;
input wire [3 : 0] i_filtertype;
input wire [3 : 0] i_neighbor_treshold;
input wire [7 : 0] i_search_radius;
input wire [3 : 0] i_intensity_treshold;
input wire [7 : 0] i_multi_parameter;
input wire [15 : 0] i_finish_read;
output wire [15 : 0] o_finish;
output wire [31 : 0] frame_id;
input wire [31 : 0] new_frame_id;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clock, ASSOCIATED_RESET rst, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clock CLK" *)
input wire clock;

  ddr_interface #(
    .N(16),
    .DISTANCE_MODULES(1),
    .CORE_NUMBER(16),
    .CACHE_MULTIPLIER(1),
    .CACHE_FEEDER_MULTIPLIER(1),
    .AXI_MODULE_OUTPUTS(32),
    .DDR_BASE_ADDRESS(32'H0F000000)
  ) inst (
    .o_write_address(o_write_address),
    .o_write_payload(o_write_payload),
    .o_readAdress(o_readAdress),
    .o_initwritetxn(o_initwritetxn),
    .o_initreadtxn(o_initreadtxn),
    .i_AMU_P(i_AMU_P),
    .rst(rst),
    .i_write_TxnDone(i_write_TxnDone),
    .i_read_TxnDone(i_read_TxnDone),
    .i_start(i_start),
    .i_pointcloud_size(i_pointcloud_size),
    .i_filtertype(i_filtertype),
    .i_neighbor_treshold(i_neighbor_treshold),
    .i_search_radius(i_search_radius),
    .i_intensity_treshold(i_intensity_treshold),
    .i_multi_parameter(i_multi_parameter),
    .i_finish_read(i_finish_read),
    .o_finish(o_finish),
    .frame_id(frame_id),
    .new_frame_id(new_frame_id),
    .clock(clock)
  );
endmodule
