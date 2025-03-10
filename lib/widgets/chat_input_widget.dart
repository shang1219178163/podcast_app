import 'package:flutter/material.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendText;
  final Function(String, int) onSendVoice;
  final Function(String) onSendImage;
  final Function(String) onSendEmoji;

  const ChatInputWidget({
    super.key,
    required this.onSendText,
    required this.onSendVoice,
    required this.onSendImage,
    required this.onSendEmoji,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isVoiceMode = false;
  bool _isEmojiMode = false;
  bool _isMoreMode = false;
  bool _isRecording = false;

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 输入栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  // 语音/键盘切换按钮
                  IconButton(
                    icon: Icon(
                      _isVoiceMode ? Icons.keyboard : Icons.mic,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _isVoiceMode = !_isVoiceMode;
                        if (_isVoiceMode) {
                          _focusNode.unfocus();
                          _isEmojiMode = false;
                          _isMoreMode = false;
                        }
                      });
                    },
                  ),

                  // 输入框或语音按钮
                  Expanded(
                    child: _isVoiceMode
                        ? GestureDetector(
                            onLongPressStart: (_) {
                              setState(() => _isRecording = true);
                              // TODO: 开始录音
                            },
                            onLongPressEnd: (_) {
                              setState(() => _isRecording = false);
                              // TODO: 结束录音并发送
                              widget.onSendVoice('voice_path', 10);
                            },
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: _isRecording ? Colors.grey[300] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  _isRecording ? '松开发送' : '按住说话',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            maxLines: 4,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: '输入消息...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                  ),

                  // 表情按钮
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: _isEmojiMode ? Theme.of(context).primaryColor : Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _isEmojiMode = !_isEmojiMode;
                        _isMoreMode = false;
                        if (_isEmojiMode) {
                          _focusNode.unfocus();
                          _isVoiceMode = false;
                        }
                      });
                    },
                  ),

                  // 发送或更多按钮
                  if (_textController.text.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        final text = _textController.text;
                        if (text.isNotEmpty) {
                          widget.onSendText(text);
                          _textController.clear();
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        '发送',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: _isMoreMode ? Theme.of(context).primaryColor : Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isMoreMode = !_isMoreMode;
                          _isEmojiMode = false;
                          if (_isMoreMode) {
                            _focusNode.unfocus();
                            _isVoiceMode = false;
                          }
                        });
                      },
                    ),
                ],
              ),
            ),

            // 表情面板
            if (_isEmojiMode)
              Container(
                height: 200,
                color: Colors.white,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onSendEmoji('emoji_$index');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '😀',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // 更多面板
            if (_isMoreMode)
              Container(
                height: 200,
                color: Colors.white,
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildMoreItem(
                      icon: Icons.image,
                      label: '相册',
                      onTap: () {
                        // TODO: 选择图片
                        widget.onSendImage('image_path');
                      },
                    ),
                    _buildMoreItem(
                      icon: Icons.camera_alt,
                      label: '拍摄',
                      onTap: () {
                        // TODO: 拍摄照片或视频
                      },
                    ),
                    _buildMoreItem(
                      icon: Icons.videocam,
                      label: '视频通话',
                      onTap: () {
                        // TODO: 发起视频通话
                      },
                    ),
                    _buildMoreItem(
                      icon: Icons.location_on,
                      label: '位置',
                      onTap: () {
                        // TODO: 发送位置
                      },
                    ),
                    _buildMoreItem(
                      icon: Icons.person,
                      label: '个人名片',
                      onTap: () {
                        // TODO: 发送个人名片
                      },
                    ),
                    _buildMoreItem(
                      icon: Icons.file_present,
                      label: '文件',
                      onTap: () {
                        // TODO: 发送文件
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
