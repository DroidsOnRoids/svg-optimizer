import '../utils/asset_record_utils.dart';

const String _bigProjectPath = 'assets/benchmark_svg/big_project/';
const String _mediumProjectPath = 'assets/benchmark_svg/medium_project/';
const String _smallProjectPath = 'assets/benchmark_svg/small_project/';

enum ProjectSize {
  small,
  medium,
  big,
}

extension ProjectSizeExtension on ProjectSize {
  List<Map<String, dynamic>> getAssetRecords(bool withTransformer) => switch (this) {
        ProjectSize.small => [
            AssetRecordUtils.getAssetRecord(_smallProjectPath, withTransformer),
          ],
        ProjectSize.medium => [
            AssetRecordUtils.getAssetRecord(_smallProjectPath, withTransformer),
            AssetRecordUtils.getAssetRecord(_mediumProjectPath, withTransformer),
          ],
        ProjectSize.big => [
            AssetRecordUtils.getAssetRecord(_smallProjectPath, withTransformer),
            AssetRecordUtils.getAssetRecord(_mediumProjectPath, withTransformer),
            AssetRecordUtils.getAssetRecord(_bigProjectPath, withTransformer),
          ],
      };
}
