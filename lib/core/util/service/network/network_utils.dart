import 'dart:convert';
import 'dart:io';

import 'package:example/core/auth/view/login_screen.dart';
import 'package:example/core/util/config.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

enum PaymentType {
  STRIPE_PAYMENT,
  FLUTTER_WAVE_PAYMENT,
  SADAD_PAYMENT,
  RAZORPAY_PAYMENT,
  PAYPAL_PAYMENT,
  SQUARE_PAYMENT,
  AUTHORIZE_NET_PAYMENT,
  GOOGLE_PAY_PAYMENT,
  APPLE_PAY,
}

enum MethodType {
  GET,
  POST,
  DELETE,
  PUT,
  PATCH,
}

class NetworkService {
  call(
    String endPoint, {
    MethodType method = MethodType.GET,
    Map? request,
    PaymentType? type,
  }) async {
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    }

    Map<String, String> headers = _headerTokens(type: type);
    Uri url = Uri.parse('$baseURL$endPoint');

    Response response;

    if (method == MethodType.POST) {
      response = await post(url, body: request, headers: headers);
    } else if (method == MethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == MethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else if (method == MethodType.PATCH) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == MethodType.POST || method == MethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );

    return _handleResponse(response);
  }

  Future callMultiPartRequest(String endPoint, {String? baseUrl}) async {
    String url = '${baseUrl ?? _baseUrl(endPoint).toString()}';
    return _handleMultiPartRequest(MultipartRequest('POST', Uri.parse(url)));
  }

  Map<String, String> _headerTokens({PaymentType? type}) {
    /// Initialize & Handle if key is not present

    Map<String, String> header = {
      HttpHeaders.cacheControlHeader: 'no-cache',
      'Access-Control-Allow-Headers': '*',
      'Access-Control-Allow-Origin': '*',
    };

    if (type != null) {
      if (type == PaymentType.STRIPE_PAYMENT) {
        // TODO IS AVAILABLE THEN ADD KEY STRIPE PAYMENT
      }

      if (type == PaymentType.SADAD_PAYMENT) {
        // TODO IS AVAILABLE THEN ADD KEY SADAD PAYMENT
      }

      if (type == PaymentType.FLUTTER_WAVE_PAYMENT) {
        // TODO IS AVAILABLE THEN ADD KEY FLUTTER WAVE PAYMENT
      }
    }

    return header;
  }

  Future _handleResponse(Response response) async {
    if (!await isNetworkAvailable()) throw errorInternetNotAvailable;

    if (response.statusCode == 401) {
      push(LoginScreen());
      throw 'Token Expired';
    } else if (response.statusCode == 400) {
      throw 'bad Request';
    } else if (response.statusCode == 403) {
      throw 'forbidden';
    } else if (response.statusCode == 404) {
      throw 'page Not Found';
    } else if (response.statusCode == 429) {
      throw 'tooMany Requests';
    } else if (response.statusCode == 500) {
      throw 'internal Server Error';
    } else if (response.statusCode == 502) {
      throw 'bad Gateway';
    } else if (response.statusCode == 503) {
      throw 'service Unavailable';
    } else if (response.statusCode == 504) {
      throw 'gateway Timeout';
    }

    if (response.statusCode.isSuccessful()) {
      return jsonDecode(response.body);
    } else {
      try {
        var body = jsonDecode(response.body);
        throw parseHtmlString(body['message']);
      } on Exception catch (e) {
        log(e);
        throw errorSomethingWentWrong;
      }
    }
  }

  Uri _baseUrl(String endPoint) {
    Uri url = Uri.parse(endPoint);

    if (!endPoint.startsWith('http')) {
      url = Uri.parse('$baseURL$endPoint');
    }

    return url;
  }

  static Future<void> _handleMultiPartRequest(
    MultipartRequest multiPartRequest, {
    Function(dynamic)? onSuccess,
    Function(dynamic)? onError,
  }) async {
    Response response = await Response.fromStream(await multiPartRequest.send());

    apiPrint(
      url: multiPartRequest.url.toString(),
      headers: jsonEncode(multiPartRequest.headers),
      request: jsonEncode(multiPartRequest.fields),
      hasRequest: true,
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: "MultiPart",
    );

    if (response.statusCode.isSuccessful()) {
      if (response.body.isJson()) {
        onSuccess?.call(response.body);
      } else {
        onSuccess?.call(response.body);
      }
    } else {
      try {
        if (response.body.isJson()) {
          var body = jsonDecode(response.body);
          onError?.call(body['message'] ?? errorSomethingWentWrong);
        } else {
          onError?.call(errorSomethingWentWrong);
        }
      } on Exception catch (e) {
        log(e);
        onError?.call(errorSomethingWentWrong);
      }
    }
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("\u001b[93m Url: \u001B[39m $url");
  log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
  log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
  log("\u001b[93m Request: \u001B[39m \u001b[96m$request\u001B[39m");
  log("${statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m"}");
  log('Response ($methodtype) $statusCode: $responseBody');
  log("\u001B[0m");
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}
