/// The semantic kind of a toast, which selects its color and default icon.
///
/// Milestone 1 ships [success] and [error]. Further variants (warning, info)
/// land in a later release.
enum SizzleType {
  /// A positive, confirming message. Green accent.
  success,

  /// A failure or problem the user should notice. Red accent.
  error,
}
