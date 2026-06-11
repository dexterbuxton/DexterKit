import SwiftUI

/// A view that represents a gradient track with customizable colors and height.
///
/// The `GradientTrackView` is a rectangular view that displays a gradient effect
/// using a linear gradient with specified colors and a capsule mask.
struct GradientTrackView: View {

  // MARK: Properties

  /// The array of colors used to create the gradient.
  private let colors: [Color]

  /// The height of the gradient track.
  private let trackHeight: CGFloat

  // MARK: Initializer

  /// Creates a new `GradientTrackView` with the specified properties.
  ///
  /// - Parameters:
  ///   - colors: The array of colors used to create the gradient.
  ///   - trackHeight: The height of the gradient track. Defaults to `10`.
  init(
    colors: [Color],
    trackHeight: CGFloat = 10
  ) {
    self.colors = colors
    self.trackHeight = trackHeight
  }

  // MARK: Views

  /// The linear gradient view created using the specified colors.
  ///
  /// This view uses a `LinearGradient` to display a gradient effect
  /// that transitions between the provided colors from leading to trailing.
  var gradient: some View {
    LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
  }

  /// The content and behavior of the `GradientTrackView`.
  ///
  /// This view displays the gradient with a capsule mask and a specified height.
  var body: some View {
    gradient
      .mask(Capsule())
      .frame(height: trackHeight)
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
  }
  .padding()
}
