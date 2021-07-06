BUILD_BROKEN_DUP_RULES := true

RELAX_USES_LIBRARY_CHECK := true

TARGET_BOARD_PLATFORM := taro

# Default Android A/B configuration
ENABLE_AB ?= true

ENABLE_VIRTUAL_AB := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Enable debugfs restrictions
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

#Enable vm support
TARGET_ENABLE_VM_SUPPORT := true

# true: earlycon and console enabled
# false: console explicitly disabled
# <empty>: default from kernel
TARGET_CONSOLE_ENABLED ?=

$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Set GRF/Vendor freeze properties
BOARD_SHIPPING_API_LEVEL := 31
BOARD_API_LEVEL := 31

# Set SoC manufacturer property
PRODUCT_PROPERTY_OVERRIDES += \
    ro.soc.manufacturer=QTI

# For QSSI builds, we should skip building the system image. Instead we build the
# "non-system" images (that we support).

PRODUCT_BUILD_SYSTEM_IMAGE := false
PRODUCT_BUILD_SYSTEM_OTHER_IMAGE := false
PRODUCT_BUILD_VENDOR_IMAGE := true
PRODUCT_BUILD_VENDOR_DLKM_IMAGE := true
PRODUCT_BUILD_PRODUCT_IMAGE := false
PRODUCT_BUILD_SYSTEM_EXT_IMAGE := false
PRODUCT_BUILD_ODM_IMAGE := false
ifeq ($(ENABLE_AB), true)
PRODUCT_BUILD_CACHE_IMAGE := false
else
PRODUCT_BUILD_CACHE_IMAGE := true
endif
PRODUCT_BUILD_RAMDISK_IMAGE := true
PRODUCT_BUILD_RECOVERY_IMAGE := true
PRODUCT_BUILD_USERDATA_IMAGE := true

# Also, since we're going to skip building the system image, we also skip
# building the OTA package. We'll build this at a later step.
TARGET_SKIP_OTA_PACKAGE := true

# Enable AVB 2.0
BOARD_AVB_ENABLE := true

# Disable verified boot checks in abl if AVB is not enabled
ifeq ($(BOARD_AVB_ENABLE), true)
BOARD_ABL_SIMPLE := false
else
BOARD_ABL_SIMPLE := true
endif

# Set SYSTEMEXT_SEPARATE_PARTITION_ENABLE if was not already set (set earlier via build.sh).
SYSTEMEXT_SEPARATE_PARTITION_ENABLE := true

###########
#QMAA flags starts
###########
#QMAA global flag for modular architecture
#true means QMAA is enabled for system
#false means QMAA is disabled for system

TARGET_USES_QMAA := false

#QMAA flag which is set to incorporate any generic dependencies
#required for the boot to UI flow in a QMAA enabled target.
#Set to false when all target level depenencies are met with
#actual full blown implementations.
TARGET_USES_QMAA_RECOMMENDED_BOOT_CONFIG := false

#QMAA tech team flag to override global QMAA per tech team
#true means overriding global QMAA for this tech area
#false means using global, no override
TARGET_USES_QMAA_OVERRIDE_RPMB := true
TARGET_USES_QMAA_OVERRIDE_DISPLAY := true
TARGET_USES_QMAA_OVERRIDE_AUDIO   := true
TARGET_USES_QMAA_OVERRIDE_VIDEO   := true
TARGET_USES_QMAA_OVERRIDE_CAMERA  := true
TARGET_USES_QMAA_OVERRIDE_GFX     := true
TARGET_USES_QMAA_OVERRIDE_WFD     := true
TARGET_USES_QMAA_OVERRIDE_GPS     := true
TARGET_USES_QMAA_OVERRIDE_ANDROID_RECOVERY := true
TARGET_USES_QMAA_OVERRIDE_ANDROID_CORE := true
TARGET_USES_QMAA_OVERRIDE_WLAN    := true
TARGET_USES_QMAA_OVERRIDE_DPM  := true
TARGET_USES_QMAA_OVERRIDE_BLUETOOTH   := true
TARGET_USES_QMAA_OVERRIDE_FM  := true
TARGET_USES_QMAA_OVERRIDE_CVP  := true
TARGET_USES_QMAA_OVERRIDE_FASTCV  := true
TARGET_USES_QMAA_OVERRIDE_SCVE  := true
TARGET_USES_QMAA_OVERRIDE_OPENVX  := true
TARGET_USES_QMAA_OVERRIDE_DIAG := true
TARGET_USES_QMAA_OVERRIDE_FTM := true
TARGET_USES_QMAA_OVERRIDE_DATA := true
TARGET_USES_QMAA_OVERRIDE_DATA_NET := true
TARGET_USES_QMAA_OVERRIDE_MSM_BUS_MODULE := true
TARGET_USES_QMAA_OVERRIDE_KERNEL_TESTS_INTERNAL := true
TARGET_USES_QMAA_OVERRIDE_MSMIRQBALANCE := true
TARGET_USES_QMAA_OVERRIDE_VIBRATOR := true
TARGET_USES_QMAA_OVERRIDE_DRM     := true
TARGET_USES_QMAA_OVERRIDE_KMGK := true
TARGET_USES_QMAA_OVERRIDE_VPP := true
TARGET_USES_QMAA_OVERRIDE_GP := true
TARGET_USES_QMAA_OVERRIDE_BIOMETRICS := true
TARGET_USES_QMAA_OVERRIDE_SPCOM_UTEST := true
TARGET_USES_QMAA_OVERRIDE_PERF := true
TARGET_USES_QMAA_OVERRIDE_SENSORS := true
TARGET_USES_QMAA_OVERRIDE_SYNX := true
TARGET_USES_QMAA_OVERRIDE_SECUREMSM_TESTS := true
TARGET_USES_QMAA_OVERRIDE_SOTER := true
TARGET_USES_QMAA_OVERRIDE_REMOTE_EFS := true
TARGET_USES_QMAA_OVERRIDE_TFTP := true
TARGET_USES_QMAA_OVERRIDE_EID := true

