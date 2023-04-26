#!/bin/bash

mv build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk releases/pimpmynurse-armeabi-v7a-${1}.apk
mv build/app/outputs/flutter-apk/app-arm64-v8a-release.apk releases/pimpmynurse-arm64-v8a-${1}.apk
mv build/app/outputs/flutter-apk/app-x86_64-release.apk releases/pimpmynurse-x86_64-${1}.apk
