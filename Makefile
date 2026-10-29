TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Spork

Spork_FILES = Tweak.xm SporkUI.mm exploit.mm hooks.mm memory.cpp execution.cpp
Spork_FILES += $(wildcard VM/src/*.cpp) $(wildcard Compiler/src/*.cpp) $(wildcard Ast/src/*.cpp) $(wildcard Bytecode/src/*.cpp) $(wildcard Common/src/*.cpp)

# Flags para evitar erros de módulo e avisos do compilador
Spork_CFLAGS = -fobjc-arc -std=c++17 -Wno-error -Wno-unused-but-set-variable -Wno-unused-variable \
               -Wno-module-import-in-extern-c \
               -I$(THEOS_PROJECT_DIR) \
               -I$(THEOS_PROJECT_DIR)/VM/include \
               -I$(THEOS_PROJECT_DIR)/Compiler/include \
               -I$(THEOS_PROJECT_DIR)/Common/include \
               -I$(THEOS_PROJECT_DIR)/Ast/include \
               -I$(THEOS_PROJECT_DIR)/Bytecode/include

# Linkagem com o Substrate
Spork_LDFLAGS = -undefined dynamic_lookup -lsubstrate

Spork_FRAMEWORKS = UIKit Foundation Security

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
