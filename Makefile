TARGET = iphone:clang:latest:14.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Spork

# Apenas o tweak e a UI. Sem Luau, sem Dobby.
Spork_FILES = Tweak.xm SporkUI.mm exploit.mm hooks.mm

Spork_CFLAGS = -fobjc-arc -std=c++17 -I$(THEOS_PROJECT_DIR)
Spork_LDFLAGS = -undefined dynamic_lookup
Spork_FRAMEWORKS = UIKit Foundation Security

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
