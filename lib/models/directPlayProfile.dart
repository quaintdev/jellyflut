class DirectPlayProfile {
  DirectPlayProfile({
    this.container,
    this.type,
    this.videoCodec,
    this.audioCodec,
  });

  String? container;
  String? type;
  String? videoCodec;
  String? audioCodec;

  factory DirectPlayProfile.fromMap(Map<String, dynamic> json) =>
      DirectPlayProfile(
        container: json['Container'],
        type: json['Type'],
        videoCodec: json['VideoCodec'],
        audioCodec: json['AudioCodec'],
      );

  Map<String, dynamic> toMap() => {
        if (container != null) 'Container': container,
        if (type != null) 'Type': type,
        if (videoCodec != null) 'VideoCodec': videoCodec,
        if (audioCodec != null) 'AudioCodec': audioCodec,
      };
}
