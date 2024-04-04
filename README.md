# eadvisor
# update cubit
flutter packages pub run build_runner build --delete-conflicting-outputs
# build apk
flutter pub get
flutter build apk --release
# build aab
flutter build appbundle
flutter build appbundle -t lib/presentation/main.dart

# cover UT
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html