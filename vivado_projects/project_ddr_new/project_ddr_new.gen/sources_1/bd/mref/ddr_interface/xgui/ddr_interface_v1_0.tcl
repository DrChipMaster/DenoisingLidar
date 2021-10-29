# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AXI_MODULE_OUTPUTS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CACHE_FEEDER_MULTIPLIER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CACHE_MULTIPLIER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CORE_NUMBER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DDR_BASE_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DISTANCE_MODULES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N" -parent ${Page_0}


}

proc update_PARAM_VALUE.AXI_MODULE_OUTPUTS { PARAM_VALUE.AXI_MODULE_OUTPUTS } {
	# Procedure called to update AXI_MODULE_OUTPUTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_MODULE_OUTPUTS { PARAM_VALUE.AXI_MODULE_OUTPUTS } {
	# Procedure called to validate AXI_MODULE_OUTPUTS
	return true
}

proc update_PARAM_VALUE.CACHE_FEEDER_MULTIPLIER { PARAM_VALUE.CACHE_FEEDER_MULTIPLIER } {
	# Procedure called to update CACHE_FEEDER_MULTIPLIER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CACHE_FEEDER_MULTIPLIER { PARAM_VALUE.CACHE_FEEDER_MULTIPLIER } {
	# Procedure called to validate CACHE_FEEDER_MULTIPLIER
	return true
}

proc update_PARAM_VALUE.CACHE_MULTIPLIER { PARAM_VALUE.CACHE_MULTIPLIER } {
	# Procedure called to update CACHE_MULTIPLIER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CACHE_MULTIPLIER { PARAM_VALUE.CACHE_MULTIPLIER } {
	# Procedure called to validate CACHE_MULTIPLIER
	return true
}

proc update_PARAM_VALUE.CORE_NUMBER { PARAM_VALUE.CORE_NUMBER } {
	# Procedure called to update CORE_NUMBER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CORE_NUMBER { PARAM_VALUE.CORE_NUMBER } {
	# Procedure called to validate CORE_NUMBER
	return true
}

proc update_PARAM_VALUE.DDR_BASE_ADDRESS { PARAM_VALUE.DDR_BASE_ADDRESS } {
	# Procedure called to update DDR_BASE_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DDR_BASE_ADDRESS { PARAM_VALUE.DDR_BASE_ADDRESS } {
	# Procedure called to validate DDR_BASE_ADDRESS
	return true
}

proc update_PARAM_VALUE.DISTANCE_MODULES { PARAM_VALUE.DISTANCE_MODULES } {
	# Procedure called to update DISTANCE_MODULES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DISTANCE_MODULES { PARAM_VALUE.DISTANCE_MODULES } {
	# Procedure called to validate DISTANCE_MODULES
	return true
}

proc update_PARAM_VALUE.N { PARAM_VALUE.N } {
	# Procedure called to update N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N { PARAM_VALUE.N } {
	# Procedure called to validate N
	return true
}


proc update_MODELPARAM_VALUE.N { MODELPARAM_VALUE.N PARAM_VALUE.N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N}] ${MODELPARAM_VALUE.N}
}

proc update_MODELPARAM_VALUE.DISTANCE_MODULES { MODELPARAM_VALUE.DISTANCE_MODULES PARAM_VALUE.DISTANCE_MODULES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DISTANCE_MODULES}] ${MODELPARAM_VALUE.DISTANCE_MODULES}
}

proc update_MODELPARAM_VALUE.CORE_NUMBER { MODELPARAM_VALUE.CORE_NUMBER PARAM_VALUE.CORE_NUMBER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CORE_NUMBER}] ${MODELPARAM_VALUE.CORE_NUMBER}
}

proc update_MODELPARAM_VALUE.CACHE_MULTIPLIER { MODELPARAM_VALUE.CACHE_MULTIPLIER PARAM_VALUE.CACHE_MULTIPLIER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CACHE_MULTIPLIER}] ${MODELPARAM_VALUE.CACHE_MULTIPLIER}
}

proc update_MODELPARAM_VALUE.CACHE_FEEDER_MULTIPLIER { MODELPARAM_VALUE.CACHE_FEEDER_MULTIPLIER PARAM_VALUE.CACHE_FEEDER_MULTIPLIER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CACHE_FEEDER_MULTIPLIER}] ${MODELPARAM_VALUE.CACHE_FEEDER_MULTIPLIER}
}

proc update_MODELPARAM_VALUE.AXI_MODULE_OUTPUTS { MODELPARAM_VALUE.AXI_MODULE_OUTPUTS PARAM_VALUE.AXI_MODULE_OUTPUTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_MODULE_OUTPUTS}] ${MODELPARAM_VALUE.AXI_MODULE_OUTPUTS}
}

proc update_MODELPARAM_VALUE.DDR_BASE_ADDRESS { MODELPARAM_VALUE.DDR_BASE_ADDRESS PARAM_VALUE.DDR_BASE_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DDR_BASE_ADDRESS}] ${MODELPARAM_VALUE.DDR_BASE_ADDRESS}
}

