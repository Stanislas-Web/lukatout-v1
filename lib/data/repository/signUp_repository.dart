// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/models/answer.dart';
import 'package:lukatout/utils/string.util.dart';

class SignUpRepository {
  static String url = StringFormat.getUrlByEnv()+'/api/';

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse("${url}login"));
    request.body = json.encode({"username": username, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      String token = responseJson['token'];
      return {"token": token, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> loginApi() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse("${url}login"));
    request.body = json.encode({"username": "SID-000001", "password": "test"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      String token = responseJson['token'];
      prefs.setString('token', token.toString());
      return {"token": token, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> signup(
      String? nom, String? phone, String? password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    var headers = {
      'Authorization': 'bearer $token',
      'Content-Type': 'application/ld+json'
    };

    Map<String, dynamic> requestBody = {
      "username": phone.toString(),
      "plainPassword": password.toString(),
      "name": nom,
      "gender": ""
    };

    final response = await http.post(
      Uri.parse("${url}account/users"),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return {"status": response.statusCode};
    } else if (response.statusCode == 422) {
      return {
        "status": response.statusCode,
        "msg": "Ce numéro de téléphone est déjà utilisé."
      };
    } else {
      return {
        "status": response.statusCode,
        "msg":
            "L'inscription a rencontré un échec, veuillez prendre contact avec l'équipe pour obtenir de l'assistance."
      };
    }
  }

  static Future<Map<String, dynamic>> getQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}game/questions?page=1&itemsPerPage=15'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getGoodGamer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}account/users?page=1&itemsPerPage=5&order%5BtotalSuccess%5D=desc'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var games = [];
      for (var item in responseJson['hydra:member']) {
        games.add(item);
      }
      return {"data": games, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getActualites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}publication/articles?page=1&itemsPerPage=15'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }


  static Future<Map<String, dynamic>> getCampagnesWithPagination(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}publication/articles?page=$page&itemsPerPage=15&category=Campagne'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

    static Future<Map<String, dynamic>> getCampagnes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}publication/articles?page=1&itemsPerPage=15&category=Campagne'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }


    static Future<Map<String, dynamic>> getRealisationsWithPagination(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}publication/articles?page=$page&itemsPerPage=15&category=R%C3%A9alisation'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getRealisations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}publication/articles?page=1&itemsPerPage=15&category=R%C3%A9alisation'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

    static Future<Map<String, dynamic>> getCampagneWithPagination(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}publication/articles?page=$page&itemsPerPage=15'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getCandidats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}politics/candidates?page=1&itemsPerPage=15'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }


    static Future<Map<String, dynamic>> getCandidatsOnTop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}politics/candidates?itOnTop=true&order%5BitOnTop%5D=desc'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }


      static Future<Map<String, dynamic>> getCandidatsOnTopAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}politics/candidates?order%5BitOnTop%5D=desc'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
      'GET',
      Uri.parse('https://kampeni.injolab.com/custom/question?token=${token}'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);

      // List<dynamic> questions = responseJson['data']; // Accéder à la clé 'data' du JSON

      return {
        "question": responseJson['question'],
        "answers": responseJson['answers'],
        "status": response.statusCode
      };
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> get10Questions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
      'GET',
      Uri.parse('https://kampeni.injolab.com/playing/game?token=${token}'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var responseJson = json.decode(responseBody);


      print("moi   ${responseJson}");

      return {
        "question": responseJson,
        // "answers": responseJson['answers'],
        "status": response.statusCode
      };
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? id = prefs.getString("id");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
      'GET',
      Uri.parse('${url}account/users/${id}'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      return {
        "avatar": responseJson['userAvatar'],
        "totalSuccess": responseJson['totalSuccess'],
        "totalFailed": responseJson['totalFailed'],
        "totalPlay": responseJson["totalPlay"],
        "status": response.statusCode
      };
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getAnswersByQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET', Uri.parse('${url}game/questions?page=1&itemsPerPage=15'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = [];
      for (var item in responseJson['hydra:member']) {
        questions.add(item);
      }
      return {"data": questions};
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<Map<String, dynamic>> getPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? id = prefs.getString("id");
    String? currency = prefs.getString("currency");
    String? createdBy = "/api/account/users/${id}";
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${url}main/payments?page=1&itemsPerPage=15&currency=${currency}&createdBy=${createdBy}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var payments = [];
      for (var item in responseJson['hydra:member']) {
        payments.add(item);
      }
      return {"data": payments, "status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> getAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? idQuestion = prefs.getString("idQuestion");
    var headers = {'Authorization': 'bearer ${token}'};
    var request =
        http.Request('GET', Uri.parse('${url}game/answers/${idQuestion}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      var questions = responseJson;
      // for (var item in responseJson['hydra:member']) {
      //   questions.add(item);
      // }
      return {"data": questions};
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<List> getAnswersByIds(List ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer $token'};

    List<Answer> answers = [];

    for (int id in ids) {
      var request = http.Request(
        'GET',
        Uri.parse('${url}game/answers/$id'),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> responseJson = json.decode(responseBody);

        // Créez l'objet Answer et attribuez-lui les données extraites de responseJson
        Answer answer = Answer(
          context: responseJson['@context'],
          id: responseJson['@id'],
          type: responseJson['@type'],
          answerId: responseJson['id'],
          answer: responseJson['answer'],
          itTrue: responseJson['itTrue'],
          question: responseJson['question'],
          games: responseJson['games'],
          status: responseJson['status'],
          createdAt: DateTime.parse(responseJson['createdAt']),
          createdBy: responseJson['createdBy'],
        );

        // Ajoutez l'objet Answer à la liste des réponses
        answers.add(answer);
      } else {
        throw Exception(response.reasonPhrase);
      }
    }

    return answers;
  }

  static Future<Map<String, dynamic>> postAnswer(
      String? idQuestion, String? idAnswer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? playing = prefs.getString("playing");
    String? id = prefs.getString("id");
    String formattedDate = getCurrentDateTimeInDesiredFormat();

    var headers = {
      'Authorization': 'bearer $token',
      'Content-Type': 'application/ld+json'
    };

    Map<String, dynamic> requestBody = {
      "package": 0,
      "playing": playing,
      "description": "test",
      "question": "/api/game/questions/${idQuestion}",
      "answer": "/api/game/answers/${idAnswer}",
      "status": 0,
      "createdAt": formattedDate,
      "createdBy": "/api/account/users/${id}"
    };

    final response = await http.post(
      Uri.parse("${url}game/games"),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return {"status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }


    static Future<Map<String, dynamic>> updateProfile(
      String gender, String name, String birthDate, String biographie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? id = prefs.getString("id");
    String formattedDate = getCurrentDateTimeInDesiredFormat();

    var headers = {
      'Authorization': 'bearer $token',
      'Content-Type': 'application/ld+json'
    };

    Map<String, dynamic> requestBody = {
    "gender": gender,
    "birthDate": stringToDate(birthDate),
    "biography": biographie,
    "name": name,
    };

    final response = await http.post(
      Uri.parse(
        "${url}account/registration"
        // "https://kampeni.aads-rdc.org/api/account/registration"
        ),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return {"status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }

  static String getCurrentDateTimeInDesiredFormat() {
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now);
    return formattedDate;
  }

    static String stringToDate(String date) {
    // Convert string to DateTime
    DateTime dateTime = DateTime.parse(date);
    // DateTime now = DateTime.now();
    String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime);
    return formattedDate;
  }


  static Future<Map<String, dynamic>> sendPayment(
      String telephone, String amount, String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = generateRandomString(10);
    String? token = prefs.getString("token");
    var headers = {'Authorization': 'bearer ${token}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://kampeni.injolab.com/payment.php?telephone=${telephone}&id=${id}&amount=${amount}&currency=${currency}&token=${token}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      return {"status": response.statusCode, "msg": responseJson["msg"]};
    } else {
      return {"status": response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> cardPaymentV2(String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse("https://cardpayment.flexpay.cd/v1.1/pay"));
    request.body = json.encode({
      "authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJcL2xvZ2luIiwicm9sZXMiOlsiTUVSQ0hBTlQiXSwiZXhwIjoxNzA0NjI2MjUwLCJzdWIiOiI4MjFmZTkyMjRlYzNkNTIzNDJiMWVhNGNjYjdiZmJmMyJ9.QrT-GzNj5MpKVt3eAPOB0G3a1sj98tK-20QCW-fPkz4",
      "merchant": "MAAJABU",
      "reference": "F5887897845",
      "amount": amount,
      "currency": "USD",
      "description": "Cotisation",
      "callback_url": "https://injobyte.com/api/pay/card/index.php",
      "approve_url": "https://localhost",
      "cancel_url": "https://localhost",
      "decline_url": "https://localhost"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      String urlValue = responseJson['url'];
      // Retourner un objet Map avec le token et le code statut
      return {"url": urlValue, "status": response.statusCode};
    } else {
      // Retourner un objet Map avec le code statut
      return {"status": response.statusCode};
    }
  }


    static Future<Map<String, dynamic>> cardPayment(String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tel = prefs.getString("username");
    String? token = prefs.getString("token");
    String ref = generateRandomString(10);
    String devise = "USD";
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse("https://cardpayment.flexpay.cd/v1.1/pay"));
    request.body = json.encode({
      "authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJcL2xvZ2luIiwicm9sZXMiOlsiTUVSQ0hBTlQiXSwiZXhwIjoxNzA0NjI2MjUwLCJzdWIiOiI4MjFmZTkyMjRlYzNkNTIzNDJiMWVhNGNjYjdiZmJmMyJ9.QrT-GzNj5MpKVt3eAPOB0G3a1sj98tK-20QCW-fPkz4",
      "merchant": "MAAJABU",
      "reference": "F5887897845",
      "amount": amount,
      "currency": "USD",
      "description": "Cotisation",
      "callback_url": "https://kampeni.injolab.com/result.php?refernce=$ref&phone=$tel&amount=$amount&currency=$devise&token=$token",
      "approve_url": "https://injobyte.com/api/pay/card/approuved.php",
      "cancel_url": "https://injobyte.com/api/pay/card/canceled.php",
      "decline_url": "https://injobyte.com/api/pay/card/canceled.php"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      String urlValue = responseJson['url'];
      // Retourner un objet Map avec le token et le code statut
      return {"url": urlValue, "status": response.statusCode};
    } else {
      // Retourner un objet Map avec le code statut
      return {"status": response.statusCode};
    }
  }




  static String generateRandomString(int length) {
    const String charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String result = '';
    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(charset.length);
      result += charset[randomIndex];
    }
    return result;
  }

  static Future<Map<String, dynamic>> postPhoto(String id, String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    var headers = {
      'Authorization': 'bearer $token',
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${url}account/avatars'));
    request.fields.addAll({
      'profile': id,
    });
    request.files.add(await http.MultipartFile.fromPath('avatarFile', path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return {"status": response.statusCode};
    } else {
      return {"status": response.statusCode};
    }
  }



}
