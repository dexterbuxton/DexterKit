import SwiftUI
import Extensions

/// A view that represents a customizable track with a foreground and background,
/// typically used for sliders or progress indicators.
///
/// The `TrackView` displays a track with a specified percentage of foreground fill,
/// customizable colors, height, thumb size, and an optional border.
///
struct TrackView: View {
  // MARK: Properties

  /// The percentage of the track that is filled by the foreground.
  ///
  /// This value is clamped between `0.0` and `1.0`.
  private let percent: CGFloat

  /// The color of the foreground (filled portion) of the track.
  private let colorForeground: Color

  /// The color of the background (unfilled portion) of the track.
  private let colorBackground: Color

  /// The height of the track.
  private let trackHeight: CGFloat

  /// The size of the thumb, which affects the foreground width calculation.
  private let thumbSize: CGFloat

  /// The color of the track's border.
  private let borderColor: Color

  /// The width of the track's border.
  ///
  /// The border is drawn inset, so it never extends beyond the track's bounds.
  private let lineWidth: CGFloat

  // MARK: Initializer

  /// Creates a new `TrackView` with the specified parameters.
  ///
  /// - Parameters:
  ///   - percent: The percentage of the track to fill, clamped between `0.0` and `1.0`.
  ///   - colorForeground: The color of the foreground. Defaults to `.red`.
  ///   - colorBackground: The color of the background. Defaults to a light gray.
  ///   - trackHeight: The height of the track. Defaults to `10`.
  ///   - thumbSize: The size of the thumb. Defaults to `30`.
  ///   - borderColor: The border color. Defaults to `.separator` (a translucent hairline).
  ///   - lineWidth: The width of the border. Defaults to `0` (off).
  init(
    percent: CGFloat,
    colorForeground: Color = .red,
    colorBackground: Color = Color.init(white: 0.8),
    trackHeight: CGFloat = 10,
    thumbSize: CGFloat = 30,
    borderColor: Color = .separator,
    lineWidth: CGFloat = 0
  ) {
    self.percent = (0...1).clamp(percent)
    self.colorForeground = colorForeground
    self.colorBackground = colorBackground
    self.trackHeight = trackHeight
    self.thumbSize = thumbSize
    self.borderColor = borderColor
    self.lineWidth = lineWidth
  }

  // MARK: Views

  /// The background view of the track.
  ///
  /// This is a rectangle filled with the `colorBackground`.
  var trackBackground: some View {
    Rectangle()
      .fill(colorBackground)
  }

  /// The foreground view of the track.
  ///
  /// This is a rectangle filled with the `colorForeground`.
  var trackForeground: some View {
    Rectangle()
      .fill(colorForeground)
  }

  /// The border overlay of the track.
  ///
  /// Traces the capsule edge with an inset stroke so it stays within bounds.
  var trackBorder: some View {
    Capsule()
      .strokeBorder(borderColor, lineWidth: lineWidth)
  }

  /// The main body of the `TrackView`.
  ///
  /// This view uses a `GeometryReader` to calculate the width of the foreground
  /// based on the available width and the `percent` value.
  var body: some View {
    GeometryReader { reader in
      let width = reader.size.width
      ZStack(alignment: .leading) {
        trackBackground
        trackForeground
          .frame(width: foregroundWidth(from: width))
      }
      .mask(Capsule())
      .overlay(trackBorder)
    }
    .frame(height: trackHeight)
  }

  // MARK: Methods

  /// Calculates the width of the foreground based on the total width and the percentage.
  ///
  /// - Parameter width: The total width of the track.
  /// - Returns: The calculated width of the foreground.
  private func foregroundWidth(from width: CGFloat) -> CGFloat {
    // Calculate exact center location of thumb view
    let widthPercentage = (width - thumbSize) * percent
    let halfThumbsize = thumbSize / 2
    return widthPercentage + halfThumbsize
  }
}

#Preview("Track Views") {
  /// A preview of multiple `TrackView` instances with varying percentages.
  VStack(spacing: 30) {
    TrackView(percent: 1.0)
    TrackView(percent: 0.8)
    TrackView(percent: 0.6)
    TrackView(percent: 0.4)
    TrackView(percent: 0.2)
    TrackView(percent: 0.0)
  }
  .padding()
}

#Preview("Track - Modified") {
  TrackView(
    percent: 0.6,
    colorForeground: .blue,
    trackHeight: 25,
    borderColor: .blue,
    lineWidth: 4
  )
  .padding()
}
