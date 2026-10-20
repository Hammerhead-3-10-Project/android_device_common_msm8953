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

# The vendor runs on the VNDK of the build (ro.vndk.version=30, BOARD_VNDK_VERSION := current), like the other Android 11
# trees that keep an Android 10 vendor (xiaomi sdm439): the stock ro.vndk.version=29 is not copied into the vendor.

# (Pixel Experience has no hardware/samsung: no Samsung-specific HAL/app is built from source)

# Compressed RAM swap: the stock kernel used Samsung vnswap, this tree uses zram (rootdir/etc/fstab.zram)
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/etc/fstab.zram:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.zram \
    $(COMMON_PATH)/rootdir/etc/init.msm8953.zram.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.msm8953.zram.rc \
    $(COMMON_PATH)/rootdir/etc/init.msm8953.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.msm8953.usb.rc \
    $(COMMON_PATH)/rootdir/etc/permissions/privapp-permissions-a6plte-odm.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-a6plte-odm.xml \
    $(COMMON_PATH)/rootdir/etc/init.msm8953.tee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.msm8953.tee.rc \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Vendor-side HALs already shipped by the stock vendor partition are NOT rebuilt here.

# Proprietary system libraries required by the stock vendor HALs
$(call inherit-product, vendor/samsung/msm8953-common/msm8953-common-vendor.mk)

# The ARM64 GApps SetupWizard is selected by vendor/gapps; do not override it
# with SetupWizardPrebuiltArm in the ARM64 product.

# NFC framework and tag handling; the Samsung NFC HAL is supplied by vendor.
PRODUCT_PACKAGES += \
    NfcNci \
    Tag

# Platform/source implementations needed by the ARM64 clients. Existing ARM32
# Samsung hardware services and their stock libraries remain in the vendor overlay.
PRODUCT_PACKAGES += \
    libion \
    libtinyalsa \
    libtinycompress \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.renderscript@1.0-impl \
    libRS_internal \
    libRSDriver \
    libRSCpuRef


# Build native media wrappers/helpers against Android 10. The stock OMX service
# and ARM32 codecs remain in place; donor Vdec/Venc need a separate QSEE/VIDC audit.
PRODUCT_PACKAGES += \
    libOmxCore \
    libmm-omxcore \
    libstagefrighthw \
    libc2dcolorconvert \
    libhypv_intercept

# Runtime support for retained Samsung ARM32 HALs and utilities.
$(call inherit-product, $(COMMON_PATH)/runtime32.mk)

# The 64-bit graphics stack uses the Android 11 donor gralloc/composer (renamed *_a11 so
# they cannot collide with the CAF source modules). hw_get_module tries this variant first
# and falls back to ro.board.platform, so the 32-bit stock HALs keep loading *.msm8953.
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.gralloc=a11 \
    ro.hardware.hwcomposer=a11

# Android 11 dropped libhidltransport and libhwbinder (empty stubs, merged into libhidlbase/libbinder), but the stock
# Android 10 vendor services still list them in DT_NEEDED and, with the strict VNDK, they are looked up in /vendor.
PRODUCT_PACKAGES += \
    libhidltransport.vendor:32 \
    libhidltransport.vendor:64 \
    libhwbinder.vendor:32 \
    libhwbinder.vendor:64

# Libraries the Android 10 VNDK had and Android 11 no longer offers to the vendor (same soname as the stock vendor
# expects). They are vendor_available in Android 11 and some are already installed by other modules, so they are requested
# as 32-bit vendor packages (a second copy rule fails in Kati with 'overriding commands'); the retained stock services are 32-bit.
PRODUCT_PACKAGES += libprotobuf-cpp-lite.vendor:32 libprotobuf-cpp-full.vendor:32
# libsoftkeymasterdevice, libpuresoftkeymasterdevice, libkeymaster_messages and libkeymaster_portable are the Android 10
# builds copied by vendor/samsung/a6plte/arm64/arm64-vendor.mk (the stock keymaster HAL needs the A10 ABI).
