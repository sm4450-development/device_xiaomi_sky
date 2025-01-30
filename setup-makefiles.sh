#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=sky
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
	"device/xiaomi/sky",
	"hardware/xiaomi",
        "hardware/qcom/display",
        "hardware/qcom/display/gralloc",
        "hardware/qcom/display/libdebug",
        "vendor/qcom/common/vendor/adreno-s",
        "vendor/qcom/common/vendor/display/5.10",
        "vendor/qcom/common/vendor/media",
        "vendor/qcom/common/vendor/perf",
        "vendor/qcom/common/vendor/wlan",
        "vendor/qcom/opensource/agm",
EOF
}
function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi
    case "$1" in
        audio.primary.parrot | \
        libsdm-disp-vndapis | \
        libsdmextension | \
	libqc2filter | \
	libvideoutils | \
	vendor.display.color* | \
	vendor.display.postproc@1.0 | \
	vendor.qti.qspmhal@1.0)
            echo "$1_sky"
            ;;
        com.qualcomm.qti.dpm.api@1.0 | \
            com.qualcomm.qti.imscmservice* | \
            com.qualcomm.qti.uceservice* | \
	    com.fingerprints.extension* | \
            vendor.qti.data.* | \
            vendor.qti.diaghal@1.0 | \
            vendor.qti.hardware.data.* | \
            vendor.qti.hardware.dpmservice* |\
            vendor.qti.hardware.embmssl* | \
            vendor.qti.hardware.limits* | \
            vendor.qti.hardware.ListenSoundModel@1.0 | \
            vendor.qti.hardware.mwqemadapter@1.0 | \
            vendor.qti.hardware.qccsyshal* | \
            vendor.qti.hardware.qccvndhal@1.0 | \
            vendor.qti.hardware.qxr-V1-ndk_platform | \
            vendor.qti.hardware.radio.* | \
            vendor.qti.hardware.slmadapter@1.0 | \
            vendor.qti.hardware.wifidisplaysession@1.0 | \
            vendor.qti.imsrtpservice@3.0 | \
            vendor.qti.ims.* | \
            vendor.qti.latency* | \
            vendor.xiaomi.hardware.mtdservice@1.0 | \
	    vendor.xiaomi.hardware.mlipay* | \
	    vendor.qti.hardware.camera.postproc@1.0 | \
	    android.hardware.soundtrigger* | \
	    vendor.qti.hardware.pal@1.0 | \
            vendor.xiaomi.hardware.displayfeature@1.0)
            echo "$1_vendor"
            ;;
        libgrpc++_unsecure)
            echo "$1_prebuilt"
            ;;
        libwpa_client)
            # Android.mk only packages
            ;;
        *)
            return 1
            ;;
    esac
}
function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt"

# Finish
write_footers
