import SwiftUI
import Extensions

/// A hue slider with a live thumb that reflects the selected hue.
///
/// Self-contained: it owns its value and renders a full rainbow track. Thumb and
/// track size are configurable, and it exposes the same border modifiers as the
/// other sliders.
///
/// ```swift
/// HueSlider()
/// HueSlider(thumbSize: 40, trackHeight: 8).trackBorder()
/// HueSlider().thumbBorder(.white, lineWidth: 4)
/// ```
public struct HueSlider: View {

  // MARK: Properties

  @State private var sliderValue: Double = 0.0

  private let thumbSize: CGFloat
  private let trackHeight: CGFloat

  /// The border color of the slider's thumb. Defaults to the cutout ring.
  private var thumbBorderColor: Color = .systemBackground

  /// The border width of the slider's thumb. On by default.
  private var thumbBorderWidth: CGFloat = 3

  /// The border color of the slider's track. Pre-set, but off until given a width.
  private var trackBorderColor: Color = .separator

  /// The border width of the slider's track. Off (`0`) by default.
  private var trackBorderWidth: CGFloat = 0

  /// A full spectrum of hues for the track.
  private let rainbowHues = stride(from: 0, to: 1, by: 0.01).map { hue in
    Color.init(hue: hue, saturation: 1, brightness: 1)
  }

  /// The thumb color for the current hue.
  private var rainbowThumbColor: Color {
    Color.init(hue: sliderValue, saturation: 1, brightness: 1)
  }

  // MARK: Initializer

  /// Creates a new `HueSlider`.
  ///
  /// - Parameters:
  ///   - thumbSize: The size of the slider's thumb. Defaults to `30`.
  ///   - trackHeight: The thickness of the slider's track. Defaults to `10`.
  public init(
    thumbSize: CGFloat = 30,
    trackHeight: CGFloat = 10
  ) {
    self.thumbSize = thumbSize
    self.trackHeight = trackHeight
  }

  // MARK: Body

  public var body: some View {
    GradientSlider(
      value: $sliderValue,
      step: 1 / 360.0,
      thumbSize: thumbSize,
      trackHeight: trackHeight,
      thumbColor: rainbowThumbColor,
      trackColors: rainbowHues
    )
    .thumbBorder(thumbBorderColor, lineWidth: thumbBorderWidth)
    .trackBorder(trackBorderColor, lineWidth: trackBorderWidth)
  }

  // MARK: Modifiers

  /// Sets the slider's thumb border.
  ///
  /// - Parameters:
  ///   - color: The thumb border color. Defaults to `.systemBackground`.
  ///   - lineWidth: The thumb border width. Defaults to `3`.
  /// - Returns: A modified `HueSlider` with the specified thumb border.
  public func thumbBorder(_ color: Color = .systemBackground, lineWidth: CGFloat = 3) -> Self {
    return self.modifying(\.thumbBorderColor, value: color)
      .modifying(\.thumbBorderWidth, value: lineWidth)
  }

  /// Enables and styles the slider's track border.
  ///
  /// Defaults to a `.separator` hairline, so `trackBorder()` turns on a sensible
  /// adaptive border with no arguments.
  ///
  /// - Parameters:
  ///   - color: The track border color. Defaults to `.separator`.
  ///   - lineWidth: The track border width. Defaults to `1`.
  /// - Returns: A modified `HueSlider` with the specified track border.
  public func trackBorder(_ color: Color = .separator, lineWidth: CGFloat = 1) -> Self {
    return self.modifying(\.trackBorderColor, value: color)
      .modifying(\.trackBorderWidth, value: lineWidth)
  }
}

#Preview("Hue Slider") {
  HueSlider()
    .padding()
}

#Preview("Hue - Modified") {
  HueSlider(thumbSize: 40, trackHeight: 20)
    .trackBorder(.black, lineWidth: 3)
    .thumbBorder(.black, lineWidth: 3)
    .padding()
}
