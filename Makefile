all:
	flutter run

format:
	flutter format -l 120 lib

get:
	flutter packages get

upgrade:
	flutter packages upgrade

model:
	flutter packages pub run build_runner build

icon:
	flutter pub run flutter_launcher_icons:main

rename:
	pub global run rename --bundleId com.kidprof.ordinaryidle && pub global run rename --appname "OrdinaryIdle"

build-bundle:
	flutter build appbundle

build-apk:
	flutter build apk

build-apk-split:
	flutter build apk --split-per-abi
clean:
	flutter clean
