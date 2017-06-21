build-rootfs: busybox $(rootfs_target)

busybox:
	# Check busybox
	# filesystem_path := $(shell ls $(busybox_dir) 2>/dev/null)
	# ifeq ($(strip $(filesystem_path)),)
	# $(info *** Fetching busybox source ***)
	# $(info $(shell tar -jxf downloads/${busybox_version}.tar.bz2 -C $(root_dir)))
	# endif	
	$(shell mkdir -p ${target_out_busybox})
	$(shell mkdir -p ${target_out_romfs})
	cp -f configs/busybox_config $(target_out_busybox)/.config
	make -C $(busybox_dir) \
		O=$(target_out_busybox) oldconfig
	make -C $(target_out_busybox) \
		ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) \
		CFLAGS=$(ROOTFS_CFLAGS) SKIP_STRIP=y \
		CONFIG_PREFIX=$(target_out_romfs) install

$(rootfs_target): $(rootfs_dir) $(target_out_busybox)/.config
	cp -af $(rootfs_dir)/* $(target_out_romfs)
	cp -f $(target_out_kernel)/fs/ext2/ext2.ko $(target_out_romfs)/lib/modules
	cp -f $(target_out_kernel)/fs/mbcache.ko $(target_out_romfs)/lib/modules
	cd $(target_out) && genromfs -v \
		-V "ROM Disk" \
		-f romfs.bin \
		-x placeholder \
		-d $(target_out_romfs) 2> $(target_out)/romfs.map
