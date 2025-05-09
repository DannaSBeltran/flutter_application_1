import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Streaming',
      theme: ThemeData.dark(),
      home: StreamMenuPage(),
    );
  }
}


class StreamMenuPage extends StatelessWidget {
  final List<Map<String, String>> streams = [
    {
      'title': 'ESPN Premium',
      'url': 'https://m2.merichunidya.com:999/hls/capespnprem.m3u8?md5=bdW_qvbWrywibbKXLCCAmA&expires=1746659495',
    },
    {
      'title': 'Win Sports+',
      'url': 'https://m1.merichunidya.com:999/hls/winsportsplus.m3u8?md5=mTiRAnOxwm3AI7y7Su8pvQ&expires=1746658184',
    },
    {
      'title': 'TNT Argentina',
      'url': 'https://m3.merichunidya.com:999/hls/captntarg.m3u8?md5=SDm5ZTfZvahfJ63lLnhzPg&expires=1746659610',
    },
    {
      'title': 'Gol Perú',
      'url': 'https://m1.merichunidya.com:999/hls/capgolperu.m3u8?md5=d5njHJebNPBwIH-ugZRTxg&expires=1746659670',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sports Streaming')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: streams.length,
        itemBuilder: (context, index) {
          final stream = streams[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text(stream['title']!, style: const TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPage(
                      title: stream['title']!,
                      videoUrl: stream['url']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


class VideoPage extends StatefulWidget {
  final String title;
  final String videoUrl;

  const VideoPage({required this.title, required this.videoUrl, super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  final Map<String, String> customHeaders = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:138.0) Gecko/20100101 Firefox/138.0',
    'Accept': '*/*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate, br, zstd',
    'Referer': 'https://capo5play.com/',
    'Origin': 'https://capo5play.com',
    'Connection': 'keep-alive',
  };

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      widget.videoUrl,
      httpHeaders: customHeaders,
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
