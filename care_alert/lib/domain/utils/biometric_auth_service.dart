import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
	final LocalAuthentication _localAuth;

	BiometricAuthService({LocalAuthentication? localAuth})
			: _localAuth = localAuth ?? LocalAuthentication();

	Future<bool> isBiometricAvailable() async {
		try {
			final canCheck = await _localAuth.canCheckBiometrics;
			if (!canCheck) {
				return false;
			}

			final enrolled = await _localAuth.getAvailableBiometrics();
			return enrolled.isNotEmpty;
		} on LocalAuthException {
			return false;
		} catch (_) {
			return false;
		}
	}

	Future<bool> authenticateForUnlock() async {
		try {
			return await _localAuth.authenticate(
				localizedReason:
						'Bevestig met je vingerafdruk of gezichtsherkenning om te ontgrendelen',
				biometricOnly: true,
				persistAcrossBackgrounding: true,
			);
		} on LocalAuthException {
			return false;
		} catch (_) {
			return false;
		}
	}
}
