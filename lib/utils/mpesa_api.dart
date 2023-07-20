import 'package:http/http.dart' as http;
import 'dart:convert';

class MpesaAPI {
  String consumerKey;
  String consumerSecret;
  String shortcode;
  String passkey;

  MpesaAPI(this.consumerKey, this.consumerSecret, this.shortcode, this.passkey);

  Future<Map<String, dynamic>> checkTransactionStatus(String transactionId) async {
    String accessToken = await _generateAccessToken();

    final url = Uri.parse('https://api.safaricom.co.ke/mpesa/transactionstatus/v1/query');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = json.encode({
      'BusinessShortCode': shortcode,
      'Password': _generatePassword(),
      'Timestamp': _generateTimestamp(),
      'TransactionType': 'TransactionStatusQuery',
      'TransactionID': transactionId,
      'PartyA': shortcode,
      'IdentifierType': '4',
      'ResultURL': '',
      'QueueTimeOutURL': '',
      'Remarks': '',
      'Occasion': '',
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to check transaction status: ${response.statusCode}');
    }
  }

  Future<String> _generateAccessToken() async {
    final url = Uri.parse('https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final tokenData = json.decode(response.body);
      return tokenData['access_token'];
    } else {
      throw Exception('Failed to generate access token: ${response.statusCode}');
    }
  }

  String _generatePassword() {
    final time = _generateTimestamp();
    final password = '$shortcode$passkey$time';
    final encodedPassword = base64Encode(utf8.encode(password));
    return encodedPassword;
  }

  String _generateTimestamp() {
    final now = DateTime.now();
    final timestamp = now.toString().split('.')[0];
    return timestamp;
  }
}

// Transaction details
String transactionId = 'YOUR_TRANSACTION_ID';

// Set your M-Pesa API credentials
String consumerKey = 'YOUR_CONSUMER_KEY';
String consumerSecret = 'YOUR_CONSUMER_SECRET';
String shortcode = 'YOUR_SHORTCODE';
String passkey = 'YOUR_PASSKEY';

void main() async {
  final mpesaApi = MpesaAPI(consumerKey, consumerSecret, shortcode, passkey);
  try {
    final response = await mpesaApi.checkTransactionStatus(transactionId);
    if (response['ResponseCode'] == '0') {
      print('Transaction status: ${response['ResponseDescription']}');
    } else {
      print('Error: ${response['ResponseDescription']}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}