/// A badge the server has just awarded to the player.
class EarnedBadge {
  const EarnedBadge({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;

  factory EarnedBadge.fromMap(Map<String, dynamic> m) => EarnedBadge(
    id: (m['id'] as String?) ?? '',
    name: (m['name'] as String?) ?? 'New badge',
    description: (m['description'] as String?) ?? '',
  );
}

/// Reads the `newBadges` list from a server response. Anything that is not
/// a list of maps gives an empty list.
List<EarnedBadge> parseEarnedBadges(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final b in raw)
      if (b is Map) EarnedBadge.fromMap(Map<String, dynamic>.from(b)),
  ];
}
