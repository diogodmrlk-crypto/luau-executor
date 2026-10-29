TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Spork

# 1. Arquivos do teu projeto
Spork_FILES = Tweak.xm SporkUI.mm exploit.mm hooks.mm memory.cpp execution.cpp

# 2. Arquivos do Luau (adicionados via wildcard)
Spork_FILES += $(wildcard VM/src/*.cpp) $(wildcard Compiler/src/*.cpp) $(wildcard Ast/src/*.cpp) $(wildcard Bytecode/src/*.cpp) $(wildcard Common/src/*.cpp)

# 3. Includes (O -I da raiz é para o dobby.h; os outros são para o Luau)
Spork_CFLAGS = -fobjc-arc -std=c++17 -Wno-error -Wno-unused-but-set-variable -Wno-unused-variable \
               -I$(THEOS_PROJECT_DIR) \
               -I$(THEOS_PROJECT_DIR)/VM/include \
               -I$(THEOS_PROJECT_DIR)/Compiler/include \
               -I$(THEOS_PROJECT_DIR)/Common/include \
               -I$(THEOS_PROJECT_DIR)/Ast/include \
               -I$(THEOS_PROJECT_DIR)/Bytecode/include

# 4. Linkando o Dobby da pasta lib
Spork_LDFLAGS = -undefined dynamic_lookup -L$(THEOS_PROJECT_DIR)/lib -lDobby

# 5. Frameworks necessários
Spork_FRAMEWORKS = UIKit Foundation Security

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
