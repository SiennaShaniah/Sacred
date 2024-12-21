import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fftea/fftea.dart'; // Importing FFT package

class GuitarTunerPage extends StatefulWidget {
  const GuitarTunerPage({super.key});

  @override
  _GuitarTunerPageState createState() => _GuitarTunerPageState();
}

class _GuitarTunerPageState extends State<GuitarTunerPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late RealFft _fft; // FFT object
  bool _isRecording = false;

  String _detectedNote = "Unknown";
  double _detectedFrequency = 0.0;
  final Map<String, double> _guitarNotes = {
    'E (low)': 82.41,
    'A': 110.00,
    'D': 146.83,
    'G': 196.00,
    'B': 246.94,
    'E (high)': 329.63,
  };

  String? _currentString = "E (low)";

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    // Request microphone permission
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw "Microphone permission not granted";
    }

    await _recorder.openRecorder();
    _fft = RealFft(2048); // Initialize FFT with 2048-point window
  }

  Future<void> _startTuning() async {
    if (_isRecording) return;

    setState(() {
      _isRecording = true;
    });

    // Start the recorder with PCM format to get raw audio data
    await _recorder.startRecorder(
      codec: Codec.pcm16,
      toFile: null,
    );

    // Start processing the audio stream here, using onProgress
    _recorder.onProgress!.listen((e) {
      if (e.buffer != null && e.buffer!.isNotEmpty) {
        final audioData = e.buffer!; // PCM data (raw bytes)

        // Convert audio data to double (signed PCM 16-bit)
        final inputSamples = List.generate(
          audioData.length ~/ 2,
          (i) {
            return (audioData[i * 2] + audioData[i * 2 + 1] * 256) -
                32768.0; // Convert to signed 16-bit PCM
          },
        );

        final spectrum = _fft.transform(inputSamples);

        final frequency = _findMaxFrequency(spectrum);
        final note = _findNearestNote(frequency);

        setState(() {
          _detectedFrequency = frequency;
          _detectedNote = note;
        });
      }
    });
  }

  Future<void> _stopTuning() async {
    if (!_isRecording) return;

    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _detectedFrequency = 0.0;
      _detectedNote = "Unknown";
    });
  }

  double _findMaxFrequency(List<double> spectrum) {
    int maxIndex = spectrum.indexOf(spectrum.reduce(max));
    double frequency =
        (maxIndex * 44100) / 2048; // Calculate frequency based on FFT result
    return frequency;
  }

  String _findNearestNote(double frequency) {
    String nearestNote = "Unknown";
    double minDifference = double.infinity;

    for (final entry in _guitarNotes.entries) {
      double difference = (entry.value - frequency).abs();
      if (difference < minDifference) {
        minDifference = difference;
        nearestNote = entry.key;
      }
    }

    return nearestNote;
  }

  Color _getNoteColor(String note) {
    if (note == _currentString) {
      return Colors.green; // In tune
    } else if (note == "Unknown") {
      return Colors.grey; // No sound detected
    } else {
      return Colors.red; // Out of tune
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guitar Tuner'),
      ),
      body: Center(
        // Use Center to center everything on the screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Ensure content doesn't overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display string buttons with tuning info
                Wrap(
                  alignment: WrapAlignment.center,
                  children: _guitarNotes.keys.map((string) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentString = string;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getNoteColor(string),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                            child: Text(
                              string,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black), // Set text to black
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${_guitarNotes[string]} Hz',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black), // Set text to black
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Show detected note and frequency
                Text(
                  'Detected Note: $_detectedNote',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black), // Set text to black
                ),
                const SizedBox(height: 10),
                Text(
                  'Frequency: ${_detectedFrequency.toStringAsFixed(2)} Hz',
                  style: const TextStyle(
                      fontSize: 18, color: Colors.black), // Set text to black
                ),
                const SizedBox(height: 40),
                // Start/Stop Button
                ElevatedButton(
                  onPressed: _isRecording ? _stopTuning : _startTuning,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB4BA1C),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    _isRecording ? 'Stop' : 'Start',
                    style: const TextStyle(
                        color: Colors.white), // Set text to white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on RecordingDisposition {
  get buffer => null;
}

class RealFft {
  RealFft(int i);

  transform(List inputSamples) {}
}
