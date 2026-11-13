import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

const contentfulSpace = String.fromEnvironment('CONTENTFUL_SPACE');
const contentfulToken = String.fromEnvironment('CONTENTFUL_TOKEN');

class Pick {
  final String title;
  final String kind; // 'book' or 'movie'
  final String externalId;
  final String note;

  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    // Strapi 5 puts fields directly on the item; Strapi 4 nests them in "attributes".
    final data = (json['fields'] as Map<String, dynamic>?) ?? json;
    return Pick(
      title: data['title'] as String? ?? '',
      kind: data['kind'] as String? ?? 'book',
      externalId: data['externalId'] as String? ?? '',
      note: data['note'] as String? ?? '',
    );
  }
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpace/environments/master/entries',
      {'content_type': 'pick', 'access_token': contentfulToken},
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('CMS error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>;
    return [for (final i in items) Pick.fromJson(i as Map<String, dynamic>)];
  }
}