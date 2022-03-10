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

clean:
	flutter clean