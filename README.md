# rtg_app

The roma app project.

## Installation requirements

- flutter 3.0.5
- gradle 7.1.2
- kotlyn 1.7.0
- java 11

## Build requirements

- create `gradle.properties` file at android folder with this content

```
org.gradle.jvmargs=-Xmx1536M
android.useAndroidX=true
android.enableJetifier=true
org.gradle.java.home={your-java-11-sdk-path}
```