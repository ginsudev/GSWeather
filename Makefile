ROOTLESS ?= 0

# Build config
ARCHS = arm64 arm64e
THEOS_DEVICE_IP = localhost -p 2222
PACKAGE_VERSION = 1.1.1

# Rootless / Rootful settings
ifeq ($(ROOTLESS),1)
	GSWeather_XCODEFLAGS = SWIFT_ACTIVE_COMPILATION_CONDITIONS="ROOTLESS"
	THEOS_PACKAGE_SCHEME = rootless
	GSWEATHER_INSTALL_PATH = /var/jb/Library/Frameworks
	MOVE_TO_THEOS_PATH = $(THEOS)/lib/iphone/rootless/
	# Control
	PKG_NAME_SUFFIX = (Rootless)
else
	GSWeather_XCODEFLAGS = SWIFT_ACTIVE_COMPILATION_CONDITIONS=""
	GSWEATHER_INSTALL_PATH = /Library/Frameworks
	MOVE_TO_THEOS_PATH = $(THEOS)/lib/
endif

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = GSWeather
GSWeather_XCODEFLAGS += LD_DYLIB_INSTALL_NAME=$(GSWEATHER_INSTALL_PATH)/GSWeather.framework/GSWeather
GSWeather_XCODEFLAGS += DYLIB_INSTALL_NAME_BASE=$(GSWEATHER_INSTALL_PATH)/GSWeather.framework/GSWeather
GSWeather_XCODEFLAGS += DWARF_DSYM_FOLDER_PATH=$(THEOS_OBJ_DIR)/dSYMs
GSWeather_XCODEFLAGS += CONFIGURATION_BUILD_DIR=$(THEOS_OBJ_DIR)/

include $(THEOS)/makefiles/xcodeproj.mk

override THEOS_PACKAGE_NAME := com.ginsu.gsweather-$(PKG_ARCHITECTURE)

before-package::
	# Append values to control file
	$(ECHO_NOTHING)sed -i '' \
		-e 's/\$${PKG_ARCHITECTURE}/$(PKG_ARCHITECTURE)/g' \
		-e 's/\$${VERSION}/$(PACKAGE_VERSION)/g' \
		-e 's/\$${PKG_NAME_SUFFIX}/$(PKG_NAME_SUFFIX)/g' \
		$(THEOS_STAGING_DIR)/DEBIAN/control$(ECHO_END)

ifeq ($(ROOTLESS),1)
	# Move to staging dir
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)$(GSWEATHER_INSTALL_PATH)$(ECHO_END)
	$(ECHO_NOTHING)mv $(THEOS_OBJ_DIR)/GSWeather.framework/ $(THEOS_STAGING_DIR)$(GSWEATHER_INSTALL_PATH)$(ECHO_END)
endif

	# Copy to theos/lib
	$(ECHO_NOTHING)rm -rf $(MOVE_TO_THEOS_PATH)GSWeather.framework/$(ECHO_END)
	$(ECHO_NOTHING)cp -r $(THEOS_STAGING_DIR)$(GSWEATHER_INSTALL_PATH)/GSWeather.framework $(MOVE_TO_THEOS_PATH)$(ECHO_END)

before-all::
	$(ECHO_NOTHING)rm -rf $(THEOS_STAGING_DIR)$(GSWEATHER_INSTALL_PATH)$(ECHO_END)
	$(ECHO_NOTHING)rm -rf $(THEOS_OBJ_DIR)$(ECHO_END)
