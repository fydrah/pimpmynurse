# PimpMyNurse

A nurse helper application

## Download

Take a look at the [release page](https://github.com/fydrah/pimpmynurse/releases/latest)

* Latest devices: use **arm64-v8a** APK
* Older devices: use **armeabi-v7a** APK

## Dev

### Generate APKs:

```
make
# or without unit tests
make apk
```

### Install release on your device (USB plugged):

```
make install
```

> You can switch the Arch (armebi / arm64 / x86_64) by editing the Makefile.

### Publish to GCS (Maintainers only)

```
make publish
```

## License

This software is released under [GPLv3](./LICENSE).