#Full QMAA HAL List
QMAA_HAL_LIST := audio video camera display sensors gps

ifeq ($(TARGET_USES_QMAA), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.confqmaa=true
endif

###########
#QMAA flags ends

#Suppot to compile recovery without msm headers
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

# Enable USB detection in QMAA mode
ifeq ($(TARGET_USES_QMAA),true)
ifeq ($(TARGET_USES_QMAA_RECOMMENDED_BOOT_CONFIG),true)
PRODUCT_PACKAGES += init.qti.usb.qmaa.rc
# Enable USB in adb-only configuration
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.usb.config=adb
endif
endif

CLEAN_UP_JAVA_IN_VENDOR := warning

JAVA_IN_VENDOR_SOONG_WHITE_LIST :=\
CuttlefishService\
pasrservice\
QFingerprintService\
QFPCalibration\
VendorPrivAppPermissionTest\

JAVA_IN_VENDOR_MAKE_WHITE_LIST :=\
AEye\
FDA\
SnapdragonCamera\

SHIPPING_API_LEVEL := 31
PRODUCT_SHIPPING_API_LEVEL := 31

# Set kernel version and ion flags
TARGET_KERNEL_VERSION := 5.10
TARGET_USES_NEW_ION := true

# Disable DLKM generation until build support is available
TARGET_KERNEL_DLKM_DISABLE := false

#####Dynamic partition Handling
###
#### Turning this flag to TRUE will enable dynamic partition/super image creation.
PRODUCT_BUILD_ODM_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_PACKAGES += fastbootd
# Add default implementation of fastboot HAL.
PRODUCT_PACKAGES += android.hardware.fastboot@1.0-impl-mock

ifeq ($(ENABLE_AB),true)
ifeq ($(SYSTEMEXT_SEPARATE_PARTITION_ENABLE), true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom
else
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab_noSysext.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom
endif
else
ifeq ($(SYSTEMEXT_SEPARATE_PARTITION_ENABLE), true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab_non_AB.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom
else
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab_non_AB_noSysext.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom
endif
endif
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

$(call inherit-product, build/make/target/product/gsi_keys.mk)

BOARD_HAVE_BLUETOOTH := false
BOARD_HAVE_QCOM_FM := false

# privapp-permissions whitelisting (To Fix CTS :privappPermissionsMustBeEnforced)
PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce

TARGET_DEFINES_DALVIK_HEAP := true
$(call inherit-product, device/qcom/vendor-common/common64.mk)
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# beluga settings
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.beluga.p=0x3 \
    ro.vendor.beluga.c=0x4800 \
    ro.vendor.beluga.s=0x900 \
    ro.vendor.beluga.t=0x240

###########
# Target naming
PRODUCT_NAME := taro
PRODUCT_DEVICE := taro
PRODUCT_BRAND := qti
PRODUCT_MODEL := Taro for arm64

#----------------------------------------------------------------------
# wlan specific
#----------------------------------------------------------------------
ifeq ($(TARGET_USES_QMAA), true)
ifneq ($(TARGET_USES_QMAA_OVERRIDE_WLAN), true)
include device/qcom/wlan/default/wlan.mk
else
include device/qcom/wlan/taro/wlan.mk
endif
else
include device/qcom/wlan/taro/wlan.mk
endif

#----------------------------------------------------------------------
# perf specific
#----------------------------------------------------------------------
ifeq ($(TARGET_USES_QMAA), true)
    ifneq ($(TARGET_USES_QMAA_OVERRIDE_PERF), true)
        TARGET_DISABLE_PERF_OPTIMIZATIONS := true
    else
        TARGET_DISABLE_PERF_OPTIMIZATIONS := false
    endif
else
    TARGET_DISABLE_PERF_OPTIMIZATIONS := false
endif
# /* Disable perf opts */



TARGET_USES_QCOM_BSP := false

# RRO configuration
TARGET_USES_RRO := true

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

###########
# Target configurations

QCOM_BOARD_PLATFORMS += taro

TARGET_USES_QSSI := true

###QMAA Indicator Start###

#Full QMAA HAL List
QMAA_HAL_LIST :=

#Indicator for each enabled QMAA HAL for this target. Each tech team locally verified their QMAA HAL and ensure code is updated/merged, then add their HAL module name to QMAA_ENABLED_HAL_MODULES as an QMAA enabling completion indicator
QMAA_ENABLED_HAL_MODULES :=
QMAA_ENABLED_HAL_MODULES += sensors

###QMAA Indicator End###

#Default vendor image configuration
ENABLE_VENDOR_IMAGE := true

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

# Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES += fs_config_files
PRODUCT_PACKAGES += gpio-keys.kl

ifeq ($(ENABLE_AB), true)
# A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    android.hardware.boot@1.1-impl-qti \
    android.hardware.boot@1.1-impl-qti.recovery \
    android.hardware.boot@1.1-service

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload

# Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl

PRODUCT_PACKAGES += \
  update_engine_sideload
endif

# Enable incremental fs
PRODUCT_PROPERTY_OVERRIDES += \
    ro.incremental.enable=yes

PRODUCT_HOST_PACKAGES += \
    configstore_xmlparser

# QRTR related packages
PRODUCT_PACKAGES += qrtr-ns
PRODUCT_PACKAGES += qrtr-lookup
PRODUCT_PACKAGES += libqrtr

# diag-router
TARGET_HAS_DIAG_ROUTER := true

# f2fs utilities
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# Userdata checkpoint
PRODUCT_PACKAGES += \
    checkpoint_gc

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += camx.device@3.5-impl
PRODUCT_PACKAGES += camx.device@3.4-impl
PRODUCT_PACKAGES += camx.device@3.3-impl
PRODUCT_PACKAGES += camx.device@3.2-impl
PRODUCT_PACKAGES += camx.provider@2.4-impl
PRODUCT_PACKAGES += camx.provider@2.6-legacy
# Enable binderized camera HAL
PRODUCT_PACKAGES += vendor.qti.camera.provider@2.6-service_64

# Macro allows Camera module to use new service
QTI_CAMERA_PROVIDER_SERVICE := true

DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/taro/framework_manifest.xml

# Enable compilation of image_generation_tool
TARGET_USES_IMAGE_GEN_TOOL := true

# QCV allows multiple chipsets to be supported on a single vendor.
# Add vintf device manifests for chipsets in taro QCV family below.
TARGET_USES_QCV := true
DEVICE_MANIFEST_SKUS := taro
DEVICE_MANIFEST_TARO_FILES := device/qcom/taro/manifest_taro.xml

DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml

#Audio DLKM
#AUDIO_DLKM := audio_apr.ko
#AUDIO_DLKM += audio_q6_pdr.ko
#AUDIO_DLKM += audio_q6_notifier.ko
#AUDIO_DLKM += audio_adsp_loader.ko
#AUDIO_DLKM += audio_q6.ko
#AUDIO_DLKM += audio_usf.ko
#AUDIO_DLKM += audio_pinctrl_wcd.ko
#AUDIO_DLKM += audio_swr.ko
#AUDIO_DLKM += audio_wcd_core.ko
#AUDIO_DLKM += audio_swr_ctrl.ko
#AUDIO_DLKM += audio_wsa881x.ko
#AUDIO_DLKM += audio_platform.ko
#AUDIO_DLKM += audio_hdmi.ko
#AUDIO_DLKM += audio_stub.ko
#AUDIO_DLKM += audio_wcd9xxx.ko
#AUDIO_DLKM += audio_mbhc.ko
#AUDIO_DLKM += audio_native.ko
#AUDIO_DLKM += audio_wcd938x.ko
#AUDIO_DLKM += audio_wcd938x_slave.ko
#AUDIO_DLKM += audio_bolero_cdc.ko
#AUDIO_DLKM += audio_wsa_macro.ko
#AUDIO_DLKM += audio_va_macro.ko
#AUDIO_DLKM += audio_rx_macro.ko
#AUDIO_DLKM += audio_tx_macro.ko
#AUDIO_DLKM += audio_machine_lahaina.ko
#AUDIO_DLKM += audio_snd_event.ko

PRODUCT_PACKAGES += $(AUDIO_DLKM)

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules



USE_LIB_PROCESS_GROUP := true

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml


#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true
BOARD_SYSTEMSDK_VERSIONS := 31

DISABLED_VSDK_SNAPSHOTS_LIST := $(subst $(comma),$(space),$(DISABLED_VSDK_SNAPSHOTS))

ifeq (true,$(BUILDING_WITH_VSDK))
    ALLOW_MISSING_DEPENDENCIES := true
    TARGET_SKIP_CURRENT_VNDK := true

    ifneq (,$(filter vendor,$(DISABLED_VSDK_SNAPSHOTS_LIST)))
        # Vendor snapshot is disabled with VSDK
        BOARD_VNDK_VERSION := current
    else
        BOARD_VNDK_VERSION := 31
    endif

    ifneq (,$(filter recovery,$(DISABLED_VSDK_SNAPSHOTS_LIST)))
        # Recovery snapshot is disabled with VSDK
        RECOVERY_SNAPSHOT_VERSION := current
    else
        RECOVERY_SNAPSHOT_VERSION := 31
    endif

    ifneq (,$(filter ramdisk,$(DISABLED_VSDK_SNAPSHOTS_LIST)))
        # Ramdisk snapshot is disabled with VSDK
        RAMDISK_SNAPSHOT_VERSION := current
    else
        RAMDISK_SNAPSHOT_VERSION := 31
    endif
else
    BOARD_VNDK_VERSION := current
    RECOVERY_SNAPSHOT_VERSION := current
    RAMDISK_SNAPSHOT_VERSION := current
endif

$(warning "BOARD_VNDK_VERSION = $(BOARD_VNDK_VERSION), RECOVERY_SNAPSHOT_VERSION=$(RECOVERY_SNAPSHOT_VERSION), RAMDISK_SNAPSHOT_VERSION=$(RAMDISK_SNAPSHOT_VERSION)")

TARGET_MOUNT_POINTS_SYMLINKS := false

# FaceAuth feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.biometrics.face.xml \

# Fingerprint feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \

# system prop for enabling QFS (QTI Fingerprint Solution)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.qfp=true
#target specific runtime prop for qspm
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.qspm.enable=true
#ANT+ stack
PRODUCT_PACKAGES += \
    libvolumelistener

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

#Charger
ifeq ($(ENABLE_AB),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/charger_fw_fstab.qti:$(TARGET_COPY_OUT_VENDOR)/etc/charger_fw_fstab.qti
else
PRODUCT_COPY_FILES += $(LOCAL_PATH)/charger_fw_fstab_non_AB.qti:$(TARGET_COPY_OUT_VENDOR)/etc/charger_fw_fstab.qti
endif

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext

PRODUCT_ENABLE_QESDK := true

# Vendor property to enable advanced network scanning
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.enableadvancedscan=true

PRODUCT_COPY_FILES += \
    device/qcom/taro/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# ODM ueventd.rc
# - only for use with VM support right now
ifeq ($(TARGET_ENABLE_VM_SUPPORT),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/ueventd-odm.rc:$(TARGET_COPY_OUT_ODM)/ueventd.rc
PRODUCT_PACKAGES += vmmgr vmmgr.rc vmmgr.conf
endif


##Armv9-Tests##
PRODUCT_PACKAGES_DEBUG += bti_test_prebuilt \
                          pac_test \
                          mte_tests
##Armv9-Tests##

# Mediaserver 64 Bit enable
PRODUCT_PROPERTY_OVERRIDES += \
     ro.mediaserver.64b.enable=true

###################################################################################
# This is the End of target.mk file.
# Now, Pickup other split product.mk files:
###################################################################################
# TODO: Relocate the system product.mk files pickup into qssi lunch, once it is up.
$(foreach sdefs, $(sort $(wildcard vendor/qcom/defs/product-defs/system/*.mk)), \
    $(call inherit-product, $(sdefs)))
$(foreach vdefs, $(sort $(wildcard vendor/qcom/defs/product-defs/vendor/*.mk)), \
    $(call inherit-product, $(vdefs)))
###################################################################################
