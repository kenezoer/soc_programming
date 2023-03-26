

TOOL ?= vcs

RTL_FILES  	 = -F ../../filelist/main_project.f
RTL_FILES  	+= -F ../../filelist/scr1.f
RTL_FILES  	+= -F ../../filelist/yetanotheruart.f

INCLUDE_DIRS  = +incdir+../rtl/dw_axi/miet_dw_axi_ic/
INCLUDE_DIRS += +incdir+../rtl/x2p/
INCLUDE_DIRS += +incdir+../rtl/scr1/includes/
INCLUDE_DIRS += +incdir+../rtl/axilite_uart

TOOL_OPTS	 = -sverilog
TOOL_OPTS	+= -debug
TOOL_OPTS   += -PR
TOOL_OPTS   += -RI
TOOL_OPTS	+= +systemverilogext+svi
TOOL_OPTS	+= +systemverilogext+svh
TOOL_OPTS	+= +systemverilogext+vh
TOOL_OPTS   += -timescale=1ns/1ns
TOOL_OPTS   += -assert svaext


help:
	@echo "============================================================"
	@echo "MIET LABORATORY COURSE \"SOC WITH PROGRAMMING ARCHITECTURE\""
	@echo "============================================================"
	@echo "Authors: Kirill Liubavin, Pavel Kuzmin"
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

