enum SupportedPlatform {
  android('android'),
  ios('ios');

  final String value;

  const SupportedPlatform(this.value);
}

extension SupportedPlatformExtension on SupportedPlatform {
  List<String> get buildArguments {
    switch (this) {
      case SupportedPlatform.android:
        return ['build', 'appbundle'];
      case SupportedPlatform.ios:
        return ['build', 'ipa', '--export-method', 'development'];
    }
  }

  String get buildPath {
    switch (this) {
      case SupportedPlatform.android:
        return '../example/build/app/outputs/bundle/release/app-release.aab';
      case SupportedPlatform.ios:
        return '../example/build/ios/ipa/example.ipa';
    }
  }
}
