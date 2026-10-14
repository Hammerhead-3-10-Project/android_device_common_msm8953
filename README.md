# device/samsung/msm8953-common — Samsung Snapdragon 450 (msm8953) family, LineageOS 17.1

Shared configuration for Samsung phones with the msm8953/SDM450 SoC running with their **stock Android 10 vendor**
(system-only Lineage build, Treble). Currently used by: `a6plte` (Galaxy A6+ SM-A605FN).

- `BoardConfigCommon.mk`: arch (32-bit userspace on an arm64 kernel), platform, boot header, filesystems,
  system-as-root, VNDK, graphics. Devices include it and add partition sizes, kernel image, density, VINTF files.
- `msm8953.mk`: soong namespaces, Samsung hardware, `PRODUCT_SHIPPING_API_LEVEL 26`, proprietary libs.
- `proprietary-files.txt`: the Samsung/Qualcomm system libraries the stock vendor needs (`extract-files.sh`, called from the
  device tree, writes `vendor/samsung/msm8953-common`).
- `system.prop`: dalvik/graphics defaults identical to stock.
- `sepolicy/`: shared SELinux additions (empty for now).

To add a device: create `device/samsung/<codename>` with a thin `BoardConfig.mk` (`include device/samsung/msm8953-common/
BoardConfigCommon.mk`), a product makefile inheriting `msm8953.mk`, its own VINTF manifest and, if needed, its own
`proprietary-files.txt`; then add the codename in `Android.mk` and `write_headers` of `setup-makefiles.sh`.
