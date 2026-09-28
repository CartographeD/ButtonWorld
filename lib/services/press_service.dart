import 'local_score_service.dart';
import 'player_service.dart';

class PressService {
  int presses = 0;

  int tapStreak = 0;

  int bestTapStreak = 0;

  DateTime? lastPressTime;

  Future<void> load() async {
    final localPresses = await LocalScoreService.getPresses();
    final firebasePresses = await PlayerService.getFirebasePresses();

    if (firebasePresses > localPresses) {
      presses = firebasePresses;

      await LocalScoreService.savePresses(presses);
    } else {
      presses = localPresses;

      if (localPresses > firebasePresses) {
        PlayerService.schedulePressSync(presses);
      }
    }
  }

  Future<void> registerPress() async {
    final now = DateTime.now();

    presses++;

    if (lastPressTime != null) {
      final difference = now.difference(lastPressTime!);

      if (difference.inMilliseconds <= 800) {
        tapStreak++;
      } else {
        tapStreak = 1;
      }
    } else {
      tapStreak = 1;
    }

    if (tapStreak > bestTapStreak) {
      bestTapStreak = tapStreak;
    }

    lastPressTime = now;

    await LocalScoreService.savePresses(presses);

    PlayerService.schedulePressSync(presses);
  }
}