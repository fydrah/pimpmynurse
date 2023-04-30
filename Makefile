INSTALL_ARCH := armeabi-v7a
# INSTALL_ARCH := arm64-v8a

all: icon splash name apk

apk:
	flutter build apk --split-per-abi

icon:
	flutter pub run flutter_launcher_icons

splash:
	flutter pub run flutter_native_splash:create

name:
	flutter pub run flutter_app_name

install:
	adb install build/app/outputs/flutter-apk/app-$(INSTALL_ARCH)-release.apk