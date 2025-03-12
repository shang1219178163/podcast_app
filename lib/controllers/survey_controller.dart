import 'package:get/get.dart';

class SurveyController extends GetxController {
  final RxString textAnswer = ''.obs;
  final RxString singleChoiceAnswer = ''.obs;
  final RxList<String> multiChoiceAnswers = <String>[].obs;
  final RxList<String> imageUrls = <String>[].obs;
  final RxBool isGoodService = false.obs;
  final RxString bedTime = ''.obs;
  final RxInt satisfactionRating = 0.obs;
  final RxBool isSubmitting = false.obs;
  final Map<String, String?> _warnings = {};

  // 文本输入
  void updateTextAnswer(String value) => textAnswer.value = value;

  // 单选题
  void updateSingleChoice(String value) => singleChoiceAnswer.value = value;

  // 多选题
  void updateMultiChoice(List<String> values) => multiChoiceAnswers.value = values;

  // 图片上传
  void addImage(String url) {
    if (imageUrls.length < 10) {
      imageUrls.add(url);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < imageUrls.length) {
      imageUrls.removeAt(index);
    }
  }

  void updateImages(List<String> images) {
    imageUrls.clear();
    imageUrls.addAll(images);
  }

  // 服务满意度
  void updateServiceSatisfaction(bool value) => isGoodService.value = value;

  // 上床时间
  void updateBedTime(String value) => bedTime.value = value;

  // 满意度评分
  void updateSatisfactionRating(int value) => satisfactionRating.value = value;

  // 警告消息
  String? getTip(String questionId) {
    return _warnings[questionId];
  }

  void setTip(String questionId, String? message) {
    _warnings[questionId] = message;
    update();
  }

  void clearWarningMessage(String questionId) {
    _warnings.remove(questionId);
    update();
  }

  // 提交问卷
  Future<void> submitSurvey() async {
    try {
      isSubmitting.value = true;

      // 构建提交数据
      final Map<String, dynamic> data = {
        'textAnswer': textAnswer.value,
        'singleChoiceAnswer': singleChoiceAnswer.value,
        'multiChoiceAnswers': multiChoiceAnswers,
        'imageUrls': imageUrls,
        'isGoodService': isGoodService.value,
        'bedTime': bedTime.value,
        'satisfactionRating': satisfactionRating.value,
      };

      // TODO: 调用API提交数据
      await Future.delayed(const Duration(seconds: 2)); // 模拟网络请求

      Get.snackbar(
        '提交成功',
        '感谢您的反馈！',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '提交失败',
        '请稍后重试',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // 重置问卷
  void resetSurvey() {
    textAnswer.value = '';
    singleChoiceAnswer.value = '';
    multiChoiceAnswers.clear();
    imageUrls.clear();
    isGoodService.value = false;
    bedTime.value = '';
    satisfactionRating.value = 0;
    _warnings.clear();
    update();
  }
}
