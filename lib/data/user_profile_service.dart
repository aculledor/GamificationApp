import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final String surname;
  final String email;
  final Uint8List? avatarBytes; // opcional

  const UserProfile({
    required this.name,
    required this.surname,
    required this.email,
    this.avatarBytes,
  });

  UserProfile copyWith({String? name, String? surname, String? email, Uint8List? avatarBytes}) {
    return UserProfile(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      avatarBytes: avatarBytes ?? this.avatarBytes,
    );
  }
}

class UserProfileService {
  static const _kName = 'profile_name';
  static const _kSurname = 'profile_surname';
  static const _kEmail = 'profile_email';
  static const _kAvatarB64 = 'profile_avatar_b64';

  Future<UserProfile> load() async {
    final sp = await SharedPreferences.getInstance();
    final name = sp.getString(_kName) ?? 'User';
    final surname = sp.getString(_kSurname) ?? 'User';
    final email = sp.getString(_kEmail) ?? 'User@user.com';
    final b64 = sp.getString(_kAvatarB64);
    final bytes = (b64 == null) ? null : base64Decode(b64);
    return UserProfile(name: name, surname: surname, email: email, avatarBytes: bytes);
  }

  Future<void> save(UserProfile p) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kName, p.name);
    await sp.setString(_kSurname, p.surname);
    await sp.setString(_kEmail, p.email);
    if (p.avatarBytes != null) {
      await sp.setString(_kAvatarB64, base64Encode(p.avatarBytes!));
    }
  }

  Future<void> clearAvatar() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kAvatarB64);
  }
}
