import 'package:flutter_test/flutter_test.dart';

import 'package:escalada_unit8_exercise/picks.dart';

void main() {
  test('Pick.fromJson reads the Contentful fields', () {
    final pick = Pick.fromJson({
      'fields': {
        'title': 'Test Book',
        'kind': 'book',
        'externalId': 'OL1W',
        'note': 'Nice read',
      },
    });

    expect(pick.title, 'Test Book');
    expect(pick.kind, 'book');
    expect(pick.externalId, 'OL1W');
    expect(pick.note, 'Nice read');
  });
}