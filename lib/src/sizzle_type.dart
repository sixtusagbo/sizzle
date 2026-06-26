/// The semantic kind of a toast, which selects its color and default icon.
enum SizzleType {
  /// A positive, confirming message. Green accent.
  success,

  /// A failure or problem the user should notice. Red accent.
  error,

  /// A caution the user should weigh before continuing. Amber accent.
  warning,

  /// A neutral, informational note. Blue accent.
  info,
}
