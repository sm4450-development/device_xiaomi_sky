/*
 * Copyright (C) 2021-2022 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_variant.h>
#include <libinit_utils.h>

#include "vendor_init.h"

#define FINGERPRINT_POCO_IN "POCO/sky:13/TKQ1.221114.001/V14.0.5.0.TMWINXM:user/release-keys"
#define FINGERPRINT_REDMI_IN "Redmi/sky:13/TKQ1.221114.001/V14.0.5.0.TMWINXM:user/release-keys"
#define FINGERPRINT_CHINA "Redmi/sky/sky:13/TKQ1.221114.001/V14.0.5.0.TMWINXM:user/release-keys"

static const variant_info_t sky_poco_info = {
    .hwc_value = "India",
    .boardid = "S88019EP1",

    .brand = "POCO",
    .device = "sky",
    .marketname = "POCO M6 Pro 5G",
    .model = "23076PC4BI",
    .mod_device = "sky_in_global",
    .build_fingerprint = FINGERPRINT_POCO_IN,
};

static const variant_info_t sky_redmi_info = {
    .hwc_value = "India",
    .boardid = "S88018EA1",

    .brand = "Redmi",
    .device = "sky",
    .marketname = "Redmi 12 5G",
    .model = "23076RN4BI",
    .mod_device = "sky_in_global",
    .build_fingerprint = FINGERPRINT_REDMI_IN,
};

static const variant_info_t sky_china_info = {
    .hwc_value = "CN",
    .boardid = "S88019BA1",

    .brand = "Redmi",
    .device = "sky",
    .marketname = "Redmi Note 12R",
    .model = "23076RA4BC",
    .mod_device = "sky_global",
    .build_fingerprint = FINGERPRINT_CHINA,
};

static const std::vector<variant_info_t> variants = {
    sky_poco_info,
    sky_redmi_info,
    sky_china_info,
};

void vendor_load_properties() {
    search_variant(variants);
}
