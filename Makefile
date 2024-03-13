
tests:
	flutter test

tests-with-coverage:
	flutter test --coverage

integration-tests:
	flutter drive --target=test_driver/app.dart

build-android-release-bundle:
	mv android/app/google-services.json google-services.json && \
	cp lib/firebase_options.dart firebase_options.dart && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/profile/AndroidManifest.xml && \
	sed -i "s/apiKey:.*/apiKey: \'$(PROD_FIREBASE_API_KEY)\',/g" lib/firebase_options.dart && \
	sed -i "s/appId:.*/appId: \'$(PROD_FIREBASE_API_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/messagingSenderId:.*/messagingSenderId: \'$(PROD_FIREBASE_MESSAGING_SENDER_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/projectId:.*/projectId: \'$(PROD_FIREBASE_PROJECT_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/storageBucket:.*/storageBucket: \'$(PROD_FIREBASE_STORAGE_BUCKET)\',/g" lib/firebase_options.dart && \
	cp $(PROD_GOOGLE_SERVICE_PATH) android/app/google-services.json && \
	flutter build appbundle && \
	mv google-services.json android/app/google-services.json && \
	mv firebase_options.dart lib/firebase_options.dart && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/profile/AndroidManifest.xml

build-android-release-apk:
	mv android/app/google-services.json google-services.json && \
	cp lib/firebase_options.dart firebase_options.dart && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/profile/AndroidManifest.xml && \
	sed -i "s/apiKey:.*/apiKey: \'$(PROD_FIREBASE_API_KEY)\',/g" lib/firebase_options.dart && \
	sed -i "s/appId:.*/appId: \'$(PROD_FIREBASE_API_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/messagingSenderId:.*/messagingSenderId: \'$(PROD_FIREBASE_MESSAGING_SENDER_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/projectId:.*/projectId: \'$(PROD_FIREBASE_PROJECT_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/storageBucket:.*/storageBucket: \'$(PROD_FIREBASE_STORAGE_BUCKET)\',/g" lib/firebase_options.dart && \
	cp $(PROD_GOOGLE_SERVICE_PATH) android/app/google-services.json && \
	flutter build apk --split-per-abi && \
	mv google-services.json android/app/google-services.json && \
	mv firebase_options.dart lib/firebase_options.dart && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/profile/AndroidManifest.xml

apply-android-release-changes:
	mv android/app/google-services.json google-services.json && \
	cp lib/firebase_options.dart firebase_options.dart && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/profile/AndroidManifest.xml && \
	sed -i "s/apiKey:.*/apiKey: \'$(PROD_FIREBASE_API_KEY)\',/g" lib/firebase_options.dart && \
	sed -i "s/appId:.*/appId: \'$(PROD_FIREBASE_API_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/messagingSenderId:.*/messagingSenderId: \'$(PROD_FIREBASE_MESSAGING_SENDER_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/projectId:.*/projectId: \'$(PROD_FIREBASE_PROJECT_ID)\',/g" lib/firebase_options.dart && \
	sed -i "s/storageBucket:.*/storageBucket: \'$(PROD_FIREBASE_STORAGE_BUCKET)\',/g" lib/firebase_options.dart && \
	cp $(PROD_GOOGLE_SERVICE_PATH) android/app/google-services.json

undo-android-release-changes:
	mv google-services.json android/app/google-services.json && \
	mv firebase_options.dart lib/firebase_options.dart && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/profile/AndroidManifest.xml

increase-version:
	sed -i 's/version.*$$/version: $(VERSION_NAME)\+$(VERSION_CODE)/g' pubspec.yaml
	git add pubspec.yaml
	git commit -m "chore: release v$(VERSION_NAME) ($(VERSION_CODE))"
	git tag v$(VERSION_NAME)
	git push origin v$(VERSION_NAME)