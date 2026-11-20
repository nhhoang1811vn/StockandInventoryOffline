/// The [count] most recent years, newest first, starting with the year of [now].
List<int> recentYears(DateTime now, {int count = 5}) {
  return List.generate(count, (i) => now.year - i);
}
