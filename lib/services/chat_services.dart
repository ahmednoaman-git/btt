import 'package:dio/dio.dart';

class ChatServices {
  static const endpoint = "https://api.deepinfra.com/v1/inference/meta-llama/Llama-2-70b-chat-hf";
  static const apiKey = 'E3v1fKD70UgTgBFTjXgLc5fHKbl9ifYJ';

  static Future<Response> sendAndRecieveMessage(String message) async {
    final Map<String, dynamic> data = {
      "input": "[INST]$message[/INST] ",
    };

    final Map<String, dynamic> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final Response response = await Dio().post(
      endpoint,
      data: data,
      options: Options(headers: header),
    );

    return response;
  }
}
