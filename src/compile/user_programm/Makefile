src_dir := $(dir $(lastword $(MAKEFILE_LIST)))

c_src := sc_print.c hello.c

include $(inc_dir)/common.mk

default: log_requested_tgt $(bld_dir)/user_programm.elf $(bld_dir)/user_programm.hex $(bld_dir)/user_programm.dump

log_requested_tgt:
	echo user_programm.hex >> $(bld_dir)/test_info

clean:
	$(RM) $(c_objs) $(asm_objs) $(bld_dir)/user_programm.elf $(bld_dir)/user_programm.hex $(bld_dir)/user_programm.dump