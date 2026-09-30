import 'local_score_service.dart';
import 'player_service.dart';

class PressResult {
  final bool newBestStreak;
  final bool hitMilestone;
  final int? milestone;

  const PressResult({
    this.newBestStreak = false,
    this.hitMilestone = false,
    this.milestone,
  });
}

class PressService {
  int presses = 0;
  int tapStreak = 0;
  int bestTapStreak = 0;
  DateTime? lastPressTime;

  // ─────────────────────────────────────
  // LOAD
  // ─────────────────────────────────────

  Future<void> load() async {
    final localBestStreak =
        await LocalScoreService.getBestTapStreak();

    final firebasePlayer =
        await PlayerService.getPlayer();

    // Firebase est la source de vérité
    // pour le nombre de PRESS.
    presses = firebasePlayer.presses;

    // Pour le streak, on conserve le meilleur
    // score local ou Firebase.
    bestTapStreak =
        localBestStreak > firebasePlayer.bestTapStreak
            ? localBestStreak
            : firebasePlayer.bestTapStreak;

    // On remet le cache local à jour avec
    // la valeur du compte Firebase.
    await LocalScoreService.savePresses(
      presses,
    );

    await LocalScoreService.saveBestTapStreak(
      bestTapStreak,
    );

    // Si le meilleur streak local était supérieur
    // à celui de Firebase, on le synchronise.
    if (bestTapStreak >
        firebasePlayer.bestTapStreak) {
      PlayerService.schedulePressSync(
        presses: presses,
        bestTapStreak: bestTapStreak,
      );
    }
  }

  // ─────────────────────────────────────
  // REGISTER PRESS
  // ─────────────────────────────────────

  Future<PressResult> registerPress() async {
    final now = DateTime.now();

    presses++;

    if (lastPressTime != null &&
        now
                .difference(lastPressTime!)
                .inMilliseconds <=
            800) {
      tapStreak++;
    } else {
      tapStreak = 1;
    }

    lastPressTime = now;

    final wasNewBest =
        tapStreak > bestTapStreak;

    if (wasNewBest) {
      bestTapStreak = tapStreak;

      await LocalScoreService
          .saveBestTapStreak(
        bestTapStreak,
      );
    }

    await LocalScoreService.savePresses(
      presses,
    );

    PlayerService.schedulePressSync(
      presses: presses,
      bestTapStreak: bestTapStreak,
    );

    final milestone =
        _milestoneFor(presses);

    return PressResult(
      newBestStreak: wasNewBest,
      hitMilestone: milestone != null,
      milestone: milestone,
    );
  }

  // ─────────────────────────────────────
  // MILESTONES
  // ─────────────────────────────────────

  int? _milestoneFor(int value) {
    const milestones = [
      10,
      100,
      500,
      1000,
      5000,
      10000,
      25000,
      50000,
      100000,
      250000,
      500000,
      1000000,
    ];

    return milestones.contains(value)
        ? value
        : null;
  }
}