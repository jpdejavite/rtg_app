
tests:
	flutter test

tests-with-coverage:
	flutter test --coverage

integration-tests:
	flutter drive \
	--driver=test_driver/app.dart \
	--target=test_driver/*_test.dart

build-android-release-bundle:
	mv android/app/google-services.json google-services.json && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/profile/AndroidManifest.xml
	cp $(PROD_GOOGLE_SERVICE_PATH) android/app/google-services.json && \
	flutter build appbundle && \
	mv google-services.json android/app/google-services.json && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.rtg_app/com.example.rtg_app/g' android/app/src/profile/AndroidManifest.xml

build-android-release-apk:
	mv android/app/google-services.json google-services.json && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/build.gradle && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/debug/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/AndroidManifest.xml && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/main/kotlin/com/example/rtg_app/MainActivity.kt && \
	sed -i 's/com\.example\.rtg_app/com.rtg_app/g' android/app/src/profile/AndroidManifest.xml
	cp $(PROD_GOOGLE_SERVICE_PATH) android/app/google-services.json && \
	flutter build apk --split-per-abi && \
	mv google-services.json android/app/google-services.json && \
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