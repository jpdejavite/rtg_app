import 'package:flutter_test/flutter_test.dart';

import 'package:rtg_app/model/recipe_preparation_time_duration.dart';

void main() {
  test('minutes convertTo minutes ', () {
    expect(
        RecipePreparationTimeDuration.minutes
            .convertTo(30, RecipePreparationTimeDuration.minutes),
        "30");
  });

  test('minutes convertTo hours ', () {
    expect(
        RecipePreparationTimeDuration.minutes
            .convertTo(30, RecipePreparationTimeDuration.hours),
        "0.5");
  });

  test('minutes convertTo days ', () {
    expect(
        RecipePreparationTimeDuration.minutes
            .convertTo(2160, RecipePreparationTimeDuration.days),
        "1.5");
  });

  test('hours convertTo hours ', () {
    expect(
        RecipePreparationTimeDuration.hours
            .convertTo(1, RecipePreparationTimeDuration.hours),
        "1.0");
  });

  test('hours convertTo minutes ', () {
    expect(
        RecipePreparationTimeDuration.hours
            .convertTo(1.5, RecipePreparationTimeDuration.minutes),
        "90");
  });

  test('hours convertTo days ', () {
    expect(
        RecipePreparationTimeDuration.hours
            .convertTo(12, RecipePreparationTimeDuration.days),
        "0.5");
  });

  test('days convertTo minutes ', () {
    expect(
        RecipePreparationTimeDuration.days
            .convertTo(1, RecipePreparationTimeDuration.minutes),
        "1440");
  });

  test('days convertTo hours ', () {
    expect(
        RecipePreparationTimeDuration.days
            .convertTo(0.5, RecipePreparationTimeDuration.hours),
        "12.0");
  });
}
