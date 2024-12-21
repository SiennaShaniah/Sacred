import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  late AudioPlayer _audioPlayer; // Audio player for sound
  Timer? _timer; // Timer to control the beat interval
  int _bpm = 120; // Default beats per minute
  bool _isRunning = false; // To track whether the metronome is running
  double _sliderValue = 120.0; // Value for slider to adjust BPM

  final String _audioUrl =
      'https://www.soundsnap.com/sites/default/files/sound/2019/09/antique_clock_ticking_metronome_02.mp3';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialize the audio player
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Function to start/stop the metronome
  void _toggleMetronome() {
    if (_isRunning) {
      _stopMetronome();
    } else {
      _startMetronome();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  // Function to start the metronome with the current BPM
  void _startMetronome() {
    int intervalInMilliseconds = (60000 / _bpm).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalInMilliseconds),
        (timer) async {
      await _audioPlayer.play(UrlSource(_audioUrl));
    });
  }

  // Function to stop the metronome
  void _stopMetronome() {
    _timer?.cancel();
    _audioPlayer.stop();
  }

  // Function to update the BPM from the slider
  void _onBpmChanged(double value) {
    setState(() {
      _bpm = value.toInt();
      _sliderValue = value;
      if (_isRunning) {
        _stopMetronome(); // Restart the metronome with the new BPM
        _startMetronome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFB4BA1C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // BPM slider with custom color
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: highlightColor,
                thumbColor: highlightColor,
                overlayColor: highlightColor.withOpacity(0.2),
                inactiveTrackColor: Colors.grey[300],
              ),
              child: Slider(
                value: _sliderValue,
                min: 40,
                max: 200,
                divisions: 160,
                label: '$_bpm BPM',
                onChanged: _onBpmChanged,
              ),
            ),
            const SizedBox(height: 20),
            // BPM display
            Text(
              'BPM: $_bpm',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Start/Stop button with custom text color
            ElevatedButton(
              onPressed: _toggleMetronome,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 40.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: Text(
                _isRunning ? 'Stop' : 'Start',
                style: const TextStyle(color: highlightColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
