#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Common product configuration for the Samsung msm8953 family.

COMMON_PATH := device/samsung/msm8953-common

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(COMMON_PATH)

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(COMMON_PATH)/overlay

# Treble: the stock vendor (Android 10) is kept, only /system is built from source
PRODUCT_SHIPPING_API_LEVEL := 26

# (Pixel Experience has no hardware/samsung: no Samsung-specific HAL/app is built from source)

# Compressed RAM swap: the stock kernel used Samsung vnswap, this tree uses zram (rootdir/etc/fstab.zram)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/etc/fstab.zram:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.zram \
    $(COMMON_PATH)/rootdir/etc/init.msm8953.zram.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.msm8953.zram.rc \
    $(COMMON_PATH)/rootdir/etc/init.msm8953.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.msm8953.usb.rc \
    $(COMMON_PATH)/rootdir/etc/init.msm8953.tee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.msm8953.tee.rc

# Vendor-side HALs already shipped by the stock vendor partition are NOT rebuilt here.

# Proprietary system libraries required by the stock vendor HALs
$(call inherit-product, vendor/samsung/msm8953-common/msm8953-common-vendor.mk)

# 32-bit Setup Wizard: the one of vendor/gapps is arm64-only and is rejected by the 32-bit userspace (gapps/Android.bp)
PRODUCT_PACKAGES += \
    SetupWizardPrebuiltArm
