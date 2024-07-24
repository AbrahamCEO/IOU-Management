import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  final String apiKey =
      'fca_live_2zN1xIFQZ4mECXOrS25ljex3r1xB3kQq2LdYAJZh'; // Replace with your actual API key
  final String apiUrl = 'https://freecurrencyapi.com/api/v2/latest';

  Future<double> getExchangeRate(String currencyCode) async {
    final url = Uri.parse('$apiUrl?apikey=$apiKey&base_currency=USD');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = data['data'][currencyCode] ?? 1.0;
        return rate.toDouble();
      } else {
        throw Exception('Failed to load exchange rate');
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
      return 1.0; // Fallback to 1.0 if there's an error
    }
  }
}
