APP_NAME		:= $(shell sed -n 's/^name: \(.*\)$$/\1/p' pubspec.yaml)
ARCHS			:= armeabi-v7a arm64-v8a x86_64
INSTALL_ARCH	:= armeabi-v7a
# INSTALL_ARCH	:= arm64-v8a
# INSTALL_ARCH	:= x86_64
VERSION			:= $(shell sed -n 's/^version: \(.*\)$$/\1/p' pubspec.yaml)
BUCKET			:= $(APP_NAME)-releases
RELEASE_DIR		:= build/app/outputs/flutter-apk

all: test apk

apk: icon splash name
	flutter build apk --split-per-abi

icon:
	flutter pub run flutter_launcher_icons

splash:
	flutter pub run flutter_native_splash:create

name:
	flutter pub run flutter_app_name

install:
	adb install $(RELEASE_DIR)/app-$(INSTALL_ARCH)-release.apk

test: test_models

test_models:
	flutter test test/models -r github

define newline


endef
publish: apk
	@echo "### Publishing $(APP_NAME) v$(VERSION)..."
	$(foreach type,apk apk.sha1, \
		$(foreach arch,$(ARCHS), \
			@gsutil cp -n \
				$(RELEASE_DIR)/app-$(arch)-release.$(type) \
				gs://$(BUCKET)/$(APP_NAME)-$(arch)-v$(VERSION).$(type) $(newline) \
		) \
	)
	@echo "...uploaded APKs:"
	$(foreach arch,$(ARCHS), \
		@echo "* https://storage.googleapis.com/$(BUCKET)/$(APP_NAME)-$(arch)-v$(VERSION).apk"  $(newline) \
	)
