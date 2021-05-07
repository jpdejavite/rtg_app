
tests:
	flutter test

integration-tests:
	flutter drive \
	--driver=test_driver/app.dart \
	--target=test_driver/*_test.dart

build-android-release-bundle:
	mv android/app/google-services.json google-services.json && \
	cp $(PROD_GOOGLE_SERVICE_PATH) android/app/google-services.json && \
	flutter build appbundle && \
	mv google-services.json android/app/google-services.json

build-android-release-apk:
	mv android/app/google-services.json google-services.json && \
	cp $(PROD_GOOGLE_SERVICE_PATH) android/app/google-services.json && \
	flutter build apk --split-per-abi && \
	mv google-services.json android/app/google-services.json
