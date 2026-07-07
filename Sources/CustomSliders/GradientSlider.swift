import SwiftUI
import Extensions

/// A customizable gradient slider view
public struct GradientSlider: View {

  // MARK: Properties

  /// The configuration object for the slider.
  @StateObject private var config: SliderConfig

  /// The color of the slider's thumb.
  private var thumbColor: Color?

  /// The colors of the slider's track.
  private var trackColors: [Color]

  /// The height (thickness) of the slider's track.
  private var trackHeight: CGFloat

  /// A flag indicating whether the slider is currently being moved.
  @State private var isMoving = false

  /// The leading color of the gradient thumb.
  private var thumbColorLeading: Color?

  /// The trailing color of the gradient thumb.
  private var thumbColorTrailing: Color?

  /// The border color of the slider's thumb.
  ///
  /// Defaults to the system background so the ring reads as a cutout — the
  /// surface behind the slider showing through.
  private var thumbBorderColor: Color = .systemBackground

  /// The border width of the slider's thumb.
  private var thumbBorderWidth: CGFloat = 3

  /// The border color of the slider's track.
  ///
  /// Pre-set to `.separator`, but disabled (width `0`) until a width is given.
  private var trackBorderColor: Color = .separator

  /// The border width of the slider's track. Off (`0`) by default.
  private var trackBorderWidth: CGFloat = 0

  /// The binding to the slider's value.
  @Binding private var value: Double

  // MARK: Initializer

  /// Creates a `GradientSlider` with a solid thumb color.
  ///
  /// - Parameters:
  ///   - value: A binding to the slider's value.
  ///   - range: The range of values the slider can represent. Defaults to `0...1`.
  ///   - step: The step value for the slider. Defaults to `0.1`.
  ///   - thumbSize: The size of the slider's thumb. Defaults to `30`.
  ///   - trackHeight: The thickness of the slider's track. Defaults to `10`.
  ///   - thumbColor: The color of the slider's thumb.
  ///   - trackColors: The colors of the slider's track.
  public init(
    value: Binding<Double>,
    in range: ClosedRange<Double> = 0...1,
    step: Double = 0.1,
    thumbSize: CGFloat = 30,
    trackHeight: CGFloat = 10,
    thumbColor: Color,
    trackColors: [Color]
  ) {
    _config = StateObject(
      wrappedValue:
        SliderConfig(
          value: value.wrappedValue,
          range: range,
          thumbSize: thumbSize,
          step: step
        )
    )
    self._value = value
    self.trackHeight = trackHeight
    self.thumbColor = thumbColor
    self.trackColors = trackColors
  }

  /// Creates a `GradientSlider` with a gradient thumb.
  ///
  /// - Parameters:
  ///   - value: A binding to the slider's value.
  ///   - range: The range of values the slider can represent. Defaults to `0...1`.
  ///   - step: The step value for the slider. Defaults to `0.1`.
  ///   - thumbSize: The size of the slider's thumb. Defaults to `30`.
  ///   - trackHeight: The thickness of the slider's track. Defaults to `10`.
  ///   - colorLeading: The leading color of the gradient thumb.
  ///   - colorTrailing: The trailing color of the gradient thumb.
  public init(
    value: Binding<Double>,
    in range: ClosedRange<Double> = 0...1,
    step: Double = 0.1,
    thumbSize: CGFloat = 30,
    trackHeight: CGFloat = 10,
    colorLeading: Color,
    colorTrailing: Color
  ) {
    _config = StateObject(
      wrappedValue:
        SliderConfig(
          value: value.wrappedValue,
          range: range,
          thumbSize: thumbSize,
          step: step
        )
    )
    self._value = value
    self.trackHeight = trackHeight
    self.thumbColorLeading = colorLeading
    self.thumbColorTrailing = colorTrailing
    self.trackColors = [colorLeading, colorTrailing]
  }

  // MARK: Views

  /// The view representing the slider's thumb.
  var thumbView: some View {
    Group {
      if let thumbColor = thumbColor {
        ThumbView(
          size: CGFloat(config.thumbSize),
          color: thumbColor,
          borderColor: thumbBorderColor,
          lineWidth: thumbBorderWidth
        )
      }
      if let colorLeading = thumbColorLeading,
         let colorTrailing = thumbColorTrailing {
        GradientThumbView(
          size: CGFloat(config.thumbSize),
          colorLeading: colorLeading,
          colorTrailing: colorTrailing,
          percent: config.percent,
          borderColor: thumbBorderColor,
          lineWidth: thumbBorderWidth
        )
      }
    }
  }

