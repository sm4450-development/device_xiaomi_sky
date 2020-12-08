# config.mk
#
# Product-specific compile-time definitions.
#
# TODO(b/124534788): Temporarily allow eng and debug LOCAL_MODULE_TAGS

BOARD_SYSTEMSDK_VERSIONS := 30

TARGET_BOARD_PLATFORM := taro
TARGET_BOOTLOADER_BOARD_NAME := taro

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := kryo300

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a75

TARGET_NO_BOOTLOADER := false
TARGET_USES_UEFI := true
TARGET_USES_REMOTEPROC := true
TARGET_NO_KERNEL := false

-include $(QCPATH)/common/lahaina/BoardConfigVendor.mk

USE_OPENGL_RENDERER := true

# TODO: Enable it back when we have a path forward
# Disable generation of dtbo.img
BOARD_KERNEL_SEPARATED_DTBO := false

### Dynamic partition Handling
# Define the Dynamic Partition sizes and groups.
ifeq ($(ENABLE_AB), true)
    ifeq ($(ENABLE_VIRTUAL_AB), true)
        BOARD_SUPER_PARTITION_SIZE := 6442450944
    else
        BOARD_SUPER_PARTITION_SIZE := 12884901888
    endif
else
        BOARD_SUPER_PARTITION_SIZE := 6442450944
endif
ifeq ($(BOARD_KERNEL_SEPARATED_DTBO),true)
    # Enable DTBO for recovery image
    BOARD_INCLUDE_RECOVERY_DTBO := true
endif
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 6438256640
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := vendor odm
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x06400000

TARGET_COPY_OUT_ODM := odm
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
ifeq ($(ENABLE_AB), true)
ifeq ($(BOARD_AVB_ENABLE),true)
AB_OTA_PARTITIONS ?= boot vendor_boot vendor odm dtbo vbmeta
else
AB_OTA_PARTITIONS ?= boot vendor_boot vendor odm dtbo
endif
endif
BOARD_EXT4_SHARE_DUP_BLOCKS := true

ifeq ($(ENABLE_AB), true)
# Defines for enabling A/B builds
AB_OTA_UPDATER := true
TARGET_RECOVERY_FSTAB := device/qcom/taro/recovery.fstab
else
TARGET_RECOVERY_FSTAB := device/qcom/taro/recovery_non_AB.fstab
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif

ifeq ($(BOARD_AVB_ENABLE), true)
    BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
    BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
    BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
    BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
endif


BOARD_USES_METADATA_PARTITION := true

#Enable compilation of oem-extensions to recovery
#These need to be explicitly
ifneq ($(AB_OTA_UPDATER),true)
    TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm
endif

TARGET_COPY_OUT_VENDOR := vendor
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x06000000
BOARD_KERNEL-GKI_BOOTIMAGE_PARTITION_SIZE := $(BOARD_BOOTIMAGE_PARTITION_SIZE)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 0x06000000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 48318382080
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_METADATAIMAGE_PARTITION_SIZE := 16777216
BOARD_DTBOIMG_PARTITION_SIZE := 0x0800000
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

BOARD_DO_NOT_STRIP_VENDOR_MODULES := true
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API := true

BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom androidboot.memcg=1 video=vfb:640x400,bpp=32,memsize=3072000 androidboot.usbcontroller=a600000.dwc3 firmware_class.path=/vendor/firmware_mnt/image
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_KERNEL_CMDLINE += console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0x0099C000 androidboot.console=ttyMSM0 printk.devkmsg=on
endif

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_USES_UNCOMPRESSED_KERNEL := false

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

BOARD_USES_GENERIC_AUDIO := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_NO_RPC := true

TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
TARGET_INIT_VENDOR_LIB := libinit_msm

#Disable appended dtb.
TARGET_KERNEL_APPEND_DTB := false
# Compile without full kernel source
TARGET_COMPILE_WITH_MSM_KERNEL := false

#Enable dtb in boot image and boot image header version 3 support.
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
ifeq ($(ENABLE_AB), true)
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true
endif
BOARD_BOOT_HEADER_VERSION := 3
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)

#Enable PD locater/notifier
TARGET_PD_SERVICE_ENABLED := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
endif

#Add non-hlos files to ota packages
ADD_RADIO_FILES := true


# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

#flag for qspm compilation
TARGET_USES_QSPM := true

#namespace definition for librecovery_updater
#differentiate legacy 'sg' or 'bsg' framework
SOONG_CONFIG_NAMESPACES += ufsbsg

SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

#namespace definition for perf
SOONG_CONFIG_NAMESPACES += perf
SOONG_CONFIG_perf += ioctl
SOONG_CONFIG_perf_ioctl := true

#-----------------------------------------------------------------
# kernel platform specific
#-----------------------------------------------------------------
PREBUILT_KERNEL_DIR ?= device/qcom/$(TARGET_BOARD_PLATFORM)-kernel
KERNEL_PRODUCT_DIR := kernel_obj

