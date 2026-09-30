class Milestone {
  final int presses;
  final String title;
  final String subtitle;

  const Milestone({
    required this.presses,
    required this.title,
    required this.subtitle,
  });
}

const List<Milestone> buttonWorldMilestones = [
  Milestone(presses: 10, title: 'FIRST TEN', subtitle: 'Your first little run.'),
  Milestone(presses: 100, title: 'WARMING UP', subtitle: 'The button knows you now.'),
  Milestone(presses: 500, title: 'GETTING SERIOUS', subtitle: 'Five hundred presses.'),
  Milestone(presses: 1000, title: 'ONE THOUSAND', subtitle: 'A real ButtonWorld milestone.'),
  Milestone(presses: 5000, title: 'DEDICATED', subtitle: 'Five thousand presses.'),
  Milestone(presses: 10000, title: 'TEN THOUSAND', subtitle: 'Welcome to the five-digit club.'),
  Milestone(presses: 25000, title: 'QUARTER CENTURY', subtitle: 'Twenty-five thousand presses.'),
  Milestone(presses: 50000, title: 'HALF WAY', subtitle: 'Fifty thousand presses.'),
  Milestone(presses: 100000, title: 'ONE HUNDRED THOUSAND', subtitle: 'Six digits. Respect.'),
  Milestone(presses: 250000, title: 'UNSTOPPABLE', subtitle: 'Quarter of a million presses.'),
  Milestone(presses: 500000, title: 'HALF A MILLION', subtitle: 'The button is part of the routine.'),
  Milestone(presses: 1000000, title: 'ONE MILLION', subtitle: 'You pressed it. A million times.'),
];
