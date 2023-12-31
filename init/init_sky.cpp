/*
 * Copyright (C) 2023 Paranoid Android
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <android-base/properties.h>
#include <sys/sysinfo.h>

#include <cstdlib>
#include <cstring>
#include <vector>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;

// list of partitions to override props
std::vector<std::string> ro_props_default_source_order = {
    "", "odm.", "odm_dlkm.", "product.", "system.", "system_ext.", "vendor.", "vendor_dlkm.",
};

void property_override(char const prop[], char const value[], bool add = true) {
    auto pi = (prop_info *)__system_property_find(prop);

    if (pi != nullptr) {
        __system_property_update(pi, value, strlen(value));
    } else if (add) {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void set_ro_build_prop(const std::string &source, const std::string &prop,
                       const std::string &value, bool product = false) {
    std::string prop_name;

    if (product) {
        prop_name = "ro.product." + source + prop;
    } else {
        prop_name = "ro." + source + "build." + prop;
    }

    property_override(prop_name.c_str(), value.c_str(), true);
}

void set_device_props(const std::string fingerprint, const std::string description,
                      const std::string brand, const std::string device, const std::string model, const std::string name, const std::string marketname) {
    for (const auto &source : ro_props_default_source_order) {
        set_ro_build_prop(source, "fingerprint", fingerprint);
        set_ro_build_prop(source, "brand", brand, true);
        set_ro_build_prop(source, "device", device, true);
        set_ro_build_prop(source, "model", model, true);
        set_ro_build_prop(source, "name", name, true);
        set_ro_build_prop(source, "marketname", marketname, true);
    }

    property_override("ro.build.fingerprint", fingerprint.c_str());
    property_override("ro.build.description", description.c_str());
    property_override("bluetooth.device.default_name", model.c_str());
}

void vendor_load_properties() {
    // Detect variant and override properties
    std::string region = GetProperty("ro.boot.hwc", "");
    std::string boardid = GetProperty("ro.boot.boardid", "");
    if (region == "India" && boardid == "S88019EP1") {
	set_device_props(
	    "POCO/sky_p_in/sky:13/TKQ1.221114.001/V14.0.7.0.TMWINXM:user/release-keys",
            "sky-user-13-TKQ1.221114.001-V14.0.7.0.TMWINXM-release-keys", "POCO", "sky",
            "23076PC4BI", "sky_p_in", "POCO M6 Pro 5G");
    } else {
        set_device_props(
            "Redmi/sky_in/sky:13/TKQ1.221114.001/V14.0.7.0.TMWINXM:user/release-keys",
            "sky-user-13-TKQ1.221114.001-V14.0.7.0.TMWINXM-release-keys", "Redmi", "sky",
            "23076RN4BI", "sky_in", "Redmi 12 5G");
    }
    // Set hardware revision
    property_override("ro.boot.hardware.revision", GetProperty("ro.boot.hwversion", "").c_str());
}
