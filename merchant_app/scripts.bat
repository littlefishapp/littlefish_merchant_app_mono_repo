
sudo cp littlefish_cli.sh /usr/local/bin/littlefish


REM desktop debugging which is terminal dependent
set ENABLE_FLUTTER_DESKTOP=true
flutter config --enable-windows-desktop

REM compile json files based on classes
flutter pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner build watch
flutter packages pub run build_runner build
flutter pub run build_runner build --delete-conflicting-outputs --build-filter "lib/example/path/**" 

REM host to a local endpoint
"C:\Program Files (x86)\ngRok\ngrok.exe" http 127.0.0.1:5000

REM set the icons / app launcher for the app
flutter pub run flutter_launcher_icons:main

REM cleanup project imports
flutter pub run import_path_converter:main
flutter pub run import_sorter:main

REM flutter build split apk
flutter build apk --target-platform android-arm,android-arm64 --split-per-abi

REM SBSA BroadPOS (PAX) 
fvm flutter build apk -t lib/main.dart --flavor sbsabposdev --dart-define-from-file env_files/sbsabposdev.json --release --target-platform android-arm,android-arm64 --split-per-abi

REM SBSA MPP Companion app
fvm flutter build apk -t lib/main.dart --flavor sbsamppdev --dart-define-from-file env_files/sbsamppdev.json --release --target-platform android-arm,android-arm64 --split-per-abi

REM debug dev local
flutter run -t lib/main.dart -d emulator-5556 --flavor dev
flutter run -t lib/main.dart -d <deviceId> --flavor prod

REM dev dev
flutter run -t lib/main_dev.dart -d c4c9de99 --flavor dev
flutter run -t lib/main_dev.dart -d <deviceId> --flavor prod

REM production
flutter run -t lib/main_prod.dart -d <deviceId> --flavor dev
flutter run -t lib/main_prod.dart -d <deviceId> --flavor prod

REM build
flutter build apk -t lib/main_dev.dart --flavor dev
flutter build appbundle -t lib/main_dev.dart --flavor dev
fvm flutter build appbundle -t lib/main_prod.dart --flavor prod


REM wireless debugging droid
adb kill-server
adb tcpip 5555
adb connect 192.168.0.196:5555
adb devices

REM apk and certificate checks
aapt dump badging app-armeabi-v7a-lflfbposdev-release.apk
apksigner verify --verbose --print-certs app-arm64-v8a-lflfbposdev-release.apk



flutter run --flavor=sbsamppdev --dart-define=LAUNCHDARKLY_MOBILE_KEY=mob-37c48608-83ed-4e85-b3b6-d7e436cb7489 --dart-define=USE_CASE=simply-blue-mpp --dart-define=LD_USER=order3_dev --dart-define=APP_ENVIRONMENT=dev

flutter build ipa --release --flavor=sbsamppdev --dart-define=LAUNCHDARKLY_MOBILE_KEY=mob-37c48608-83ed-4e85-b3b6-d7e436cb7489 --dart-define=USE_CASE=simply-blue-mpp --dart-define=LD_USER=order3_dev --dart-define=APP_ENVIRONMENT=dev
flutter build ipa --release --flavor=sbsamppprod --dart-define=LAUNCHDARKLY_MOBILE_KEY=mob-a6aefa77-6dee-4f82-912f-6ca05f00a44a --dart-define=USE_CASE=simply-blue-mpp --dart-define=LD_USER=order3_dev --dart-define=APP_ENVIRONMENT=dev