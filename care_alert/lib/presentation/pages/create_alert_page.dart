import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CreateAlertPage extends StatefulWidget {
  const CreateAlertPage({super.key});

  @override
  State<CreateAlertPage> createState() => _CreateAlertPageState();
}

class _CreateAlertPageState extends State<CreateAlertPage> {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  bool _speechAvailable = false;
  bool _isListening = false;
  String? _selectedType;
  String? _selectedSeverity;

  String get _currentDateTime {
    final locale = Get.locale?.languageCode == 'nl' ? 'nl_NL' : 'en_US';
    return DateFormat('d-M-y, HH:mm:ss', locale).format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _speechToText.stop();
    _locationController.dispose();
    _descriptionController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    final available = await _speechToText.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      _speechAvailable = available;
    });
  }

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('stt_not_available'.tr)));
      }
      return;
    }

    if (_isListening) {
      await _speechToText.stop();
      if (!mounted) {
        return;
      }
      setState(() {
        _isListening = false;
      });
      return;
    }

    setState(() {
      _isListening = true;
    });

    await _speechToText.listen(
      localeId: Get.locale?.languageCode == 'nl' ? 'nl_NL' : 'en_US',
      onResult: (result) {
        setState(() {
          _descriptionController.text = result.recognizedWords;
          _descriptionController.selection = TextSelection.fromPosition(
            TextPosition(offset: _descriptionController.text.length),
          );

          if (result.finalResult) {
            _isListening = false;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'new_melding'.tr,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'create_alert_subtitle'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.blueGrey.shade700,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('alert_type_label'.tr, requiredField: true),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        hintText: 'alert_type_hint'.tr,
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'fall',
                          child: Text('alert_type_fall'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'aggression',
                          child: Text('alert_type_aggression'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'medical',
                          child: Text('alert_type_medical'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text('alert_type_other'.tr),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _fieldLabel('date_time_label'.tr),
                    const SizedBox(height: 8),
                    _disabledField(_currentDateTime),
                    const SizedBox(height: 8),
                    Text(
                      'date_time_auto_hint'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _fieldLabel('location_label'.tr, requiredField: true),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _locationController,
                      hint: 'location_hint'.tr,
                    ),
                    const SizedBox(height: 20),
                    _fieldLabel('description_label'.tr, requiredField: true),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _descriptionController,
                      hint: 'description_hint'.tr,
                      maxLines: 4,
                      suffixIcon: IconButton(
                        onPressed: _toggleListening,
                        tooltip: _isListening
                            ? 'stop_recording_tooltip'.tr
                            : 'start_recording_tooltip'.tr,
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening
                              ? Colors.red.shade400
                              : Colors.blueGrey.shade700,
                        ),
                      ),
                    ),
                    if (_isListening) ...[
                      const SizedBox(height: 8),
                      Text(
                        'listening_hint'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _fieldLabel('involved_people_label'.tr),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _peopleController,
                      hint: 'involved_people_hint'.tr,
                    ),
                    const SizedBox(height: 20),
                    _fieldLabel('severity_label'.tr, requiredField: true),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedSeverity,
                      decoration: InputDecoration(
                        hintText: 'severity_hint'.tr,
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'low',
                          child: Text('severity_low'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'medium',
                          child: Text('severity_medium'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'high',
                          child: Text('severity_high'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'critical',
                          child: Text('severity_critical'.tr),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSeverity = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, {bool requiredField = false}) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        children: [
          TextSpan(text: text),
          if (requiredField)
            const TextSpan(
              text: '  *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _disabledField(String value) {
    return TextFormField(
      enabled: false,
      initialValue: value,
      style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
