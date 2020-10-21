# config.mk
#
# Product-specific compile-time definitions.
#
# TODO(b/124534788): Temporarily allow eng and debug LOCAL_MODULE_TAGS

BOARD_ABL_SIMPLE := true

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
TARGET_NO_KERNEL := false

-include $(QCPATH)/common/lahaina/BoardConfigVendor.mk

USE_OPENGL_RENDERER := true

# TODO: Enable it back when we have a path forward
# Disable generation of dtbo.img
BOARD_KERNEL_SEPARATED_DTBO := false

# Path to prebuilt dtbo.img
BOARD_PREBUILT_DTBOIMAGE := device/qcom/taro-kernel/dtbo.img
# Path to prebuilt .dtb's used for dtb.img generation
BOARD_PREBUILT_DTBIMAGE_DIR := device/qcom/taro-kernel

# Store sanitized version of MSM headers which are needed in
# addition to bionic headers in below path. These headers get
# added to include path by default
TARGET_BOARD_KERNEL_HEADERS := device/qcom/taro-kernel/kernel-headers

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

#BOARD_VENDOR_KERNEL_MODULES := \
#    $(KERNEL_MODULES_OUT)/audio_apr.ko \
#    $(KERNEL_MODULES_OUT)/audio_q6_pdr.ko \
#    $(KERNEL_MODULES_OUT)/audio_q6_notifier.ko \
#    $(KERNEL_MODULES_OUT)/audio_adsp_loader.ko \
#    $(KERNEL_MODULES_OUT)/audio_q6.ko \
#    $(KERNEL_MODULES_OUT)/audio_usf.ko \
#    $(KERNEL_MODULES_OUT)/audio_pinctrl_wcd.ko \
#    $(KERNEL_MODULES_OUT)/audio_pinctrl_lpi.ko \
#    $(KERNEL_MODULES_OUT)/audio_swr.ko \
#    $(KERNEL_MODULES_OUT)/audio_wcd_core.ko \
#    $(KERNEL_MODULES_OUT)/audio_swr_ctrl.ko \
#    $(KERNEL_MODULES_OUT)/audio_wsa881x.ko \
#    $(KERNEL_MODULES_OUT)/audio_platform.ko \
#    $(KERNEL_MODULES_OUT)/audio_hdmi.ko \
#    $(KERNEL_MODULES_OUT)/audio_stub.ko \
#    $(KERNEL_MODULES_OUT)/audio_wcd9xxx.ko \
#    $(KERNEL_MODULES_OUT)/audio_mbhc.ko \
#    $(KERNEL_MODULES_OUT)/audio_wcd938x.ko \
#    $(KERNEL_MODULES_OUT)/audio_wcd938x_slave.ko \
#    $(KERNEL_MODULES_OUT)/audio_bolero_cdc.ko \
#    $(KERNEL_MODULES_OUT)/audio_wsa_macro.ko \
#    $(KERNEL_MODULES_OUT)/audio_va_macro.ko \
#    $(KERNEL_MODULES_OUT)/audio_rx_macro.ko \
#    $(KERNEL_MODULES_OUT)/audio_tx_macro.ko \
#    $(KERNEL_MODULES_OUT)/audio_native.ko \
#    $(KERNEL_MODULES_OUT)/audio_machine_lahaina.ko \
#    $(KERNEL_MODULES_OUT)/audio_snd_event.ko \
#    $(KERNEL_MODULES_OUT)/qca_cld3_wlan.ko \
#    $(KERNEL_MODULES_OUT)/wil6210.ko \
#    $(KERNEL_MODULES_OUT)/msm_11ad_proxy.ko \
#    $(KERNEL_MODULES_OUT)/br_netfilter.ko \
#    $(KERNEL_MODULES_OUT)/gspca_main.ko \
#    $(KERNEL_MODULES_OUT)/lcd.ko \
#    $(KERNEL_MODULES_OUT)/llcc_perfmon.ko \

# check for for userdebug and eng build variants and install the appropriate modules
#ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
#ifeq (,$(findstring perf_defconfig, $(KERNEL_DEFCONFIG)))
#BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_MODULES_OUT)/atomic64_test.ko
#BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_MODULES_OUT)/lkdtm.ko
#BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_MODULES_OUT)/locktorture.ko
#BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_MODULES_OUT)/rcutorture.ko
#BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_MODULES_OUT)/test_user_copy.ko
#BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_MODULES_OUT)/torture.ko
#endif
#endif


ifeq (,$(findstring -qgki-debug_defconfig,$(KERNEL_DEFCONFIG)))
$(warning #### GKI config ####)
VENDOR_RAMDISK_KERNEL_MODULES := proxy-consumer.ko \
				rpmh-regulator.ko \
				refgen.ko \
				stub-regulator.ko \
                                clk-dummy.ko \
				clk-qcom.ko \
				clk-rpmh.ko \
				gcc-lahaina.ko \
				gcc-shima.ko \
				qnoc-lahaina.ko \
				qnoc-shima.ko \
				cmd-db.ko \
				qcom_rpmh.ko \
				rpmhpd.ko \
				icc-bcm-voter.ko \
				icc-rpmh.ko \
				pinctrl-msm.ko \
				pinctrl-lahaina.ko \
				pinctrl-shima.ko \
				_qcom_scm.ko \
				secure_buffer.ko \
				iommu-logger.ko \
				qcom-arm-smmu-mod.ko \
				phy-qcom-ufs.ko \
				phy-qcom-ufs-qrbtc-sdm845.ko \
				phy-qcom-ufs-qmp-v4-lahaina.ko\
				ufshcd-crypto-qti.ko \
				crypto-qti-common.ko \
				crypto-qti-hwkm.ko \
				hwkm.ko \
				ufs-qcom.ko \
				qbt_handler.ko \
				qcom_watchdog.ko \
				qcom-pdc.ko \
				qpnp-power-on.ko \
				msm-poweroff.ko \
				memory_dump_v2.ko
else
$(warning #### QGKI config ####)
endif

BOARD_DO_NOT_STRIP_VENDOR_MODULES := true
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API := true

BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 loop.max_part=7 cgroup.memory=nokmem,nosocket pcie_ports=compat loop.max_part=7

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
