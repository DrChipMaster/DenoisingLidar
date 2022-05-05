-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1.1 (lin64) Build 3286242 Wed Jul 28 13:09:46 MDT 2021
-- Date        : Tue Dec  7 14:24:38 2021
-- Host        : andre running 64-bit Ubuntu 20.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/andre/DenoisingLidar/vivado_projects/project_ddr_new/project_ddr_new.gen/sources_1/bd/design_1/ip/design_1_ddr_interface_0_0_1/design_1_ddr_interface_0_0_stub.vhdl
-- Design      : design_1_ddr_interface_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_ddr_interface_0_0 is
  Port ( 
    o_write_address : out STD_LOGIC_VECTOR ( 31 downto 0 );
    o_write_payload : out STD_LOGIC_VECTOR ( 63 downto 0 );
    o_readAdress : out STD_LOGIC_VECTOR ( 31 downto 0 );
    o_initwritetxn : out STD_LOGIC;
    o_initreadtxn : out STD_LOGIC;
    i_AMU_P : in STD_LOGIC_VECTOR ( 2047 downto 0 );
    rst : in STD_LOGIC;
    i_write_TxnDone : in STD_LOGIC;
    i_read_TxnDone : in STD_LOGIC;
    i_start : in STD_LOGIC;
    i_pointcloud_size : in STD_LOGIC_VECTOR ( 31 downto 0 );
    i_filtertype : in STD_LOGIC_VECTOR ( 3 downto 0 );
    i_neighbor_treshold : in STD_LOGIC_VECTOR ( 3 downto 0 );
    i_search_radius : in STD_LOGIC_VECTOR ( 7 downto 0 );
    i_intensity_treshold : in STD_LOGIC_VECTOR ( 3 downto 0 );
    i_multi_parameter : in STD_LOGIC_VECTOR ( 7 downto 0 );
    i_finish_read : in STD_LOGIC_VECTOR ( 15 downto 0 );
    o_finish : out STD_LOGIC_VECTOR ( 15 downto 0 );
    frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    new_frame_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    clock : in STD_LOGIC
  );

end design_1_ddr_interface_0_0;

architecture stub of design_1_ddr_interface_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "o_write_address[31:0],o_write_payload[63:0],o_readAdress[31:0],o_initwritetxn,o_initreadtxn,i_AMU_P[2047:0],rst,i_write_TxnDone,i_read_TxnDone,i_start,i_pointcloud_size[31:0],i_filtertype[3:0],i_neighbor_treshold[3:0],i_search_radius[7:0],i_intensity_treshold[3:0],i_multi_parameter[7:0],i_finish_read[15:0],o_finish[15:0],frame_id[31:0],new_frame_id[31:0],clock";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ddr_interface,Vivado 2021.1.1";
begin
end;
