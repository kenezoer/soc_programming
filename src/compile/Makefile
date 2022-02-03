
imem_pattern ?= FFFFFFFF
dmem_pattern ?= FFFFFFFF
export ABI   ?= ilp32

TCM := 0
# Paths
export root_dir := $(shell pwd)
export tst_dir  := $(root_dir)
export inc_dir  := $(tst_dir)/common
export bld_dir  := $(root_dir)/user_programm/build

test_results := $(bld_dir)/test_results.txt
test_info    := $(bld_dir)/test_info
sim_results  := $(bld_dir)/sim_results.txt
todo_list    := $(bld_dir)/todo.txt


# Environment
export CROSS_PREFIX  ?= riscv64-unknown-elf-
export RISCV_GCC     ?= $(CROSS_PREFIX)gcc
export RISCV_OBJDUMP ?= $(CROSS_PREFIX)objdump -D
export RISCV_OBJCOPY ?= $(CROSS_PREFIX)objcopy -O verilog
export RISCV_READELF ?= $(CROSS_PREFIX)readelf -s
export EXT_CFLAGS 	  = -D__RVC_EXT

# Core and compilation Settings
export ARCH         := ic
export VECT_IRQ     := 1
export IPIC         := 1
export TCM          := 1
export SIM_CFG_DEF  := SCR1_CFG_RV32IC_BASE

compile: | $(bld_dir)
	-$(MAKE) -C $(tst_dir)/user_programm EXT_CFLAGS="$(EXT_CFLAGS)" ARCH=$(ARCH)

clean_hex: | $(bld_dir)
	$(RM) $(bld_dir)/*.hex

$(bld_dir):
	mkdir -p $(bld_dir)

clean: 
	$(RM) -R $(bld_dir)/*