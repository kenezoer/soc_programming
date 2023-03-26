CREATE_FILE := $(MSYS_DIR)touch
DELETE_FILE := $(MSYS_DIR)rm -rf
GREP := $(MSYS_DIR)grep
DELETE_FOLDER := $(MSYS_DIR)rm -r
MOVE_FILE := $(MSYS_DIR)mv
FIND_FILE := $(MSYS_DIR)find
COPY_FILE := $(MSYS_DIR)cp
MKDIR_P  := $(MSYS_DIR)mkdir -p

src_dir := $(dir $(lastword $(MAKEFILE_LIST)))

#c_src := main.c

c_src += $(shell $(FIND_FILE) $(src_dir) -name *.c )

include $(inc_dir)/common.mk

default: log_requested_tgt $(bld_dir)/user_programm.elf $(bld_dir)/user_programm.hex $(bld_dir)/user_programm.dump

log_requested_tgt:
	echo user_programm.hex >> $(bld_dir)/test_info

clean:
	$(RM) $(c_objs) $(asm_objs) $(bld_dir)/user_programm.elf $(bld_dir)/user_programm.hex $(bld_dir)/user_programm.dump