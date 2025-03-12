import 'package:get/get.dart';

class SurveyModel {
  final RxString textAnswer = ''.obs;
  final RxString singleChoiceAnswer = ''.obs;
  final RxList<String> multiChoiceAnswers = <String>[].obs;
  final RxList<String> imageUrls = <String>[].obs;
  final RxBool isGoodService = false.obs;
  final RxString bedTime = ''.obs;
  final RxInt satisfactionRating = 0.obs;

  bool get isValid {
    return textAnswer.isNotEmpty &&
        singleChoiceAnswer.isNotEmpty &&
        multiChoiceAnswers.isNotEmpty &&
        bedTime.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'textAnswer': textAnswer.value,
      'singleChoiceAnswer': singleChoiceAnswer.value,
      'multiChoiceAnswers': multiChoiceAnswers.toList(),
      'imageUrls': imageUrls.toList(),
      'isGoodService': isGoodService.value,
      'bedTime': bedTime.value,
      'satisfactionRating': satisfactionRating.value,
    };
  }
}
