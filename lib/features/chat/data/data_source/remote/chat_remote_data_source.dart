import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_assignment/app/constants/api_endpoint.dart';
import 'package:final_assignment/core/networking/remote/http_service.dart';
import 'package:final_assignment/core/shared_prefs/user_shared_prefs.dart';
import 'package:final_assignment/features/chat/data/dto/get_message_dto.dart';
import 'package:final_assignment/features/chat/domain/entity/message_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/failure/failure.dart';
import '../../../domain/entity/chat_entity.dart';
import '../../dto/get_chat_dto.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>(
  (ref) => ChatRemoteDataSource(
    ref.read(httpServiceProvider),
    ref.read(userSharedPrefsProvider),
  ),
);

class ChatRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPreferences;

  ChatRemoteDataSource(this.dio, this.userSharedPreferences);

  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      String? token;
      final data = await userSharedPreferences.getUserToken();
      data.fold((l) => null, (r) => token = r);

      final response = await dio.get(ApiEndPoints.getChat,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        final getChatDto = GetChatDto.fromJson(response.data);
        return Right(getChatDto.results.map((e) => e.toEntity()).toList());
      } else {
        return Left(Failure(error: response.statusMessage.toString()));
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<MessageEntity>>> getMessages(String id) async {
    try {
      String? token;
      final data = await userSharedPreferences.getUserToken();
      data.fold((l) => null, (r) => token = r);

      final response = await dio.get(ApiEndPoints.allmessage + id,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        final getMessageDto = GetMessageDto.fromJson(response.data);
        return Right(getMessageDto.messages.map((e) => e.toEntity()).toList());
      } else {
        return Left(Failure(error: response.statusMessage.toString()));
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
