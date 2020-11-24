import 'package:flutter_test/flutter_test.dart';
import 'package:revault_app/auctionList.dart';
import 'package:revault_app/auctionGood.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}
// 경매 리스트 불러오기 테스트
void main() {
  group('fetchGoodList', () {
    test('호출이 성공하면 경매 상품 리스트를 받는다', () async {
      final client = MockClient();

      when(client.get('https://ibsoft.site/revault/getAuctionList'))
        .thenAnswer((_) async => http.Response('[]', 200));

      expect(await fetchGoodList(1), isA<List<AuctionGood>>());
    });

    test('호출이 실패하면 exception을 던진다', () async {
      final client = MockClient();

      when(client.get('https://ibsoft.site/revault/getAuctionList'))
        .thenAnswer((_) async => http.Response('[]', 200));

      expect(await fetchGoodList(-1), isA<List<AuctionGood>>());
    });
  });
}
