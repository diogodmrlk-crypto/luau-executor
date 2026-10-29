TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Spork

# Arquivos do teu projeto
Spork_FILES = Tweak.xm SporkUI.mm exploit.mm hooks.mm memory.cpp execution.cpp

# Arquivos do Luau (compilados junto)
Spork_FILES += $(wildcard VM/src/*.cpp) $(wildcard Compiler/src/*.cpp) $(wildcard Ast/src/*.cpp) $(wildcard Bytecode/src/*.cpp) $(wildcard Common/src/*.cpp)

# Flags de compilação (C++17 e includes do Luau)
Spork_CFLAGS = -fobjc-arc -std=c++17 -Wno-error -Wno-unused-but-set-variable -Wno-unused-variable \
               -I$(THEOS_PROJECT_DIR) \
               -I$(THEOS_PROJECT_DIR)/VM/include \
               -I$(THEOS_PROJECT_DIR)/Compiler/include \
               -I$(THEOS_PROJECT_DIR)/Common/include \
               -I$(THEOS_PROJECT_DIR)/Ast/include \
               -I$(THEOS_PROJECT_DIR)/Bytecode/include

# LINKAGEM: Remove o Dobby e adiciona o Substrate (MSHookFunction)
Spork_LDFLAGS = -undefined dynamic_lookup -lsubstrate

# Frameworks necessários
Spork_FRAMEWORKS = UIKit Foundation Security

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
