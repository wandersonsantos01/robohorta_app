# robohortaapp

Robohorta App

## Getting Started

## Check flutter configurations

```shell
$ flutter doctor -v
```

## Run App on Ubuntu

1- Enter cd <app dir> where <app dir> is your application directory.
2- Run:
```shell
$ flutter clean
$ flutter build apk --split-per-abi --no-sound-null-safety
$ flutter run --no-sound-null-safety
```

Probably you will need to select one of the listed options. Select "Linux"

## Install App on Device

- You need a device with developer mode activated.

1- Connect your Android device to your computer with a USB cable.
2- Enter cd <app dir> where <app dir> is your application directory.
3- Run:
```shell
$ flutter clean
$ flutter build apk --split-per-abi --no-sound-null-safety
$ flutter install
```

## Build Web App

To build a web app based on Flutter project, run:

```shell
$ flutter build web --no-sound-null-safety
```

Then, you will need to start a simple server to check the build above (you will need Python to be installed). Run:

```shell
$ python -m http.server 8000
```

Then you can access http://localhost:8000 on you browser and check the result.

If you want to commit to GitHub Pages, you need to change .env file name, removing "." and/or renaming the file.

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