################################################################################
# Path to prebuilt dtbo.img
ifneq (,$(wildcard $(PREBUILT_KERNEL_DIR)/dtbs/))
BOARD_PREBUILT_DTBOIMAGE := $(PREBUILT_KERNEL_DIR)/dtbs/dtbo.img
# Path to prebuilt .dtb's used for dtb.img generation
BOARD_PREBUILT_DTBIMAGE_DIR := $(PREBUILT_KERNEL_DIR)/dtbs/
else
BOARD_PREBUILT_DTBOIMAGE := $(PREBUILT_KERNEL_DIR)/dtbo.img
# Path to prebuilt .dtb's used for dtb.img generation
BOARD_PREBUILT_DTBIMAGE_DIR := $(PREBUILT_KERNEL_DIR)/
endif

################################################################################
# Store sanitized version of MSM headers which are needed in
# addition to bionic headers in below path. These headers get
# added to include path by default
TARGET_BOARD_KERNEL_HEADERS := $(PREBUILT_KERNEL_DIR)/kernel-headers

################################################################################
PRODUCT_COPY_FILES += $(PREBUILT_KERNEL_DIR)/Image:kernel
PRODUCT_COPY_FILES += $(PREBUILT_KERNEL_DIR)/System.map:$(KERNEL_PRODUCT_DIR)/System.map

################################################################################
# $(1): folder inside PREBUILT_KERNEL_DIR (e.g. vendor)
# $(2): Variable to add the prebuilt KOs to (e.g. BOARD_VENDOR_KERNEL_MODULES)
# 1. Find all the modules in the prebuilt kernel directory
# 2. Add them to the BOARD_*_KERNEL_MODULES variable
# 3. Also copy the files to $(PRODUCT_OUT)/dlkm/lib/modules/unstripped for ramdump tools to pick up
define setup-kernel-modules
$(eval $(1)_kernel_modules := $(wildcard $(PREBUILT_KERNEL_DIR)/$(1)/*.ko)) \
$(eval BOARD_$(2)_KERNEL_MODULES += $($(1)_kernel_modules))
endef

$(call setup-kernel-modules,.,VENDOR_RAMDISK)
$(call setup-kernel-modules,vendor_dlkm,VENDOR)

PRODUCT_COPY_FILES+=$(if $(wildcard $(PREBUILT_KERNEL_DIR)/modules.blocklist),$(PREBUILT_KERNEL_DIR)/modules.blocklist:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/modules.blocklist,)
PRODUCT_COPY_FILES+=$(if $(wildcard $(PREBUILT_KERNEL_DIR)/vendor_dlkm/modules.blocklist),$(PREBUILT_KERNEL_DIR)/vendor_dlkm/modules.blocklist:$(if $(filter true,$(BOARD_USES_VENDOR_DLKMIMAGE)),$(TARGET_COPY_OUT_VENDOR_DLKM),$(TARGET_COPY_OUT_VENDOR))/lib/modules/modules.blocklist,)

#-----------------------------------------------------------------
# wlan specific
#-----------------------------------------------------------------
ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
ifeq ($(TARGET_USES_QMAA), true)
ifneq ($(TARGET_USES_QMAA_OVERRIDE_WLAN), true)
include device/qcom/wlan/default/BoardConfigWlan.mk
else
include device/qcom/wlan/lahaina/BoardConfigWlan.mk
endif
else
include device/qcom/wlan/lahaina/BoardConfigWlan.mk
endif
endif

#################################################################################
# This is the End of BoardConfig.mk file.
# Now, Pickup other split Board.mk files:
#################################################################################
# TODO: Relocate the system Board.mk files pickup into qssi lunch, once it is up.
-include $(sort $(wildcard vendor/qcom/defs/board-defs/system/*.mk))
-include $(sort $(wildcard vendor/qcom/defs/board-defs/vendor/*.mk))
#################################################################################

BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_NINJA_USES_ENV_VARS := TEMPORARY_DISABLE_PATH_RESTRICTIONS
BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
BUILD_BROKEN_PREBUILT_ELF_FILES := true

# KEYSTONE(If43215c7f384f24e7adeeabdbbb1790f174b2ec1,b/147756744)
BUILD_BROKEN_NINJA_USES_ENV_VARS += SDCLANG_AE_CONFIG SDCLANG_CONFIG SDCLANG_SA_ENABLE

BUILD_BROKEN_USES_BUILD_HOST_SHARED_LIBRARY := true
BUILD_BROKEN_USES_BUILD_HOST_STATIC_LIBRARY := true
BUILD_BROKEN_USES_BUILD_HOST_EXECUTABLE := true
BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true

include device/qcom/sepolicy_vndr/SEPolicy.mk
