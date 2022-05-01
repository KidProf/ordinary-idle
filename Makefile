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

gen-model:
	python3 gen/genModel.py gen/PlayerT1.csv > gen/outputs/PlayerT1.txt
	python3 gen/genModel.py gen/PlayerT2.csv > gen/outputs/PlayerT2.txt
	python3 gen/genModel.py gen/PlayerT3.csv > gen/outputs/PlayerT3.txt

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

build-web:
	flutter build web
clean:
	flutter clean
