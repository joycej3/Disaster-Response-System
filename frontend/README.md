This
is
for
frontend
files
running
the
flutter
pipeline

Test files **must** end in `_test.dart` to be picked up by flutter. You can add them in the test folder

To generate the mocks for your test run `flutter pub run build_runner build --delete-conflicting-outputs`

To run all tests do it from IDE or have terminal in root(...\project\frontend) and run `flutter test -r expanded`

# Run the front end
To run in web and allow api requests to backend:
Ensure the backend is running by following the steps in `backend/README.md`

Install flutter by following the guide at:
`https://docs.flutter.dev/get-started/install`

Then run flutter in debug mode using:
`flutter run -d edge`
Replace `edge` with your browser of choice.

Note: This may fail on the first run as flutter gets all dependancies, running it a second time should fix any issues.