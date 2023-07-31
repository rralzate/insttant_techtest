// Class to create de API connection serverr

import 'dart:convert';
import 'dart:developer';

import 'package:insttant_plus_mobile/core/network/exception.dart';
import 'package:insttant_plus_mobile/core/network/network_info.dart';
import 'package:insttant_plus_mobile/core/network/server_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ServerApiClient {
  final NetworkInfoRepository networkInfoRepository;

  ServerApiClient({
    required this.networkInfoRepository,
  });

  final Map<String, String> _authHeader = {};

  //Here we can access  to external auth header
  Map<String, String> get authHeader => _authHeader;

  // With tahs method ensured the authorization to the headers
  void setAccessToken({
    required String accessToken,
  }) {
    if (accessToken.isNotEmpty) {
      _authHeader[authHeaderKey] = "Bearer $accessToken";
    }
  }

  ///method to process the server response
  Future<T> _proccessResponse<T>({
    required http.Response response,
    required Future<T> Function() requestFunc,
  }) async {
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return response as T;
    } else if (response.statusCode == 401) {
      //
      throw ServerException();
    } else {
      return response as T;
    }
  }

  /// Method to format the log response
  String _formatResponseLog(http.Response response, {Object? requestBody}) {
    final time = DateTime.now().toUtc().toIso8601String();

    JsonEncoder encoder = const JsonEncoder.withIndent(' ');
    String formattedRequestBody =
        requestBody != null ? encoder.convert(requestBody) : '';

    String formattedBodyJson;

    try {
      final json = jsonDecode(response.body);
      formattedBodyJson = encoder.convert(json);
    } catch (_) {
      formattedBodyJson = response.body;
    }

    return '''
          $time
          Request: ${response.request}${formattedRequestBody.isNotEmpty == true ? '\n  Request body: $formattedRequestBody' : ''}
          Response code: ${response.statusCode}
          Body: $formattedBodyJson
          ''';
  }

  ///Method HTTP GET protocol
  Future<http.Response> get(
    path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final url = Uri(
      scheme: serverSchema,
      host: serverAuthority,
      path: path,
      queryParameters: queryParameters,
    );

    http.Response response;

    try {
      response =
          await http.get(url, headers: _authHeader..addAll(headers ?? {}));
    } catch (_) {
      final check = await networkInfoRepository.hasConnection;

      if (!check) {
        //
      }
      rethrow;
    }

    if (kDebugMode) {
      log(_formatResponseLog(response));
    }

    return _proccessResponse(
      response: response,
      requestFunc: () => get(
        path,
        queryParameters: queryParameters,
        headers: headers,
      ),
    );
  }

  ///Method HTTP POST protocol
  ///

  Future<http.Response> post(
    path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final url = Uri(
      scheme: serverSchema,
      host: serverAuthority,
      path: path,
      queryParameters: queryParameters,
    );

    final Map<String, String> allHeaders = _authHeader;

    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (!allHeaders.containsKey('Content-Type')) {
      allHeaders['Content-Type'] = "application/json";
    }

    http.Response response;

    try {
      response = await http.post(
        url,
        headers: allHeaders,
        body: jsonEncode(body),
        encoding: encoding,
      );
    } catch (_) {
      final check = await networkInfoRepository.hasConnection;

      if (!check) {}
      rethrow;
    }

    if (kDebugMode) {
      log(_formatResponseLog(response));
    }

    return _proccessResponse(
      response: response,
      requestFunc: () => post(
        path,
        queryParameters: queryParameters,
        headers: headers,
        body: body,
        encoding: encoding,
      ),
    );
  }
}
