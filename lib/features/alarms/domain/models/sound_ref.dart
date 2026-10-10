import 'dart:convert';

import 'package:equatable/equatable.dart';

enum SoundType {
  /// The system default alarm sound.
  system,

  /// A tone bundled with the app (`res/raw`).
  bundled,

  /// A sound the user picked; the native side copied it into app storage.
  file,

  /// No sound, vibration only.
  silent,
}

/// A reference to an alarm sound that the native engine can resolve, even before the first unlock.
class SoundRef extends Equatable {
  const SoundRef(this.type, {this.id = '', this.title = ''});

  factory SoundRef.fromJson(Map<String, Object?> json) => SoundRef(
    SoundType.values.byName(json['type']! as String),
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
  );

  static SoundRef? decode(String? source) =>
      source == null ? null : SoundRef.fromJson(jsonDecode(source) as Map<String, Object?>);

  static const system = SoundRef(SoundType.system);
  static const silent = SoundRef(SoundType.silent);
  static const fjord = SoundRef(SoundType.bundled, id: 'klar_fjord', title: 'Fjord');
  static const bjork = SoundRef(SoundType.bundled, id: 'klar_bjork', title: 'Björk');
  static const frost = SoundRef(SoundType.bundled, id: 'klar_frost', title: 'Frost');
  static const bundled = [fjord, bjork, frost];

  final SoundType type;
  final String id;
  final String title;

  Map<String, Object?> toJson() => {'type': type.name, 'id': id, 'title': title};

  String encode() => jsonEncode(toJson());

  @override
  List<Object?> get props => [type, id];
}
