# downloads and temporary output directory
$(shell mkdir -p $(target_out))

# Check cross compiler
filesystem_path := $(shell which ${CROSS_COMPILE}gcc 2>/dev/null)
ifeq ($(strip $(filesystem_path)),)                                                                                         
$(error No uClinux toolchain found)
endif
