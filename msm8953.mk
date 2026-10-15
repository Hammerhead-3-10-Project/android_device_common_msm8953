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

# Vendor-side HALs already shipped by the stock vendor partition are NOT rebuilt here.

# Proprietary system libraries required by the stock vendor HALs
$(call inherit-product, vendor/samsung/msm8953-common/msm8953-common-vendor.mk)
