import 'package:http/http.dart' as http;

String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  final errorMessage =
      'Request failed with status code: $statusCode and reason phrase: $reasonPhrase';

  return errorMessage;
}
