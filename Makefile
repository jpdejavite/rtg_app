
tests:
	flutter test

integration-tests:
	flutter drive \
	--driver=test_driver/app.dart \
	--target=test_driver/*_test.dart