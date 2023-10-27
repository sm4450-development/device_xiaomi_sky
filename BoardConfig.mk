DEVICE_PATH := device/xiaomi/sky

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a76

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot \
    vendor_dlkm

# Assert
TARGET_OTA_ASSERT_DEVICE := sky,skyin

# Bootloader
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt

# Build
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES  := true
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DEVICE_PATH)/configs/hidl/device_framework_compatibility_matrix.xml
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/hidl/manifest.xml
ODM_MANIFEST_SKUS += sky
ODM_MANIFEST_SKY_FILES := $(DEVICE_PATH)/configs/hidl/manifest_nfc.xml

# Kernel
BOARD_KERNEL_PAGESIZE := 4096
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
TARGET_HAS_GENERIC_KERNEL_HEADERS := true
BOARD_DTB_SIZE := 4465212
BOARD_DTB_OFFSET := 0x01F00000
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)

BOARD_KERNEL_CMDLINE := \
    disable_dma32=on \
    mtdoops.fingerprint=$(AOSPA_VERSION) \
    swinfo.fingerprint=$(AOSPA_VERSION)

BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.init_fatal_reboot_target=recovery \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3

# Partitions
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x06000000
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 0x1700000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x06400000
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_VENDOR_DLKMIMAGE := true

BOARD_SUPER_PARTITION_SIZE := 6979321856
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_ext vendor vendor_dlkm
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 6975127552 # (BOARD_SUPER_PARTITION_SIZE - 4MB overhead)

$(foreach p, $(call to-upper, $(BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval BOARD_$(p)IMAGE_PARTITION_RESERVED_SIZE := 104857600) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 104
TARGET_USERIMAGES_USE_F2FS := true

SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

# Screen density
TARGET_SCREEN_DENSITY := 420

# Security patch level
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
#SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# Vendor API
BOARD_API_LEVEL := 31
BOARD_SHIPPING_API_LEVEL := $(BOARD_API_LEVEL)

# Wi-Fi
CONFIG_ACS := true

# Vibrator
SOONG_CONFIG_NAMESPACES += XIAOMI_VIBRATOR
SOONG_CONFIG_XIAOMI_VIBRATOR := USE_EFFECT_STREAM
SOONG_CONFIG_XIAOMI_VIBRATOR_USE_EFFECT_STREAM := true
