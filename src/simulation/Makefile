

TOOL ?= vcs

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

TOOL_OPTS	 = -sverilog
TOOL_OPTS	+= -debug
TOOL_OPTS   += -PR
TOOL_OPTS   += -RI
TOOL_OPTS	+= -gui
TOOL_OPTS	+= +systemverilogext+svi
TOOL_OPTS	+= +systemverilogext+svh
TOOL_OPTS	+= +systemverilogext+vh
TOOL_OPTS   += -timescale=1ns/1ns


help:
	@echo "============================================================"
	@echo "MIET LABORATORY COURSE \"SOC WITH PROGRAMMING ARCHITECTURE\""
	@echo "============================================================"
	@echo "Authors: Kirill Liubavin, Oleg Kalistratov"
	@echo "============================================================"
	@echo "Available make directives:"
	@echo "make sim (run simulation)"
	@echo "make clean (clean temp files)"
	@echo "make help (what you currently looking at)"

sim:
	$(TOOL) $(TOOL_OPTS) $(INCLUDE_DIRS) $(RTL_FILES)
	@./simv -gui

clean:
	@rm -rf *.log*
	@rm -rf sim*
	@rm -rf csrc
	@rm -rf DVE*
	@rm -rf *.vpd
	@rm -rf *.key

