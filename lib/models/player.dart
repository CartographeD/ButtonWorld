class Player {
  final String uid;
  final int presses;
  final int coins;
  final String? country;
  final String? username;

  const Player({
    required this.uid,
    required this.presses,
    required this.coins,
    this.country,
    this.username,
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
    );
  }
}