  /// The main body of the `GradientSlider`.
  public var body: some View {
    GeometryReader { reader in
      ZStack {
        GradientTrackView(
          colors: trackColors,
          trackHeight: trackHeight,
          borderColor: trackBorderColor,
          lineWidth: trackBorderWidth
        )
        .simultaneousGesture(tapGesture(given: reader.size.width))
        thumbView
          .position(config.position(given: reader.size.width))
          .simultaneousGesture(moveGesture(given: reader.size.width))
      }
      .animation(isMoving ? .none : .easeInOut(duration: 0.3), value: config.value)
      .onChange(of: value) { _, newValue in
        config.value = newValue
      }
    }
    .frame(height: config.thumbSize)
  }

  // MARK: Gestures

  /// Creates a tap gesture for the slider.
  ///
  /// - Parameter width: The width of the slider's track.
  /// - Returns: A `Gesture` that updates the slider's value when tapped.
  private func tapGesture(given width: CGFloat) -> some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onEnded { touch in
        config.step(at: touch.location.x, given: width)
        value = config.value
      }
  }

  /// Creates a drag gesture for the slider.
  ///
  /// - Parameter width: The width of the slider's track.
  /// - Returns: A `Gesture` that updates the slider's value while dragging.
  private func moveGesture(given width: CGFloat) -> some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { touch in
        isMoving = true
        config.move(
          from: touch.startLocation.x,
          to: touch.location.x,
          given: width
        )
        value = config.value
      }
      .onEnded { _ in
        config.stop()
        isMoving = false
      }
  }

  // MARK: Modifiers

  /// Enables and styles the slider's track border.
  ///
  /// Defaults to a `.separator` hairline, so `trackBorder()` turns on a sensible
  /// adaptive border with no arguments.
  ///
  /// - Parameters:
  ///   - color: The track border color. Defaults to `.separator`.
  ///   - lineWidth: The track border width. Defaults to `1`.
  /// - Returns: A modified `GradientSlider` with the specified track border.
  public func trackBorder(_ color: Color = .separator, lineWidth: CGFloat = 1) -> Self {
    return self.modifying(\.trackBorderColor, value: color)
      .modifying(\.trackBorderWidth, value: lineWidth)
  }

  /// Sets the slider's thumb border.
  ///
  /// Defaults to the `.systemBackground` cutout ring already applied by default.
  ///
  /// - Parameters:
  ///   - color: The thumb border color. Defaults to `.systemBackground`.
  ///   - lineWidth: The thumb border width. Defaults to `3`.
  /// - Returns: A modified `GradientSlider` with the specified thumb border.
  public func thumbBorder(_ color: Color = .systemBackground, lineWidth: CGFloat = 3) -> Self {
    return self.modifying(\.thumbBorderColor, value: color)
      .modifying(\.thumbBorderWidth, value: lineWidth)
  }
}

#Preview("Gradient Sliders") {
  /// A preview showcasing multiple `GradientSlider` instances with different configurations.
  VStack(spacing: 30) {
    GradientSlider(
      value: .constant(0.0),
      colorLeading: .cyan,
      colorTrailing: .yellow
    )
    GradientSlider(
      value: .constant(0.75),
      colorLeading: .yellow,
      colorTrailing: .red
    )
    GradientSlider(
      value: .constant(0.25),
      colorLeading: .green,
      colorTrailing: .purple
    )
    .trackBorder() // default .separator hairline
    GradientSlider(
      value: .constant(1.0),
      colorLeading: .pink,
      colorTrailing: .cyan
    )
    .thumbBorder(.white, lineWidth: 4)
  }
  .padding()
}

#Preview("Gradient - Modified") {
  VStack(spacing: 30) {
    GradientSlider(
      value: .constant(0.5),
      thumbSize: 75,
      trackHeight: 25,
      colorLeading: .red,
      colorTrailing: .purple,
    )
    .thumbBorder(.black, lineWidth: 4)
    .trackBorder(.black, lineWidth: 4)

    GradientSlider(
      value: .constant(0.5),
      thumbSize: 25,
      trackHeight: 10,
      colorLeading: .green,
      colorTrailing: .blue,
    )
    .thumbBorder(.black, lineWidth: 1)
    .trackBorder(.black, lineWidth: 1)
  }
  .padding()
}
