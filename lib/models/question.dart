import 'package:flutter/material.dart';

/// 问题类型枚举
enum QuestionType {
  text, // 文本输入
  singleChoice, // 单选
  multiChoice, // 多选
  imageUpload, // 图片上传
  rating // 评分
}

/// 选项模型
class QuestionOption {
  final String id; // 选项ID
  final String title; // 选项标题
  final String? subtitle; // 选项副标题（如计数）
  final dynamic value; // 选项值

  const QuestionOption({
    required this.id,
    required this.title,
    this.subtitle,
    required this.value,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'value': value,
    };
  }
}

/// 问题校验规则
class QuestionValidation {
  final bool required; // 是否必填
  final int? minLength; // 最小长度
  final int? maxLength; // 最大长度
  final int? minSelect; // 最少选择数量
  final int? maxSelect; // 最多选择数量
  final int? minImages; // 最少图片数量
  final int? maxImages; // 最多图片数量
  final String? pattern; // 正则表达式
  final String? errorMessage; // 自定义错误消息

  const QuestionValidation({
    this.required = false,
    this.minLength,
    this.maxLength,
    this.minSelect,
    this.maxSelect,
    this.minImages,
    this.maxImages,
    this.pattern,
    this.errorMessage,
  });

  factory QuestionValidation.fromJson(Map<String, dynamic> json) {
    return QuestionValidation(
      required: json['required'] as bool? ?? false,
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
      minSelect: json['minSelect'] as int?,
      maxSelect: json['maxSelect'] as int?,
      minImages: json['minImages'] as int?,
      maxImages: json['maxImages'] as int?,
      pattern: json['pattern'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'minLength': minLength,
      'maxLength': maxLength,
      'minSelect': minSelect,
      'maxSelect': maxSelect,
      'minImages': minImages,
      'maxImages': maxImages,
      'pattern': pattern,
      'errorMessage': errorMessage,
    };
  }
}

/// 问题模型
class Question {
  final String id; // 问题ID
  final String title; // 问题标题
  final String? subtitle; // 问题副标题
  final QuestionType type; // 问题类型
  final List<QuestionOption>? options; // 问题选项
  final QuestionValidation validation; // 校验规则
  final dynamic value; // 当前值
  final String? tip; // 警告消息
  final bool enabled; // 是否启用
  final bool visible; // 是否可见
  final Map<String, dynamic>? extra; // 额外数据

  const Question({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    this.options,
    this.validation = const QuestionValidation(),
    this.value,
    this.tip,
    this.enabled = true,
    this.visible = true,
    this.extra,
  });

  /// 校验问题答案
  String? validate() {
    // 必填校验
    if (validation.required && (value == null || value.toString().isEmpty)) {
      return validation.errorMessage ?? '此题为必填项';
    }

    // 根据问题类型进行校验
    switch (type) {
      case QuestionType.text:
        if (value != null) {
          final String text = value.toString();
          if (validation.minLength != null && text.length < validation.minLength!) {
            return '最少需要输入 ${validation.minLength} 个字符';
          }
          if (validation.maxLength != null && text.length > validation.maxLength!) {
            return '最多只能输入 ${validation.maxLength} 个字符';
          }
          if (validation.pattern != null) {
            final RegExp regex = RegExp(validation.pattern!);
            if (!regex.hasMatch(text)) {
              return validation.errorMessage ?? '输入格式不正确';
            }
          }
        }
        break;

      case QuestionType.multiChoice:
        if (value != null) {
          final List<String> selected = (value as List).cast<String>();
          if (validation.minSelect != null && selected.length < validation.minSelect!) {
            return '最少需要选择 ${validation.minSelect} 项';
          }
          if (validation.maxSelect != null && selected.length > validation.maxSelect!) {
            return '最多只能选择 ${validation.maxSelect} 项';
          }
        }
        break;

      case QuestionType.imageUpload:
        if (value != null) {
          final List<String> images = (value as List).cast<String>();
          if (validation.minImages != null && images.length < validation.minImages!) {
            return '最少需要上传 ${validation.minImages} 张图片';
          }
          if (validation.maxImages != null && images.length > validation.maxImages!) {
            return '最多只能上传 ${validation.maxImages} 张图片';
          }
        }
        break;

      default:
        break;
    }

    return null;
  }

  /// 从 JSON 创建问题
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${json['type']}',
      ),
      options: (json['options'] as List<dynamic>?)
          ?.map(
            (e) => QuestionOption.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      validation: QuestionValidation.fromJson(
        json['validation'] as Map<String, dynamic>? ?? {},
      ),
      value: json['value'],
      tip: json['tip'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      visible: json['visible'] as bool? ?? true,
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type.toString().split('.').last,
      'options': options?.map((e) => e.toJson()).toList(),
      'validation': validation.toJson(),
      'value': value,
      'tip': tip,
      'enabled': enabled,
      'visible': visible,
      'extra': extra,
    };
  }

  /// 创建问题副本
  Question copyWith({
    String? id,
    String? title,
    String? subtitle,
    QuestionType? type,
    List<QuestionOption>? options,
    QuestionValidation? validation,
    dynamic value,
    String? tip,
    bool? enabled,
    bool? visible,
    Map<String, dynamic>? extra,
  }) {
    return Question(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      options: options ?? this.options,
      validation: validation ?? this.validation,
      value: value ?? this.value,
      tip: tip ?? this.tip,
      enabled: enabled ?? this.enabled,
      visible: visible ?? this.visible,
      extra: extra ?? this.extra,
    );
  }
}
