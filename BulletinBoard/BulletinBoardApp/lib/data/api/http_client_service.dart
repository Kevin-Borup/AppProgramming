import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class HttpClientService {
  late final HttpClient _httpClient;
  HttpClient get httpClient => _httpClient;

  Future<HttpClientService> init() async {
    await _initializeHttpClient();
    return this;
  }

  Future<void> _initializeHttpClient() async {
    try {
      // ByteData data = await rootBundle.load('assets/certificates/localhost+3-client.p12');
      ByteData dataP12 = await rootBundle.load('assets/certificates/localhost+2-client.p12');
      List<int> serverP12 = dataP12.buffer.asUint8List();

      ByteData dataPem = await rootBundle.load('assets/certificates/localhost+2-client.pem');
      List<int> clientPem = dataP12.buffer.asUint8List();

      ByteData dataPemKey = await rootBundle.load('assets/certificates/localhost+2-client-key.pem');
      List<int> clientPemKey = dataP12.buffer.asUint8List();

      // ByteData serverCert = await rootBundle.load('assets/certificates/localhost+3.pem');
      // ByteData pfxData = await rootBundle.load('assets/certificates/localhost.pfx');
      // ByteData keystore = await rootBundle.load('assets/certificates/localhost+3-key.pem');
      // List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // List<int> pfxBytes = pfxData.buffer.asUint8List();

      // var fullChain = Platform.script.resolve('assets/certificates/localhost+3.p12').toFilePath();
      // var fullChain = Platform.script.resolve('C:\\ZBC Data-Kommunikation\\H3\\AppProgrammering\\BulletinBoard\\BulletinBoardApp\assets\certificates/localhost+3.p12').toFilePath();

      SecurityContext sContext = SecurityContext();
      // SecurityContext sContext = SecurityContext(withTrustedRoots: true);
      // SecurityContext sContext = SecurityContext.defaultContext;
      // sContext.useCertificateChainBytes(clientCert.buffer.asUint8List());
      // sContext.usePrivateKeyBytes(keystore.buffer.asUint8List(), password: "localhostKode1234!");
      // sContext.useCertificateChain(fullChain);
      // sContext.setTrustedCertificatesBytes(data.buffer.asUint8List(), password: "localhostKode1234!");
      sContext.setTrustedCertificatesBytes(serverP12, password: "changeit");
      // sContext.setTrustedCertificatesBytes(serverCert.buffer.asUint8List(), password: "localhostKode1234!");
      sContext.useCertificateChainBytes(clientPem, password: "changeit");
      // sContext.useCertificateChainBytes(pfxBytes,
      //     password: "localhostKode1234!");
      sContext.usePrivateKeyBytes(clientPemKey, password: "changeit");
      // sContext.usePrivateKeyBytes(pfxBytes, password: "localhostKode1234!");
      // sContext.setClientAuthoritiesBytes(data.buffer.asUint8List(), password: "localhostKode1234!");
      _httpClient = HttpClient(context: sContext);
    } on Exception {
      if (kDebugMode) {
        print(Exception);
      }
    }
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
