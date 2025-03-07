import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:math';
import 'dart:async';
import 'dart:math' as math;
import '../utils/log_util.dart';

class AudioPlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  final RxDouble progress = 0.0.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxDouble volume = 1.0.obs;
  final RxBool isMuted = false.obs;
  final RxBool isLooping = false.obs;
  final RxBool isShuffle = false.obs;
  final RxDouble playbackSpeed = 1.0.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isDownloaded = false.obs;
  final RxList<String> playlistUrls = <String>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxBool showVolumeSlider = false.obs;

  // 均衡器相关
  final RxList<double> equalizerBands = List.filled(5, 0.5).obs;
  final RxString currentPreset = '默认'.obs;

  // 睡眠定时器相关
  final RxInt sleepTimerMinutes = 0.obs;
  Timer? _sleepTimer;

  // 音频可视化相关
  final RxList<double> visualizationData = List.filled(32, 0.0).obs;
  final RxList<double> volumeHistory = <double>[].obs;
  Timer? _visualizationTimer;
  final RxBool isVisualizationActive = true.obs;

  // 均衡器预设
  final Map<String, List<double>> equalizerPresets = {
    '默认': [0.5, 0.5, 0.5, 0.5, 0.5],
    '流行': [0.6, 0.7, 0.8, 0.7, 0.6],
    '摇滚': [0.8, 0.7, 0.6, 0.7, 0.8],
    '爵士': [0.4, 0.5, 0.6, 0.5, 0.4],
    '古典': [0.3, 0.4, 0.5, 0.4, 0.3],
  };

  // 测试音频列表
  final List<Map<String, String>> _testPlaylist = [
    {
      'title': '未来科技浪潮',
      'author': '科技早知道',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'cover': 'https://picsum.photos/200',
    },
    {
      'title': '人工智能革命',
      'author': 'AI 前沿',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'cover': 'https://picsum.photos/201',
    },
    {
      'title': '区块链技术解析',
      'author': '区块链研究院',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'cover': 'https://picsum.photos/202',
    },
    {
      'title': '元宇宙发展前景',
      'author': '元宇宙观察',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'cover': 'https://picsum.photos/203',
    },
    {
      'title': '量子计算突破',
      'author': '量子科技',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      'cover': 'https://picsum.photos/204',
    },
    {
      'title': '生物科技前沿',
      'author': '生物科技周刊',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      'cover': 'https://picsum.photos/205',
    },
    {
      'title': '新能源技术革新',
      'author': '能源科技',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'cover': 'https://picsum.photos/206',
    },
    {
      'title': '5G应用展望',
      'author': '通信科技',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      'cover': 'https://picsum.photos/207',
    },
    {
      'title': '机器人技术发展',
      'author': '机器人研究院',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      'cover': 'https://picsum.photos/208',
    },
    {
      'title': '太空探索新纪元',
      'author': '航天科技',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
      'cover': 'https://picsum.photos/209',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _initAudioPlayer();
    _initPlaylist();
    // 初始化可视化数据
    visualizationData.value = List.filled(32, 0.0);
    _startVisualizationTimer();
  }

  void _initPlaylist() {
    playlistUrls.value = _testPlaylist.map((item) => item['url']!).toList();
    currentIndex.value = 0;
  }

  Future<void> _initAudioPlayer() async {
    LogUtil.i('初始化音频播放器');
    try {
      // 设置音频会话
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      ));
      LogUtil.i('音频会话配置成功');

      // 监听播放状态
      _audioPlayer.playerStateStream.listen((state) {
        LogUtil.d('播放状态变化: ${state.playing}, ${state.processingState}');
        isPlaying.value = state.playing;
        isBuffering.value = state.processingState == ProcessingState.buffering;

        // 只在开始新的播放时重置可视化
        if (state.processingState == ProcessingState.ready && !state.playing) {
          isVisualizationActive.value = false;
          visualizationData.value = List.filled(32, 0.0);
        }

        // 开始播放时激活可视化
        if (state.playing) {
          isVisualizationActive.value = true;
        }

        // 播放结束时自动播放下一首
        if (state.processingState == ProcessingState.completed) {
          playNext();
        }
      });

      // 监听进度
      _audioPlayer.positionStream.listen((pos) {
        position.value = pos;
        if (duration.value.inMilliseconds > 0) {
          progress.value = pos.inMilliseconds / duration.value.inMilliseconds;
        }
      });

      // 监听总时长
      _audioPlayer.durationStream.listen((dur) {
        LogUtil.d('音频时长: ${dur?.inSeconds}秒');
        duration.value = dur ?? Duration.zero;
      });

      // 监听音量变化用于可视化
      _audioPlayer.volumeStream.listen((vol) {
        volume.value = vol;
        isMuted.value = vol == 0;

        // 更新音量历史数据
        final history = List<double>.from(volumeHistory);
        history.add(vol);
        if (history.length > 32) {
          history.removeAt(0);
        }
        volumeHistory.value = history;

        _updateVisualizationData();
      });

      // 监听播放速度
      _audioPlayer.speedStream.listen((speed) {
        LogUtil.d('播放速度变化: $speed');
        playbackSpeed.value = speed;
      });

      // 监听循环状态
      _audioPlayer.loopModeStream.listen((mode) {
        LogUtil.d('循环模式变化: $mode');
        isLooping.value = mode != LoopMode.off;
      });

      // 监听错误
      _audioPlayer.playbackEventStream.listen(
        (event) {},
        onError: (Object e, StackTrace st) {
          LogUtil.e('播放错误: $e');
          LogUtil.e('错误堆栈: $st');
          Get.snackbar(
            '错误',
            '播放出错: $e',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );

      LogUtil.i('音频播放器初始化完成');
    } catch (e) {
      LogUtil.e('初始化错误: $e');
      Get.snackbar(
        '错误',
        '播放器初始化失败: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> switchTrack(int index) async {
    LogUtil.d('切换到音频: $index');
    try {
      if (index != currentIndex.value) {
        // 先更新索引，这样 UI 会立即更新
        currentIndex.value = index;
        // 然后开始播放
        await play(playlistUrls[currentIndex.value]);
      } else {
        // 如果是当前播放的音频，则切换播放/暂停状态
        if (isPlaying.value) {
          await pause();
        } else {
          await resume();
        }
      }
    } catch (e) {
      LogUtil.e('切换音频错误: $e');
      Get.snackbar(
        '错误',
        '切换音频失败: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> play(String url) async {
    LogUtil.d('开始播放音频: $url');
    try {
      await _audioPlayer.setUrl(url);
      LogUtil.d('音频 URL 设置成功');
      await _audioPlayer.play();
      LogUtil.i('开始播放');
    } catch (e) {
      LogUtil.e('播放错误: $e');
      Get.snackbar(
        '错误',
        '音频播放失败: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> playNext() async {
    if (playlistUrls.isEmpty) return;

    if (isShuffle.value) {
      currentIndex.value = Random().nextInt(playlistUrls.length);
    } else {
      currentIndex.value = (currentIndex.value + 1) % playlistUrls.length;
    }

    await play(playlistUrls[currentIndex.value]);
  }

  Future<void> playPrevious() async {
    if (playlistUrls.isEmpty) return;

    if (isShuffle.value) {
      currentIndex.value = Random().nextInt(playlistUrls.length);
    } else {
      currentIndex.value = (currentIndex.value - 1 + playlistUrls.length) % playlistUrls.length;
    }

    await play(playlistUrls[currentIndex.value]);
  }

  Future<void> toggleShuffle() async {
    isShuffle.value = !isShuffle.value;
    if (isShuffle.value) {
      isLooping.value = false;
      await setLoopMode(false);
    }
  }

  Future<void> toggleLoop() async {
    isLooping.value = !isLooping.value;
    await setLoopMode(isLooping.value);
    if (isLooping.value) {
      isShuffle.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    isFavorite.value = !isFavorite.value;
    Get.snackbar(
      '提示',
      isFavorite.value ? '已添加到收藏' : '已取消收藏',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> toggleDownload() async {
    isDownloaded.value = !isDownloaded.value;
    Get.snackbar(
      '提示',
      isDownloaded.value ? '已开始下载' : '已取消下载',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> toggleVolumeSlider() async {
    showVolumeSlider.value = !showVolumeSlider.value;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  Future<void> setLoopMode(bool isLooping) async {
    await _audioPlayer.setLoopMode(
      isLooping ? LoopMode.one : LoopMode.off,
    );
  }

  Map<String, String> get currentTrack => _testPlaylist[currentIndex.value];

  List<Map<String, String>> get tracks => _testPlaylist;

  // 设置均衡器预设
  void setEqualizerPreset(String preset) {
    if (equalizerPresets.containsKey(preset)) {
      equalizerBands.value = List.from(equalizerPresets[preset]!);
      currentPreset.value = preset;
    }
  }

  // 更新均衡器频段
  void updateEqualizerBand(int index, double value) {
    if (index >= 0 && index < equalizerBands.length) {
      equalizerBands[index] = value;
      // TODO: 应用均衡器设置到音频播放器
    }
  }

  // 设置睡眠定时器
  void setSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    sleepTimerMinutes.value = minutes;

    if (minutes > 0) {
      _sleepTimer = Timer(Duration(minutes: minutes), () {
        pause();
        sleepTimerMinutes.value = 0;
      });
    }
  }

  // 取消睡眠定时器
  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    sleepTimerMinutes.value = 0;
  }

  // 开始音频可视化
  void startVisualization() {
    // _visualizationTimer?.cancel();
    // _visualizationTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
    //   // 模拟音频数据
    //   final random = Random();
    //   visualizationData.value = List.generate(32, (index) => random.nextDouble());
    // });
  }

  // 停止音频可视化
  void stopVisualization() {
    _visualizationTimer?.cancel();
  }

  void _startVisualizationTimer() {
    // _visualizationTimer?.cancel();
    // _visualizationTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
    //   if (isPlaying.value) {
    //     _updateVisualizationData();
    //   }
    // });
  }

  void _updateVisualizationData() {
    if (!isVisualizationActive.value) return;

    final List<double> newData = List<double>.filled(32, 0.0);
    final currentTime = position.value.inMilliseconds / 1000.0;

    for (var i = 0; i < 32; i++) {
      // 基础波形
      final t = currentTime * (i + 1) * 0.5;
      double value = math.sin(2 * math.pi * t) * 0.6;

      // 使用音量历史数据调整波形
      final volumeFactor = volumeHistory.isEmpty ? volume.value : volumeHistory[math.min(i, volumeHistory.length - 1)];

      // 添加音量影响
      value *= volumeFactor;

      // 确保值在合理范围内
      value = (value.abs() * 0.6).clamp(0.1, 1.0);
      newData[i] = value;
    }

    visualizationData.value = newData;
  }

  @override
  void onClose() {
    _visualizationTimer?.cancel();
    if (isPlaying.value) {
      pause();
    }
    _audioPlayer.dispose();
    _sleepTimer?.cancel();
    super.onClose();
  }
}
