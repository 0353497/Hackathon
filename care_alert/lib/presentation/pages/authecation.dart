import 'package:care_alert/presentation/pages/main_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthecationPage extends StatefulWidget {
	const AuthecationPage({super.key});

	@override
	State<AuthecationPage> createState() => _AuthecationPageState();
}

class _AuthecationPageState extends State<AuthecationPage> {
	final LocalAuthentication _auth = LocalAuthentication();

	bool _isLoading = false;
	bool _canUseBiometrics = false;
	String _statusMessage = 'Check your biometric availability.';
	List<BiometricType> _availableBiometrics = const [];

	@override
	void initState() {
		super.initState();
		_loadBiometricState();
	}

	Future<void> _loadBiometricState() async {
		try {
			final canCheckBiometrics = await _auth.canCheckBiometrics;
			final isDeviceSupported = await _auth.isDeviceSupported();
			final availableBiometrics = await _auth.getAvailableBiometrics();

			if (!mounted) {
				return;
			}

			setState(() {
				_availableBiometrics = availableBiometrics;
				_canUseBiometrics = (canCheckBiometrics || isDeviceSupported) &&
						availableBiometrics.isNotEmpty;
				_statusMessage = _canUseBiometrics
						? 'Ready for Face ID / Fingerprint authentication.'
						: 'No biometrics available on this device.';
			});
		} catch (_) {
			if (!mounted) {
				return;
			}
			setState(() {
				_statusMessage = 'Failed to read biometric capabilities.';
			});
		}
	}

	Future<void> _authenticate() async {
		if (_isLoading || !_canUseBiometrics) {
			return;
		}

		setState(() {
			_isLoading = true;
			_statusMessage = 'Waiting for biometric verification...';
		});

		try {
			final authenticated = await _auth.authenticate(
				localizedReason: 'Authenticate to continue.',
				biometricOnly: true,
				persistAcrossBackgrounding: true,
			);

			if (!mounted) {
				return;
			}

			if (authenticated) {
				setState(() {
					_statusMessage = 'Authentication successful.';
				});

				Navigator.of(context).pushReplacement(
					MaterialPageRoute(builder: (_) => const MainView()),
				);
				return;
			}

			setState(() {
				_statusMessage = 'Authentication cancelled or failed.';
			});
		} catch (_) {
			if (!mounted) {
				return;
			}
			setState(() {
				_statusMessage = 'Biometric authentication failed.';
			});
		} finally {
			if (!mounted) {
				return;
			}
			setState(() {
				_isLoading = false;
			});
		}
	}

	String _biometricLabel() {
		final hasFace = _availableBiometrics.contains(BiometricType.face);
		final hasFingerprint =
				_availableBiometrics.contains(BiometricType.fingerprint);

		if (hasFace && hasFingerprint) {
			return 'Face ID + Fingerprint available';
		}
		if (hasFace) {
			return 'Face ID available';
		}
		if (hasFingerprint) {
			return 'Fingerprint available';
		}
		return 'No biometric method detected';
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.all(24),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							const Spacer(),
							const Icon(Icons.verified_user_rounded, size: 84),
							const SizedBox(height: 16),
							const Text(
								'Secure Authentication',
								textAlign: TextAlign.center,
								style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
							),
							const SizedBox(height: 8),
							Text(
								_biometricLabel(),
								textAlign: TextAlign.center,
								style: const TextStyle(fontSize: 15, color: Colors.black54),
							),
							const SizedBox(height: 12),
							Text(
								_statusMessage,
								textAlign: TextAlign.center,
								style: const TextStyle(fontSize: 14),
							),
							const Spacer(),
							FilledButton.icon(
								onPressed: _isLoading ? null : _authenticate,
								icon: _isLoading
										? const SizedBox(
												width: 18,
												height: 18,
												child: CircularProgressIndicator(strokeWidth: 2),
											)
										: const Icon(Icons.fingerprint_rounded),
								label: Text(_isLoading ? 'Authenticating...' : 'Authenticate'),
							),
							const SizedBox(height: 12),
							OutlinedButton(
								onPressed: _isLoading ? null : _loadBiometricState,
								child: const Text('Refresh biometric state'),
							),
						],
					),
				),
			),
		);
	}
}
