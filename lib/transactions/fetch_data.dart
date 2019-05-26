import 'package:http/http.dart' as http;

Future<String> fetchData(String url) async {
  http.Response response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('HTTP ${response.statusCode}');
  }
  return response.body;
}
