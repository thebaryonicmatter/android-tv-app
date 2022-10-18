import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mawaqit/src/models/times.dart';

import '../models/mosque.dart';

const kBaseUrlV2 = 'https://mawaqit.net/api/2.0';
const kBaseUrl = 'https://mawaqit.net/api/3.0';
const token = 'ad283fb2-844b-40fe-967c-5cb593e9005e';

class Api {
  static final dio = Dio(BaseOptions(baseUrl: kBaseUrl));

  static Future<void> init() async {
    // final response = await dio.get(
    //   '$kBaseUrlV2/me',
    //   options: Options(headers: {'Authorization': token}),
    // );
    // //
    // dio.options.headers['Api-Access-Token'] = response.data['apiAccessToken'];
  }

  static Future<bool> checkMosqueExistence(int id) {
    var url = 'https://mawaqit.net/en/id/$id?view=desktop';

    return dio.get(url).then((value) => true).catchError((e) => false);
  }

  static Future<Mosque> getMosque(String id) async {
    final response = await dio.get(
      '/mosque/$id/info',
      options: Options(headers: {
        'Api-Access-Token': token,
      }),
    );

    return Mosque.fromMap(response.data);
  }

  static Future<Times> getMosqueTimes(String id) async {
    final response = await dio.get('/mosque/$id/times');

    return Times.fromMap(response.data);
  }

  static Future<List<Mosque>> searchMosques(String mosque, {page = 1}) async {
    final response = await dio.get('/mosque/search?word=$mosque&page=$page');
    if (response.statusCode == 200) {
      List<Mosque> mosques = [];

      for (var item in response.data) {
        try {
          mosques.add(Mosque.fromMap(item));
        } catch (e, stack) {
          debugPrintStack(label: e.toString(), stackTrace: stack);
        }
      }

      return mosques;
    } else {
      print(response.data);
      // If that response was not OK, throw an error.
      throw Exception('Failed to fetch mosque');
    }
  }
}
