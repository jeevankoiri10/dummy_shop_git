// Downloads the DummyJSON OpenAPI spec and keeps only what the app calls.
//
// The full spec can't be generated as is: the inline `Comment.user` object
// overwrites the generated `User` model.
//
// Run: dart run tool/update_openapi.dart
import 'dart:convert';
import 'dart:io';

const _specUrl = 'https://dummyjson.com/openapi.json';
const _outputPath = 'openapi/dummyjson.json';

const _operations = {
  '/auth/login': 'post',
  '/auth/me': 'get',
  '/auth/refresh': 'post',
  '/products': 'get',
  '/users/{id}': 'get',
};

Future<void> main() async {
  final spec = await _download();
  final paths = spec['paths'] as Map<String, dynamic>;
  final components = spec['components'] as Map<String, dynamic>;

  final keptPaths = <String, dynamic>{
    for (final MapEntry(key: path, value: method) in _operations.entries)
      path: {method: (paths[path] as Map<String, dynamic>)[method]},
  };

  final kept = <String, Map<String, dynamic>>{};
  void collect(Object? node) {
    if (node is List) {
      node.forEach(collect);
    } else if (node is Map) {
      final ref = node[r'$ref'];
      if (ref is String) {
        final [_, _, section, name] = ref.split('/');
        final items = kept.putIfAbsent(section, () => {});
        if (!items.containsKey(name)) {
          items[name] = (components[section] as Map<String, dynamic>)[name];
          collect(items[name]);
        }
      }
      node.values.forEach(collect);
    }
  }

  collect(keptPaths);

  final output = {
    ...spec,
    'paths': keptPaths,
    'components': {
      ...kept,
      'securitySchemes': components['securitySchemes'],
    },
  };
  File(_outputPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(output)}\n',
    );
}

Future<Map<String, dynamic>> _download() async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(_specUrl));
    final response = await request.close();
    if (response.statusCode != 200) {
      throw HttpException('Got ${response.statusCode} from $_specUrl');
    }
    final body = await response.transform(utf8.decoder).join();
    return jsonDecode(body) as Map<String, dynamic>;
  } finally {
    client.close();
  }
}
