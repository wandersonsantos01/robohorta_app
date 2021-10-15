# robohortaapp

Robohorta App

## Getting Started

## Install App on Device

- You need a device with developer mode activated.

1- Connect your Android device to your computer with a USB cable.
2- Enter cd <app dir> where <app dir> is your application directory.
3- Run:
```shell
$ flutter clean
$ flutter build apk --split-per-abi
$ flutter install
```

## Update package - Install new dependencies

When you change pubspec.yml file, you need to get new dependencies, so follow next steps.

1- Navigate to project folder.
2- Run:
```shell
$ flutter pub get
```

If you have problems to run flutter build command, maybe you should upgrade your flutter running:
```shell
$ flutter upgrade
```