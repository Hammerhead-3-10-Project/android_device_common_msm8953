#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Common board configuration for the Samsung Snapdragon 450 / msm8953 family (Android 10 stock vendor).
# Device trees include this file and add what is specific to the model (partitions, boot header, density...).

COMMON_PATH := device/samsung/msm8953-common

BOARD_VENDOR := samsung

# Allow building with a minimal tree while the vendor blobs are being sorted out
ALLOW_MISSING_DEPENDENCIES := true

# Architecture: arm64 kernel but a 32-bit only userspace on the supported devices (abilist armeabi-v7a);
# binder is 64 bit. A device with a 64-bit userspace overrides these after including this file.
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msm8953
TARGET_NO_BOOTLOADER := true

# Platform (Lineage 17.1 maps msm8953 to QCOM_HARDWARE_VARIANT := msm8996, UM 3.18 family)
TARGET_BOARD_PLATFORM := msm8953
BOARD_USES_QCOM_HARDWARE := true

# Kernel / boot image (Image.gz-dtb: arm64 Image + appended dtbs, header v0)
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x02000000
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_KERNEL_TAGS_OFFSET := 0x01e00000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_BOOT_HEADER_VERSION := 0
BOARD_KERNEL_CMDLINE := console=null androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_SECOND_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_FLASH_BLOCK_SIZE := 131072

# Filesystems: no A/B, no dynamic partitions, separate system and vendor. There is no odm image: the odm partition of
# the phone holds the CSC (operator/region) data of the user's firmware and must not be overwritten by the ROM zip.
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_ODM := vendor/odm
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_HAS_LARGE_FILESYSTEM := true

# The stock system partition is a system-as-root image (init, sepolicy_version... at its root)
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_ROOT_EXTRA_FOLDERS := efs omr preload

# Treble: the vendor is Android 10 (VNDK 29), but it is "VNDK-lite" (ro.vndk.lite=true in the stock
# vendor default.prop). With that property the linker loads /system/etc/ld.config.vndk_lite.txt; without
# BOARD_VNDK_RUNTIME_DISABLE the build only installs the strict ld.config.29.txt, the linker finds no
# config at all and every binary (system ones too) fails with "library ... not found".
BOARD_VNDK_VERSION := current
BOARD_VNDK_RUNTIME_DISABLE := true
PRODUCT_FULL_TREBLE_OVERRIDE := true

# Graphics
TARGET_USES_HWC2 := true
TARGET_USES_ION := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so
BOARD_USES_ADRENO := true

# Properties
TARGET_SYSTEM_PROP += $(COMMON_PATH)/system.prop

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

# SELinux
BOARD_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy

# Inherit the proprietary blobs shared by the family
-include vendor/samsung/msm8953-common/BoardConfigVendor.mk

# Audio: Android 10 supports only the XML policy (vendor ships audio_policy_configuration.xml)
USE_XML_AUDIO_POLICY_CONF := 1
