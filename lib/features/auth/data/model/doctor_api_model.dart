import 'package:final_assignment/features/auth/domain/entity/doctor_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
final doctorApiModelProvider =
    Provider<DoctorApiModel>((ref) => const DoctorApiModel.empty());

@JsonSerializable()
class DoctorApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String doctorName;
  final String doctorField;
  final String doctorExperience;
  final String doctorFee;
  final String doctorImage;

  const DoctorApiModel({
    this.id,
    required this.doctorName,
    required this.doctorField,
    required this.doctorExperience,
    required this.doctorFee,
    required this.doctorImage,

  });
  const DoctorApiModel.empty()
      : id = '',
        doctorName = '',
        doctorField = '',
        doctorExperience = '',
        doctorFee = '',
        doctorImage = '';
    
    DoctorEntity toEntity() {
      return DoctorEntity(
        doctorid: id,
        doctorName: doctorName,
        doctorField: doctorField,
        doctorExperience: doctorExperience,
        doctorFee: doctorFee,
        doctorImage: doctorImage,
      );
    }
    DoctorApiModel fromEntity(DoctorEntity entity) {
      return DoctorApiModel(
        doctorName: entity.doctorName,
        doctorField: entity.doctorField,
        doctorExperience: entity.doctorExperience,
        doctorFee: entity.doctorFee,
        doctorImage: entity.doctorImage,
      );
    }
    factory DoctorApiModel.fromJson(Map<String, dynamic> json) =>
        _$DoctorApiModelFromJson(json);
    Map<String, dynamic> toJson() => _$DoctorApiModelToJson(this);
    @override
    List<Object?> get props => [
          id,
          doctorName,
          doctorField,
          doctorExperience,
          doctorFee,
          doctorImage,
        ];
}
