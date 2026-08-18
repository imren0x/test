#!/bin/bash

if [ -z "$ANDROID_BUILD_TOP" ]; then
    ANDROID_BUILD_TOP="$(pwd)"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEN_CHAIN="${SCRIPT_DIR}/gen_chain"

CHECK="$(echo $1 | grep -q check && echo 1)"
GERRIT_URL="https://review.lineageos.org"

function repopick() {
    if [[ "$CHECK" = "1" ]]; then
        echo -n "${@: -1} - " ; curl -s "$GERRIT_URL/changes/${@: -1}/detail" | sed '1s/^)]}'\''//' | jq -r '.status'
    else
        ${ANDROID_BUILD_TOP}/lineage/scripts/repopick/repopick.py -g $GERRIT_URL $@ &
    fi
}

function repopickchain() {
    if [[ "$CHECK" = "1" ]]; then
        echo -n "$1 - " ; curl -s "$GERRIT_URL/changes/$1/detail" | sed '1s/^)]}'\''//' | jq -r '.status'
    else
        ${GEN_CHAIN} $@
    fi
}

function rc() {
    echo `${GEN_CHAIN} $@ | cut -b10-`
}

# bionic
repopick 490428 # libc: libstdc++: Introduce libstdc++_vendor

# build/make
repopickchain 491482 # Revert "Add message suggesting SOONG_INCREMENTAL_ANALYSIS=true after builds"

# device/google/gs-common
repopick 491863 # sepolicy: Update ignored sepolicy for CP2A

# device/sony/pdx257
repopickchain 493311 # pdx257: Update WFD system blobs from CPH2747_11_C_OTA_1020_all_6yqNTQ_01000100

# device/sony/sm6375-common
repopickchain 493329 # sm6375-common: Use legacy libion implementation

# external/dng_sdk
repopickchain 490572 # dng_area_task: Provide backwards compatibility with legacy blobs

# external/libjxl
repopick 490598 # libjxl: Make it available to vendor

# external/v4l2_codec2
repopickchain 491128 # Use the output pixel format requested by the decoder when available

# external/wpa_supplicant_8
repopick 490621 # wpa_supplicant: add support for bcmdhd SAE authentication offload

# frameworks/av
repopickchain 490648 # CAMX: CHI: Added support for handling jpeg debug data.

# frameworks/base
repopickchain 496008 # SystemUI: Fix battery icon not hiding from the status bar

# frameworks/native
repopickchain 492289 # libui: Restore support for gralloc 2/3

# frameworks/opt/telephony
repopickchain 490678 # EuiccCardController: Avoid NPE for legacy euicc devices

# hardware/broadcom/libbt
repopickchain 490687 # libbt: Convert to Android.bp

# hardware/interfaces
repopickchain 492976 # libradiocompat: Fix non-null argument error by passing empty string

# hardware/sony
repopickchain 492602 # sepolicy: Rename 202404 compatibility mapping to 202504

# hardware/qcom-caf/sm8450-6.6/audio/primary-hal
repopick 493305 # audio: primary-hal: Add support for acnMask

# hardware/qcom/wlan
repopickchain 490717 # legacy: Build wpa_supplicant.conf from make to soong

# packages/apps/DocumentsUI
repopickchain 490738 # DocumentsUI: add icons for shortcuts

# packages/apps/Launcher3
repopickchain 493818 # Launcher3: Kill OSE widget

# packages/apps/Settings
repopickchain 491435 # Require "tap to show" in SIM settings

# packages/apps/TvSettings
repopickchain 490777 # TvSettings: Support two button mute

# packages/modules/Bluetooth
repopickchain 490791 # le_audio: Allow overriding the bit depth

# packages/modules/Connectivity
repopickchain 490802 # ConnectivityService: Disable "Close QUIC connection" feature

# packages/modules/Wifi
repopick 490810 # Wifi: Ingore miracast scan from connectivity manager

# packages/providers/DownloadProvider
repopickchain 490818 # DownloadProvider: Add support for manual pause/resume

# packages/providers/MediaProvider
repopickchain 490821 # Reject private paths with ignorable codepoints

# packages/services/DeviceAsWebcam
repopickchain 490834 # DeviceAsWebcam: jni: Make dwMaxPayloadTransferSize adjustable via property

# packages/services/Telecomm
repopickchain 491138 # DNM Revert "Telecom: Add sensitive phone numbers hooks"

# packages/services/Telephony
repopickchain 490845 # Telephony: Migrate RadioInfo from ScrollView to NestedScrollView

# system/chre
repopick 490848 # Restore MSM CHRE daemon support

# system/core
repopickchain 490876 # Partially Revert "usbd: Exit in case of charger mode."

# system/extras
repopick 490893 # Revert "lpmake: Remove --auto-slot-suffixing support."

# system/fs/fs_mgr
repopickchain 494302 # libsnapshot: Implement DM_USER_REQ_MAP_WRITE/UBLK_IO_OP_WRITE

# system/media
repopickchain 490899 # audio: Allow opting out of speaker_layout_channel_mask field

# system/netd
repopickchain 490902 # VPN-covered DNS traffic may not fall through

# system/security
repopick 490903 # Handle key parameter conversion for FBE_ICE tag

# system/sepolicy
repopickchain 490921 # Add property to set secondary display orientation

# system/update_engine
repopickchain 490934 # Use ro.build.type in HardwareAndroid::AllowDowngrade()

# system/vold
repopickchain 490949 # vold: Add support for ISO9660/UDF CD-ROM

# vendor/qcom/opensource/audio-hal/st-hal-ar
repopickchain 493134 # Revert "st-hal: add support for forceRecognitionEvent"

# Menunggu seluruh latar belakang (repopick &) selesai diproses
wait
