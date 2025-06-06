-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1.1 (lin64) Build 3286242 Wed Jul 28 13:09:46 MDT 2021
-- Date        : Fri Nov  5 15:08:27 2021
-- Host        : andre running 64-bit Ubuntu 20.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/andre/DenoisingLidar/vivado_projects/project_ddr_new/project_ddr_new.gen/sources_1/bd/design_1/ip/design_1_AXI_lite_Slave_0_0_1/design_1_AXI_lite_Slave_0_0_stub.vhdl
-- Design      : design_1_AXI_lite_Slave_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_AXI_lite_Slave_0_0 is
  Port ( 
    o_start : out STD_LOGIC;
    i_finish : in STD_LOGIC_VECTOR ( 15 downto 0 );
    frame_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    o_pointcloud_size : out STD_LOGIC_VECTOR ( 31 downto 0 );
    o_search_radius : out STD_LOGIC_VECTOR ( 7 downto 0 );
    o_multi_parameter : out STD_LOGIC_VECTOR ( 7 downto 0 );
    o_filtertype : out STD_LOGIC_VECTOR ( 3 downto 0 );
    o_neighbor_treshold : out STD_LOGIC_VECTOR ( 3 downto 0 );
    o_intensity_treshold : out STD_LOGIC_VECTOR ( 3 downto 0 );
    o_finish_read : out STD_LOGIC_VECTOR ( 15 downto 0 );
    new_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_ACLK : in STD_LOGIC;
    S_AXI_ARESETN : in STD_LOGIC;
    S_AXI_AWADDR : in STD_LOGIC_VECTOR ( 4 downto 0 );
    S_AXI_AWPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_AWVALID : in STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_WVALID : in STD_LOGIC;
    S_AXI_WREADY : out STD_LOGIC;
    S_AXI_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_BVALID : out STD_LOGIC;
    S_AXI_BREADY : in STD_LOGIC;
    S_AXI_ARADDR : in STD_LOGIC_VECTOR ( 4 downto 0 );
    S_AXI_ARPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_ARVALID : in STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    S_AXI_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_RVALID : out STD_LOGIC;
    S_AXI_RREADY : in STD_LOGIC
  );

end design_1_AXI_lite_Slave_0_0;

architecture stub of design_1_AXI_lite_Slave_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "o_start,i_finish[15:0],frame_id[31:0],o_pointcloud_size[31:0],o_search_radius[7:0],o_multi_parameter[7:0],o_filtertype[3:0],o_neighbor_treshold[3:0],o_intensity_treshold[3:0],o_finish_read[15:0],new_frame_id[31:0],S_AXI_ACLK,S_AXI_ARESETN,S_AXI_AWADDR[4:0],S_AXI_AWPROT[2:0],S_AXI_AWVALID,S_AXI_AWREADY,S_AXI_WDATA[31:0],S_AXI_WSTRB[3:0],S_AXI_WVALID,S_AXI_WREADY,S_AXI_BRESP[1:0],S_AXI_BVALID,S_AXI_BREADY,S_AXI_ARADDR[4:0],S_AXI_ARPROT[2:0],S_AXI_ARVALID,S_AXI_ARREADY,S_AXI_RDATA[31:0],S_AXI_RRESP[1:0],S_AXI_RVALID,S_AXI_RREADY";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "AXI_lite_Slave,Vivado 2021.1.1";
begin
end;
