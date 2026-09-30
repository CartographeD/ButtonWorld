class Player {
  final String uid;
  final int presses;
  final int coins;
  final String? country;
  final String? username;
  final int bestTapStreak;
  final int seasonPresses;
  final String? seasonId;
  final String buttonSkin;

  const Player({
    required this.uid,
    required this.presses,
    required this.coins,
    this.country,
    this.username,
    this.bestTapStreak = 0,
    this.seasonPresses = 0,
    this.seasonId,
    this.buttonSkin = 'classic',
  });

  factory Player.fromFirestore(
    String uid,
    Map<String, dynamic> data,
  ) {
    return Player(
      uid: uid,
      presses: (data['presses'] as num?)?.toInt() ?? 0,
      coins: (data['coins'] as num?)?.toInt() ?? 0,
      country: data['country'] as String?,
      username: data['username'] as String?,
      bestTapStreak: (data['bestTapStreak'] as num?)?.toInt() ?? 0,
      seasonPresses: (data['seasonPresses'] as num?)?.toInt() ?? 0,
      seasonId: data['seasonId'] as String?,
      buttonSkin: data['buttonSkin'] as String? ?? 'classic',
    );
  }
}
