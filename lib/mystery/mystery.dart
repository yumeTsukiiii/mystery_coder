import 'dart:convert';

class MysteryCoder {

  List<String> _secret = [];

  final String prefix;
  final String suffix;

  final int multiplier;

  MysteryCoder({
    required String secretText,
    this.multiplier = 2,
    this.prefix = '',
    this.suffix = '',
  }): _secret = secretText.split(''),
    assert(secretText.length % multiplier == 0),
    assert(secretText.length >= 4 && secretText.length % 2 == 0 && secretText.length % 3 != 0);

  String encode(String input) {
    final utf8Codes = utf8.encode(input);
    var result = '';
    result += utf8Codes.map((code) {
      var encoded = '';
      final multiplierSecond = _secret.length ~/ multiplier;
      for (var i = _secret.length - 1; i >= 0; i--) {
        encoded += _secret[(code >> i * multiplier) & (2^multiplierSecond - 1)];
      }
      return encoded;
    }).join('');
    return '$prefix$result$suffix';
  }

  String decode(String input) {
    assert(input.length.isEven);
    input = input.substring(prefix.length, input.length - suffix.length);
    var index = 0;
    var resultCodes = <int>[];
    while(index < input.length) {
      var utf8Unit = 0;
      for (var i = 0; i < _secret.length; i++) {
        utf8Unit += _secret.indexOf(input[index + i]) << (_secret.length - i - 1) * 2;
      }
      index += _secret.length;
      resultCodes.add(utf8Unit);
    }
    return utf8.decode(resultCodes);
  }

}