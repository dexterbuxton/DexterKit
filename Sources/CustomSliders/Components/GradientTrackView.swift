import SwiftUI
import Extensions

/// A view that represents a gradient track with customizable colors, height, and border.
///
/// The `GradientTrackView` is a rectangular view that displays a gradient effect
/// using a linear gradient with specified colors and a capsule mask.
struct GradientTrackView: View {

  // MARK: Properties

  /// The array of colors used to create the gradient.
  private let colors: [Color]

  /// The height of the gradient track.
  private let trackHeight: CGFloat

  /// The color of the track's border.
  private let borderColor: Color

  /// The width of the track's border.
  ///
  /// The border is drawn inset, so it never extends beyond the track's bounds.
  private let lineWidth: CGFloat

  // MARK: Initializer

  /// Creates a new `GradientTrackView` with the specified properties.
  ///
  /// - Parameters:
  ///   - colors: The array of colors used to create the gradient.
  ///   - trackHeight: The height of the gradient track. Defaults to `10`.
  ///   - borderColor: The border color. Defaults to `.separator` (a translucent hairline).
  ///   - lineWidth: The width of the border. Defaults to `0` (off).
  init(
    colors: [Color],
    trackHeight: CGFloat = 10,
    borderColor: Color = .separator,
    lineWidth: CGFloat = 0
  ) {
    self.colors = colors
    self.trackHeight = trackHeight
    self.borderColor = borderColor
    self.lineWidth = lineWidth
  }

  // MARK: Views

  /// The linear gradient view created using the specified colors.
  ///
  /// This view uses a `LinearGradient` to display a gradient effect
  /// that transitions between the provided colors from leading to trailing.
  var gradient: some View {
    LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
  }

  /// The border overlay of the track.
  ///
  /// Traces the capsule edge with an inset stroke so it stays within bounds.
  var trackBorder: some View {
    Capsule()
      .strokeBorder(borderColor, lineWidth: lineWidth)
  }

  /// The content and behavior of the `GradientTrackView`.
  ///
  /// This view displays the gradient with a capsule mask and a specified height.
  var body: some View {
    gradient
      .mask(Capsule())
      .frame(height: trackHeight)
      .overlay(trackBorder)
  }
}

#Preview("Gradient Track Views") {
  /// A preview showcasing multiple `GradientTrackView` instances with varying color schemes.
  ///
  /// This preview demonstrates the `GradientTrackView` with different gradient color arrays,
  /// including a rainbow gradient generated using hues.
  let rainbowHues = stride(from: 0, to: 1, by: 0.01).map { hue in
    Color.init(hue: hue, saturation: 1, brightness: 1)
  }
  VStack(spacing: 30) {
    GradientTrackView(colors: [.red, .orange, .yellow])
    GradientTrackView(colors: [.black, .init(white: 0.9)])
    GradientTrackView(colors: [.cyan, .pink])
    GradientTrackView(colors: rainbowHues)

    // Bordere example
    GradientTrackView(
      colors: [.green, .yellow],
      trackHeight: 25,
      borderColor: .green,
      lineWidth: 3
    )
  }
  .padding()
}
