TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = MyAimbotLib

MyAimbotLib_FILES = MyAimbotLib.mm
MyAimbotLib_CFLAGS = -fobjc-arc
MyAimbotLib_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/library.mk
