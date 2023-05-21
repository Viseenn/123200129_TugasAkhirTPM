import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugasakhirtpm_123200129/model/list_resep.dart';

class BaseNetwork {
  static Future<List<ListResep>> getResep() async {
    var uri = Uri.https('tasty.p.rapidapi.com', '/recipes/list',
        {"from": "42", "size": "25", "tags": "under_30_minutes"});

    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': '9d75e8d359msh99dca93bdd06415p19dba7jsn90fdafe0d499',
      'X-RapidAPI-Host': 'tasty.p.rapidapi.com'
    });

    Map data = jsonDecode(response.body);
    List _temp = [];
    for (var i in data['results']) {
      _temp.add(i);
    }
    return ListResep.resepFromSnapshot(_temp);
  }
}
