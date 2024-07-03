# SVG Optimizer

A Dart package that optimizes SVG files at build time using SVGO.

## Overview
The goal of this package is to simplify the optimization of SVG files in Flutter projects using transformers.

## Prerequisites
Before package can be used, make sure to complete all of the prerequisites listed below.

1. [Install SVGO](https://svgo.dev/docs/introduction/)
2. Make sure to add Node and SVGO to environmental variables.

## Usage
### Installation
To use this plugin, add `svg_optimizer` as a [dependency in your pubspec.yaml file](https://docs.flutter.dev/development/packages-and-plugins/using-packages).

```yml
dependencies:
  svg_optimizer: ^0.0.1
```

or run this command:
```zsh
flutter pub add svg_optimizer 
```

### Example usage
```yml
  assets:
    - path: assets/svg/
      transformers:
        - package: svg_optimizer
```
