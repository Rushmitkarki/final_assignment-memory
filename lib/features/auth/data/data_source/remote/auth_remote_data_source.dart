import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_assignment/app/constants/api_endpoint.dart';
import 'package:final_assignment/core/failure/failure.dart';
import 'package:final_assignment/features/auth/data/model/auth_api_model.dart';

import 'package:final_assignment/features/auth/domain/entity/auth_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(
    dio: ref.watch(httpServiceProvider),
    authApiModel: ref.watch(authApiModelProvider),
  ),
);
 
class AuthRemoteDataSource {
  final Dio dio;
  final AuthApiModel authApiModel;
 
  AuthRemoteDataSource({
    required this.dio,
    required this.authApiModel,
  });
 
  Future<Either<Failure, bool>> registerUser(AuthEntity authEntity) async {
    try {
      Response response = await dio.post(
        ApiEndPoints.registerUser,
        data: authApiModel.fromEntity(authEntity).toJson(),
      );
      if (response.statusCode == 201) {
        return const Right(true);
      }
      return Left(
        Failure(
            error: response.data['message'],
            statusCode: response.statusCode.toString()),
      );
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}