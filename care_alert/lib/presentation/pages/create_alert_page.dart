import 'dart:convert';

import 'package:care_alert/core/app_theme.dart';
import 'package:care_alert/domain/models/ticket.dart';
import 'package:care_alert/domain/utils/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:care_alert/presentation/components/layout.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CreateAlertPage extends StatefulWidget {
  const CreateAlertPage({super.key});

  @override
  State<CreateAlertPage> createState() => _CreateAlertPageState();
}

class _CreateAlertPageState extends State<CreateAlertPage> {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _personnelNumberController =
      TextEditingController();
  final TextEditingController _clientNumberController = TextEditingController();
  final TextEditingController _teamLeaderController = TextEditingController();

  bool _speechAvailable = false;
  bool _isListening = false;
  bool _isFetchingLocation = false;
  String? _selectedType;
  String? _selectedSeverity;
  late DateTime _selectedDateTime;

  String _formatDateTime(DateTime value) {
    final locale = Get.locale?.languageCode == 'nl' ? 'nl_NL' : 'en_US';
    return DateFormat('d-M-y, HH:mm:ss', locale).format(value);
  }

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    _initSpeech();
  }

  Future<void> _showDateTimePickerDialog() async {
    final localizations = MaterialLocalizations.of(context);
    DateTime tempDateTime = _selectedDateTime;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (dialogContext) {
        return Container(
          height: 320,
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(localizations.cancelButtonLabel),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onPressed: () {
                          if (!mounted) {
                            return;
                          }
                          setState(() {
                            _selectedDateTime = tempDateTime;
                          });
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(localizations.okButtonLabel),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: _selectedDateTime,
                    use24hFormat: true,
                    onDateTimeChanged: (value) {
                      tempDateTime = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _speechToText.stop();
    _locationController.dispose();
    _roomController.dispose();
    _descriptionController.dispose();
    _peopleController.dispose();
    _personnelNumberController.dispose();
    _clientNumberController.dispose();
    _teamLeaderController.dispose();
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

  Future<void> _fillCurrentAddress() async {
    if (_isFetchingLocation) {
      return;
    }

    setState(() {
      _isFetchingLocation = true;
    });

    try {
      final location = Location();
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }

      if (!serviceEnabled) {
        _showSnackBar('location_service_disabled'.tr);
        return;
      }

      var permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
      }

      if (permission != PermissionStatus.granted) {
        _showSnackBar('location_permission_denied'.tr);
        return;
      }

      final currentLocation = await location.getLocation();
      final latitude = currentLocation.latitude;
      final longitude = currentLocation.longitude;

      if (latitude == null || longitude == null) {
        _showSnackBar('location_fetch_failed'.tr);
        return;
      }

      final locale = Get.locale?.languageCode == 'nl' ? 'nl' : 'en';
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'accept-language': locale,
      });

      final response = await http.get(
        uri,
        headers: const {
          'User-Agent': 'care_alert_app/1.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _showSnackBar('location_fetch_failed'.tr);
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final address = (data['display_name'] as String?)?.trim();

      if (address == null || address.isEmpty) {
        _showSnackBar('location_not_found'.tr);
        return;
      }

      _locationController.text = address;
      _locationController.selection = TextSelection.fromPosition(
        TextPosition(offset: _locationController.text.length),
      );
      _showSnackBar('location_set_success'.tr);
    } catch (_) {
      _showSnackBar('location_fetch_failed'.tr);
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFDDDEE3)),
                color: AppColors.surface,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('alert_type_label'.tr, requiredField: true),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: InputDecoration(hintText: 'alert_type_hint'.tr),
                    items: [
                      DropdownMenuItem(value: 'MIC', child: Text('MIC'.tr)),
                      DropdownMenuItem(value: 'MIM', child: Text('MIM'.tr)),
                      DropdownMenuItem(
                        value: 'brandmelding',
                        child: Text('Brandmelding'.tr),
                      ),
                      DropdownMenuItem(
                        value: 'ongeval/bijna-incident',
                        child: Text('ongeval/bijna-incident'.tr),
                      ),
                      DropdownMenuItem(value: 'it', child: Text('it'.tr)),
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
                  _dateTimePickerField(),
                  const SizedBox(height: 8),
                  Text(
                    'date_time_auto_hint'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _fieldLabel('location_label'.tr, requiredField: true),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          controller: _locationController,
                          hint: 'location_hint'.tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _locationButton(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _fieldLabel('room_label'.tr),
                  const SizedBox(height: 8),
                  _textField(controller: _roomController, hint: 'room_hint'.tr),
                  const SizedBox(height: 20),
                  _fieldLabel('personnel_number_label'.tr),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _personnelNumberController,
                    hint: 'personnel_number_hint'.tr,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    onChanged: (_) => setState(() {}),
                    errorText:
                        _personnelNumberController.text.isNotEmpty &&
                            _personnelNumberController.text.length != 6
                        ? 'number_must_be_six_digits'.tr
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _fieldLabel('client_number_label'.tr),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _clientNumberController,
                    hint: 'client_number_hint'.tr,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    onChanged: (_) => setState(() {}),
                    errorText:
                        _clientNumberController.text.isNotEmpty &&
                            _clientNumberController.text.length != 6
                        ? 'number_must_be_six_digits'.tr
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _fieldLabel('team_leader_label'.tr),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _teamLeaderController,
                    hint: 'team_leader_hint'.tr,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z\s'\-]"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _fieldLabel('description_label'.tr, requiredField: true),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _textField(
                          controller: _descriptionController,
                          hint: 'description_hint'.tr,
                          maxLines: 4,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: _micButton(),
                      ),
                    ],
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
                    initialValue: _selectedSeverity,
                    decoration: InputDecoration(hintText: 'severity_hint'.tr),
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitAlert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'send_alert'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAlert() async {
    if (_selectedType == null || _selectedSeverity == null) {
      _showSnackBar('fill_required_fields'.tr);
      return;
    }

    final locationText = _locationController.text.trim();
    final roomText = _roomController.text.trim();
    final descriptionText = _descriptionController.text.trim();

    if (locationText.isEmpty) {
      _showSnackBar('location_required'.tr);
      return;
    }

    if (descriptionText.isEmpty) {
      _showSnackBar('description_required'.tr);
      return;
    }

    final ticket = Ticket(
      adress: locationText,
      category: _selectedType ?? '',
      client: _clientNumberController.text,
      date: _selectedDateTime,
      description: descriptionText,
      email_team_leader: _teamLeaderController.text,
      employee: _personnelNumberController.text,
      latitude: '',
      longitude: '',
      room: roomText,
      room_id: '',
      severity: _selectedSeverity ?? '',
      status: 'open',
      ticket: '',
      title: _selectedType ?? '',
    );

    final response = await ApiService.sendAlert(ticket);

    if (!mounted) return;

    if (response.success) {
      _showSnackBar('alert_sent_successfully'.tr);
      _resetForm();
    } else {
      _showSnackBar(response.message);
    }
  }

  void _resetForm() {
    setState(() {
      _selectedType = null;
      _selectedSeverity = null;
      _selectedDateTime = DateTime.now();
      _locationController.clear();
      _roomController.clear();
      _descriptionController.clear();
      _peopleController.clear();
      _personnelNumberController.clear();
      _clientNumberController.clear();
      _teamLeaderController.clear();
      _isListening = false;
    });
  }

  Widget _fieldLabel(String text, {bool requiredField = false}) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
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

  Widget _dateTimePickerField() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _showDateTimePickerDialog,
      child: IgnorePointer(
        child: TextFormField(
          initialValue: _formatDateTime(_selectedDateTime),
          style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
          decoration: const InputDecoration(
            suffixIcon: Icon(CupertinoIcons.time),
          ),
        ),
      ),
    );
  }

  Widget _locationButton() {
    return SizedBox(
      width: 52,
      height: 52,
      child: Tooltip(
        message: 'use_current_location'.tr,
        child: ElevatedButton(
          onPressed: _isFetchingLocation ? null : _fillCurrentAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            shadowColor: AppColors.primaryBlue.withValues(alpha: 0.35),
          ),
          child: _isFetchingLocation
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.my_location_rounded, size: 20),
        ),
      ),
    );
  }

  Widget _micButton() {
    return SizedBox(
      width: 52,
      height: 52,
      child: Tooltip(
        message: _isListening
            ? 'stop_recording_tooltip'.tr
            : 'start_recording_tooltip'.tr,
        child: ElevatedButton(
          onPressed: _toggleListening,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isListening ? Colors.red : AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            shadowColor: (_isListening ? Colors.red : AppColors.primaryBlue)
                .withValues(alpha: 0.35),
          ),
          child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 20),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    ValueChanged<String>? onChanged,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        counterText: '',
        errorText: errorText,
      ),
    );
  }
}
