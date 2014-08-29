XCODE_BASE=/Applications/Xcode.app/Contents
IPHONEOS=$(XCODE_BASE)/Developer/Platforms/iPhoneOS.platform
SDK=$(IPHONEOS)/Developer/SDKs/iPhoneOS7.1.sdk
FRAMEWORKS=$(SDK)/System/Library/Frameworks/
INCLUDES=$(SDK)/usr/include

all:
	clang -mios-version-min=7.0 \
	      -isysroot $(SDK) \
	      -arch armv7 \
	      source.m \
	      -lobjc \
	      -framework Foundation -framework UIKit -framework CoreText -framework CoreGraphics \
	      -o ff

