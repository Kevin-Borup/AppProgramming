import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class HttpClientService{
  late final HttpClient _httpClient;
  HttpClient get httpClient => _httpClient;

  HttpClientService(){
    _initializeHttpClient();
  }

  void _initializeHttpClient() async {
    ByteData data = await rootBundle.load('assets/certificates/localhost+3.p12');
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    SecurityContext sContext = SecurityContext();
    sContext.setTrustedCertificatesBytes(bytes, password: "localhostKode1234!");
    _httpClient = HttpClient(context: sContext);
  }


  // Future<HttpClientService> init() async {
  //   ByteData data = await rootBundle.load('assets/certificates/localhost+3.p12');
  //   List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //
  //   SecurityContext sContext = SecurityContext();
  //   sContext.setTrustedCertificatesBytes(bytes, password: "localhostKode1234!");
  //   _httpClient = HttpClient(context: sContext);
  //   return this;
  // }
}