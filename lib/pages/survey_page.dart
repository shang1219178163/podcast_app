import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extension/list_ext.dart';
import 'package:podcast_app/utils/R.dart';
import '../controllers/survey_controller.dart';
import '../widgets/questions/question_container.dart';
import '../widgets/questions/question_text.dart';
import '../widgets/questions/question_single_choice.dart';
import '../widgets/questions/question_multi_choice.dart';
import '../widgets/questions/question_image_upload.dart';
import '../widgets/questions/question_rating.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late final SurveyController controller;
  final RxInt selectedQuestionIndex = (-1).obs;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SurveyController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildQuestionList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        '量表',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: const Text(
        '住院病人调查统计表',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuestionList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() => Column(
            children: [
              QuestionContainer(
                title: '1.近期运动情况，请详细描述',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionText(
                      initialValue: controller.textAnswer.value,
                      onChanged: (value) {
                        controller.updateTextAnswer(value);
                        selectedQuestionIndex.value = 0;
                      },
                      tip: controller.getTip('1'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QuestionContainer(
                title: '2.住院期间对医院服务总体感觉',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionSingleChoice(
                      choices: const [
                        Choice('好', '(52)'),
                        Choice('一般', '(49)'),
                        Choice('差', '(32)'),
                        Choice('其他', '(12)'),
                      ],
                      initialValue: controller.singleChoiceAnswer.value,
                      onChanged: controller.updateSingleChoice,
                      onSelect: (_) => selectedQuestionIndex.value = 1,
                      tip: controller.getTip('2'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QuestionContainer(
                title: '3.您有以下哪些症状',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionMultiChoice(
                      options: const [
                        '头痛头晕',
                        '恶心呕吐',
                        '睡眠困难',
                        '呼吸困难',
                        '晕血症状',
                        '四肢发麻',
                      ],
                      initialValues: controller.multiChoiceAnswers,
                      onChanged: (values) {
                        controller.updateMultiChoice(values);
                        selectedQuestionIndex.value = 2;
                      },
                      tip: controller.getTip('3'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QuestionContainer(
                title: '4.住院期间您做了哪些辅助检查',
                subtitle: '注：最多可上传10张，每张图片大小不超过2M',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionImageUpload(
                      images: controller.imageUrls,
                      tip: controller.getTip('4'),
                      onAddImage: () async {
                        selectedQuestionIndex.value = 3;
                        // TODO: 实现图片选择和上传
                        final url = R.image.urls.randomOne;
                        if (url == null) {
                          return;
                        }
                        controller.addImage(url);
                      },
                      onRemoveImage: controller.removeImage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QuestionContainer(
                title: '5.住院期间对医院服务总体感觉是好',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionSingleChoice(
                      choices: const [
                        Choice('是', ''),
                        Choice('否', ''),
                      ],
                      initialValue: controller.isGoodService.value ? '是' : '否',
                      onChanged: (value) {
                        controller.updateServiceSatisfaction(value == '是');
                        selectedQuestionIndex.value = 4;
                      },
                      onSelect: (_) => selectedQuestionIndex.value = 4,
                      tip: controller.getTip('5'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QuestionContainer(
                title: '6.近1个月，晚上上床时间通常在几点？',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionSingleChoice(
                      choices: const [
                        Choice('八点', ''),
                        Choice('十一点', ''),
                      ],
                      initialValue: controller.bedTime.value,
                      onChanged: controller.updateBedTime,
                      onSelect: (_) => selectedQuestionIndex.value = 5,
                      tip: controller.getTip('6'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QuestionContainer(
                title: '7.对医生健康建议满意度',
                isRequired: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionRating(
                      options: const [
                        RatingOption('不满意', 1),
                        RatingOption('一般', 2),
                        RatingOption('非常满意', 3),
                      ],
                      initialValue: controller.satisfactionRating.value,
                      onChanged: (value) {
                        controller.updateSatisfactionRating(value);
                        selectedQuestionIndex.value = 6;
                      },
                      tip: controller.getTip('7'),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() => ElevatedButton(
            onPressed: controller.isSubmitting.value ? null : controller.submitSurvey,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: controller.isSubmitting.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    '提交',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          )),
    );
  }
}
