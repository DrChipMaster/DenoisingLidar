# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_M_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_ARUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_AWUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_BURST_LEN_READ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_BURST_LEN_WRITE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_BUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_RUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_WUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_TARGET_SLAVE_BASE_ADDR" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_M_AXI_ADDR_WIDTH { PARAM_VALUE.C_M_AXI_ADDR_WIDTH } {
	# Procedure called to update C_M_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_ADDR_WIDTH { PARAM_VALUE.C_M_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_M_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_ARUSER_WIDTH { PARAM_VALUE.C_M_AXI_ARUSER_WIDTH } {
	# Procedure called to update C_M_AXI_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_ARUSER_WIDTH { PARAM_VALUE.C_M_AXI_ARUSER_WIDTH } {
	# Procedure called to validate C_M_AXI_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_AWUSER_WIDTH { PARAM_VALUE.C_M_AXI_AWUSER_WIDTH } {
	# Procedure called to update C_M_AXI_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_AWUSER_WIDTH { PARAM_VALUE.C_M_AXI_AWUSER_WIDTH } {
	# Procedure called to validate C_M_AXI_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_BURST_LEN_READ { PARAM_VALUE.C_M_AXI_BURST_LEN_READ } {
	# Procedure called to update C_M_AXI_BURST_LEN_READ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_BURST_LEN_READ { PARAM_VALUE.C_M_AXI_BURST_LEN_READ } {
	# Procedure called to validate C_M_AXI_BURST_LEN_READ
	return true
}

proc update_PARAM_VALUE.C_M_AXI_BURST_LEN_WRITE { PARAM_VALUE.C_M_AXI_BURST_LEN_WRITE } {
	# Procedure called to update C_M_AXI_BURST_LEN_WRITE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_BURST_LEN_WRITE { PARAM_VALUE.C_M_AXI_BURST_LEN_WRITE } {
	# Procedure called to validate C_M_AXI_BURST_LEN_WRITE
	return true
}

proc update_PARAM_VALUE.C_M_AXI_BUSER_WIDTH { PARAM_VALUE.C_M_AXI_BUSER_WIDTH } {
	# Procedure called to update C_M_AXI_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_BUSER_WIDTH { PARAM_VALUE.C_M_AXI_BUSER_WIDTH } {
	# Procedure called to validate C_M_AXI_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_DATA_WIDTH { PARAM_VALUE.C_M_AXI_DATA_WIDTH } {
	# Procedure called to update C_M_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_DATA_WIDTH { PARAM_VALUE.C_M_AXI_DATA_WIDTH } {
	# Procedure called to validate C_M_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_ID_WIDTH { PARAM_VALUE.C_M_AXI_ID_WIDTH } {
	# Procedure called to update C_M_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_ID_WIDTH { PARAM_VALUE.C_M_AXI_ID_WIDTH } {
	# Procedure called to validate C_M_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_RUSER_WIDTH { PARAM_VALUE.C_M_AXI_RUSER_WIDTH } {
	# Procedure called to update C_M_AXI_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_RUSER_WIDTH { PARAM_VALUE.C_M_AXI_RUSER_WIDTH } {
	# Procedure called to validate C_M_AXI_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_WUSER_WIDTH { PARAM_VALUE.C_M_AXI_WUSER_WIDTH } {
	# Procedure called to update C_M_AXI_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_WUSER_WIDTH { PARAM_VALUE.C_M_AXI_WUSER_WIDTH } {
	# Procedure called to validate C_M_AXI_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to update C_M_TARGET_SLAVE_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to validate C_M_TARGET_SLAVE_BASE_ADDR
	return true
}


proc update_MODELPARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR { MODELPARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR PARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR}] ${MODELPARAM_VALUE.C_M_TARGET_SLAVE_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.C_M_AXI_BURST_LEN_WRITE { MODELPARAM_VALUE.C_M_AXI_BURST_LEN_WRITE PARAM_VALUE.C_M_AXI_BURST_LEN_WRITE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_BURST_LEN_WRITE}] ${MODELPARAM_VALUE.C_M_AXI_BURST_LEN_WRITE}
}

proc update_MODELPARAM_VALUE.C_M_AXI_BURST_LEN_READ { MODELPARAM_VALUE.C_M_AXI_BURST_LEN_READ PARAM_VALUE.C_M_AXI_BURST_LEN_READ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_BURST_LEN_READ}] ${MODELPARAM_VALUE.C_M_AXI_BURST_LEN_READ}
}

proc update_MODELPARAM_VALUE.C_M_AXI_ID_WIDTH { MODELPARAM_VALUE.C_M_AXI_ID_WIDTH PARAM_VALUE.C_M_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH PARAM_VALUE.C_M_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_DATA_WIDTH PARAM_VALUE.C_M_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_AWUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI_AWUSER_WIDTH PARAM_VALUE.C_M_AXI_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_ARUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI_ARUSER_WIDTH PARAM_VALUE.C_M_AXI_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_WUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI_WUSER_WIDTH PARAM_VALUE.C_M_AXI_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_RUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI_RUSER_WIDTH PARAM_VALUE.C_M_AXI_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_BUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI_BUSER_WIDTH PARAM_VALUE.C_M_AXI_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_BUSER_WIDTH}
}

