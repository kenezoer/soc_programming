

TOOL ?= xrun

RTL_FILES  = -F ../rtl/dw_axi/miet_dw_axi_ic/DW_axi.f
RTL_FILES += -F ../rtl/scr1/core.files
RTL_FILES += -F ../rtl/scr1/axi_top.files
RTL_FILES += -F ../rtl/x2p/DW_axi_x2p.f
RTL_FILES += ../rtl/dw_axi/miet_dw_axi.v
RTL_FILES += ../rtl/dw_axi/miet_interconnect_wrapper.sv
RTL_FILES += -F ../rtl/rtl_list.f

INCLUDE_DIRS  = +incdir+../rtl/dw_axi/miet_dw_axi_ic/
INCLUDE_DIRS += +incdir+../rtl/x2p/
INCLUDE_DIRS += +incdir+../rtl/scr1/includes/
INCLUDE_DIRS += +incdir+../rtl/axilite_uart

TOOL_OPTS	 = -sv12
TOOL_OPTS	+= +access+rwc
TOOL_OPTS   += -timescale 1ns/1ns


help:
	@echo "------------------------------------------------------------"
	@echo "MIET LABORATORY COURSE \"SOC WITH PROGRAMMING ARCHITECTURE\""
	@echo "------------------------------------------------------------"
	@echo " "
	@echo "Authors: "
	@echo "  - Kirill Liubavin"
	@echo "  - Oleg Kalistratov"
	@echo "  - Pavel Kuzmin"
	@echo " "
	@echo "------------------------------------------------------------"
	@echo " "
	@echo "Available make directives:"
	@echo "make sim (run simulation)"
	@echo "make clean (clean temp files)"
	@echo "make help (what you currently looking at)"

sim:
	$(TOOL) $(TOOL_OPTS) $(INCLUDE_DIRS) $(RTL_FILES)

clean:
	@rm -rf *.log*
	@rm -rf sim*
	@rm -rf csrc
	@rm -rf DVE*
	@rm -rf *.vpd
	@rm -rf *.key

