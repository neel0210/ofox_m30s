#
# Copyright (C) 2020 Projekt YuMi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

## Build and run dtbtool
DTBTOOL := $(HOST_OUT_EXECUTABLES)/dtbToolCM$(HOST_EXECUTABLE_SUFFIX)
LZ4_DT_IMAGE := $(PRODUCT_OUT)/dt.img

ifndef TARGET_PREBUILT_DTB
$(INSTALLED_DTIMAGE_TARGET): $(DTBTOOL) $(INSTALLED_KERNEL_TARGET)
	$(call pretty,"Target dt image: $@")
	$(DTBTOOL) $(BOARD_DTBTOOL_ARGS) -o $@ -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/
	$(hide) chmod a+r $@
	lz4 -9 < $@ > $(LZ4_DT_IMAGE) || lz4c -c1 -y $@ $(LZ4_DT_IMAGE)
	$(hide) $(ACP) $(LZ4_DT_IMAGE) $@
	@echo "Made DT image: $@"
else
$(INSTALLED_DTIMAGE_TARGET): $(TARGET_PREBUILT_DTB)
	cp $(TARGET_PREBUILT_DTB) $(INSTALLED_DTIMAGE_TARGET)
endif

## Overload bootimg generation: Same as the original, + --dt arg
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE))

## Overload recoveryimg generation: Same as the original, + --dt arg
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel) \
	$(RECOVERYIMAGE_EXTRA_DEPS)
	@echo ----- Making recovery image ------
	$(call build-recoveryimage-target, $@)
