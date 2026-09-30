import 'package:flutter/material.dart';

import '../services/player_service.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  int presses = 0;
  bool isLoading = true;

  final List<_Goal> goals = const [
    _Goal(
      value: 10,
      title: 'FIRST PRESS',
      description: 'Your journey begins.',
      reward: 50,
    ),
    _Goal(
      value: 100,
      title: 'GETTING STARTED',
      description: 'Keep pressing.',
      reward: 100,
    ),
    _Goal(
      value: 500,
      title: 'WARMING UP',
      description: 'You are getting started.',
      reward: 150,
    ),
    _Goal(
      value: 1000,
      title: 'FOUR DIGITS',
      description: 'Welcome to the 1K club.',
      reward: 250,
    ),
    _Goal(
      value: 5000,
      title: 'DEDICATED',
      description: 'That is a lot of pressing.',
      reward: 500,
    ),
    _Goal(
      value: 10000,
      title: 'TEN THOUSAND',
      description: 'Five digits. Nice.',
      reward: 750,
    ),
    _Goal(
      value: 25000,
      title: 'UNSTOPPABLE',
      description: 'Nothing is stopping you.',
      reward: 1000,
    ),
    _Goal(
      value: 50000,
      title: 'PRESS MASTER',
      description: 'You have mastered the button.',
      reward: 1500,
    ),
    _Goal(
      value: 100000,
      title: 'LEGEND',
      description: 'Six digits of dedication.',
      reward: 2500,
    ),
    _Goal(
      value: 250000,
      title: 'ABSOLUTE UNIT',
      description: 'This is getting serious.',
      reward: 4000,
    ),
    _Goal(
      value: 500000,
      title: 'HALF A MILLION',
      description: 'You are built different.',
      reward: 7500,
    ),
    _Goal(
      value: 1000000,
      title: 'ONE MILLION',
      description: 'The ultimate milestone.',
      reward: 15000,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final player = await PlayerService.getPlayer();

      if (!mounted) return;

      setState(() {
        presses = player.presses;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  _Goal? get currentGoal {
    for (final goal in goals) {
      if (presses < goal.value) {
        return goal;
      }
    }

    return null;
  }

  _Goal? get previousGoal {
    final current = currentGoal;

    if (current == null) {
      return goals.isEmpty ? null : goals.last;
    }

    final index = goals.indexOf(current);

    if (index <= 0) {
      return null;
    }

    return goals[index - 1];
  }

  double get currentProgress {
    final current = currentGoal;

    if (current == null) {
      return 1.0;
    }

    final previous = previousGoal?.value ?? 0;

    final range = current.value - previous;
    final progress = presses - previous;

    if (range <= 0) {
      return 0;
    }

    return (progress / range).clamp(0.0, 1.0);
  }

  int get completedGoals {
    return goals.where((goal) => presses >= goal.value).length;
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(
        number % 1000000 == 0 ? 0 : 1,
      )}M';
    }

    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(
        number % 1000 == 0 ? 0 : 1,
      )}K';
    }

    return number.toString();
  }

  String _remainingText(int value) {
    final remaining = value - presses;

    if (remaining <= 0) {
      return 'COMPLETED';
    }

    return '${_formatNumber(remaining)} PRESSES TO GO';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'GOALS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildCurrentGoal(),
                  const SizedBox(height: 28),
                  _buildSectionTitle(),
                  const SizedBox(height: 12),
                  ...goals.map(_buildGoalCard),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    final progress =
        goals.isEmpty ? 0.0 : completedGoals / goals.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'YOUR JOURNEY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _formatNumber(presses),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'PRESSES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFEAEAE6),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$completedGoals/${goals.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$completedGoals GOALS COMPLETED',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentGoal() {
    final goal = currentGoal;

    if (goal == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Column(
          children: [
            Text(
              '🏆',
              style: TextStyle(fontSize: 38),
            ),
            SizedBox(height: 12),
            Text(
              'ALL GOALS COMPLETED',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'You reached one million presses.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final progress = currentProgress;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'NEXT GOAL',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            goal.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            goal.description,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatNumber(presses)} / ${_formatNumber(goal.value)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white12,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Color(0xFFE53935),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: Color(0xFFFFC107),
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                _remainingText(goal.value),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.monetization_on_rounded,
                color: Color(0xFFFFC107),
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                '+${goal.reward}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'ALL GOALS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        Text(
          '$completedGoals / ${goals.length}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(_Goal goal) {
    final completed = presses >= goal.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: completed ? Colors.white : const Color(0xFFECECE8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: completed
              ? const Color(0xFFE53935).withValues(alpha: 0.12)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: completed
                  ? const Color(0xFFE53935)
                  : const Color(0xFFDADAD5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              completed
                  ? Icons.check_rounded
                  : Icons.lock_outline_rounded,
              color: completed ? Colors.white : Colors.black38,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: completed
                        ? Colors.black87
                        : Colors.black45,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_formatNumber(goal.value)} PRESSES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: completed
                      ? Colors.black45
                      : Colors.black.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (completed)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.monetization_on_rounded,
                  color: Color(0xFFFFB300),
                  size: 18,
                ),
                const SizedBox(height: 2),
                Text(
                  '+${goal.reward}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                  ),
                ),
              ],
            )
          else
            Text(
              _formatNumber(goal.value),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.black26,
              ),
            ),
        ],
      ),
    );
  }
}

class _Goal {
  final int value;
  final String title;
  final String description;
  final int reward;

  const _Goal({
    required this.value,
    required this.title,
    required this.description,
    required this.reward,
  });
}