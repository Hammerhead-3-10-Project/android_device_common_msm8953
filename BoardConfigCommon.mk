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

# Native ARM64 framework, with ARM32 compatibility for stock Samsung services.
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_VARIANT_RUNTIME := cortex-a53
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msm8953
TARGET_NO_BOOTLOADER := true

# Platform (vendor/aosp maps msm8953 to QCOM_HARDWARE_VARIANT := msm8996, UM 3.18 family)
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

# Treble: the vendor is Android 10 (VNDK 29). Regular (strict) VNDK: the vendor gets its VNDK libraries from the
# com.android.vndk.v29 APEX (PRODUCT_EXTRA_VNDK_VERSIONS in msm8953.mk), not from the Android 11 system ones.
BOARD_VNDK_VERSION := current
PRODUCT_FULL_TREBLE_OVERRIDE := true

# Graphics
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_ION := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
# Use the Android 10 RenderScript CPU path; no compatible Adreno RS64 driver is installed.
OVERRIDE_RS_DRIVER :=
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
