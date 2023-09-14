

TOOL ?= xrun

RTL_FILES  	 = -F ../../filelist/main_project.f
RTL_FILES  	+= -F ../../filelist/scr1.f
RTL_FILES  	+= -F ../../filelist/yetanotheruart.f

TOOL_OPTS	 = -sv
TOOL_OPTS	+= +access+rwc
TOOL_OPTS   += -timescale 1ns/1ns
TOOL_OPTS	+= -gui
TOOL_OPTS	+= -nowarn DSEMEL
TOOL_OPTS	+= -nowarn STARMT


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
	@rm -rf xcelium.d
	@rm -rf xrun.*

