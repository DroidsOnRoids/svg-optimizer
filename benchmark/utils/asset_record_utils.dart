abstract class AssetRecordUtils {
  static Map<String, dynamic> getAssetRecord(
          String path, bool withTransformer) =>
      <String, dynamic>{
        'path': path,
        if (withTransformer)
          'transformers': [
            {'package': 'svg_optimizer'},
          ],
      };
}
