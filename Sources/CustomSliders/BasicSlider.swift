import SwiftUI
import Extensions

/// A customizable slider component for SwiftUI
public struct BasicSlider: View {
  // MARK: Properties

  /// The configuration object for the slider, managing its state and behavior.
  @StateObject private var config: SliderConfig

  /// The color of the slider's thumb.
  private var thumbColor = Color.init(white: 0.6)

  /// The foreground color of the slider's track.
  private var trackForeground = Color.blue

  /// The background color of the slider's track.
  private var trackBackground = Color.init(white: 0.8)

  /// The border color of the slider's thumb.
  ///
  /// Defaults to the system background so the ring reads as a cutout — the
  /// surface behind the slider showing through.
  private var thumbBorderColor: Color = .systemBackground

  /// The border width of the slider's thumb. On by default.
  private var thumbBorderWidth: CGFloat = 3

  /// The border color of the slider's track.
  ///
  /// Pre-set to `.separator`, but disabled (width `0`) until a width is given.
  private var trackBorderColor: Color = .separator

  /// The border width of the slider's track. Off (`0`) by default.
  private var trackBorderWidth: CGFloat = 0

  /// The height (thickness) of the slider's track.
  private var trackHeight: CGFloat

  /// A flag indicating whether the slider is currently being moved.
  @State private var isMoving = false

  /// The binding to the slider's value.
  @Binding private var value: Double

  // MARK: Initializer

  /// Creates a new `BasicSlider` instance.
  ///
  /// - Parameters:
  ///   - value: A binding to the slider's value.
  ///   - range: The range of values the slider can represent. Defaults to `0...1`.
  ///   - step: The step value for the slider. Defaults to `0.1`.
  ///   - thumbSize: The size of the slider's thumb. Defaults to `30`.
  ///   - trackHeight: The thickness of the slider's track. Defaults to `10`.
  public init(
    value: Binding<Double>,
    in range: ClosedRange<Double> = 0...1,
    step: Double = 0.1,
    thumbSize: CGFloat = 30,
    trackHeight: CGFloat = 10
  ) {
    self._value = value
    self.trackHeight = trackHeight
    _config = StateObject(
      wrappedValue: SliderConfig(
        value: value.wrappedValue,
        range: range,
        thumbSize: thumbSize,
        step: step
      )
    )
  }

  // MARK: Views

  /// The body of the `BasicSlider`, defining its appearance and behavior.
  public var body: some View {
    GeometryReader { reader in
      ZStack {
        TrackView(
          percent: config.percent,
          colorForeground: trackForeground,
          colorBackground: trackBackground,
          trackHeight: trackHeight,
          thumbSize: config.thumbSize,
          borderColor: trackBorderColor,
          lineWidth: trackBorderWidth
        )
        .simultaneousGesture(tapGesture(given: reader.size.width))
        ThumbView(
          size: CGFloat(config.thumbSize),
          color: thumbColor,
          borderColor: thumbBorderColor,
          lineWidth: thumbBorderWidth
        )
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

  /// Sets the color of the slider's thumb.
  ///
  /// - Parameter value: The color to set for the thumb.
  /// - Returns: A modified `BasicSlider` with the specified thumb color.
  public func thumbColor(_ value: Color) -> Self {
    return self.modifying(\.thumbColor, value: value)
  }

  /// Sets the foreground color of the slider's track.
  ///
  /// - Parameter value: The color to set for the track's foreground.
  /// - Returns: A modified `BasicSlider` with the specified track foreground color.
  public func trackForeground(_ value: Color) -> Self {
    return self.modifying(\.trackForeground, value: value)
  }

  /// Sets the background color of the slider's track.
  ///
  /// - Parameter value: The color to set for the track's background.
  /// - Returns: A modified `BasicSlider` with the specified track background color.
  public func trackBackground(_ value: Color) -> Self {
    return self.modifying(\.trackBackground, value: value)
  }

  /// Sets the slider's colors in one call.
  ///
  /// Any parameter left `nil` is left unchanged, so you can set one, two, or all three.
  ///
  /// - Parameters:
  ///   - thumb: The thumb fill color.
  ///   - tint: The track's filled (foreground) color.
  ///   - track: The track's unfilled (background) color.
  /// - Returns: A modified `BasicSlider` with the specified colors.
  public func color(thumb: Color? = nil, tint: Color? = nil, track: Color? = nil) -> Self {
    var copy = self
    if let thumb { copy.thumbColor = thumb }
    if let tint { copy.trackForeground = tint }
    if let track { copy.trackBackground = track }
    return copy
  }

  /// Enables and styles the slider's track border.
  ///
  /// Defaults to a `.separator` hairline, so `trackBorder()` turns on a sensible
  /// adaptive border with no arguments.
  ///
  /// - Parameters:
  ///   - color: The track border color. Defaults to `.separator`.
  ///   - lineWidth: The track border width. Defaults to `1`.
  /// - Returns: A modified `BasicSlider` with the specified track border.
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
  /// - Returns: A modified `BasicSlider` with the specified thumb border.
  public func thumbBorder(_ color: Color = .systemBackground, lineWidth: CGFloat = 3) -> Self {
    return self.modifying(\.thumbBorderColor, value: color)
      .modifying(\.thumbBorderWidth, value: lineWidth)
  }
}

#Preview("Sliders") {
  /// A preview showcasing multiple `BasicSlider` instances with different values.
  VStack(spacing: 30) {
    BasicSlider(value: .constant(0.85))
      .color(tint: .red)
    BasicSlider(value: .constant(0.25))
      .color(tint: .green)
    BasicSlider(value: .constant(0.65))
      .color(tint: .blue)
  }
  .padding()
}

#Preview("Sliders - Modified") {
  BasicSlider(
    value: .constant(0.65),
    thumbSize: 40,
    trackHeight: 25
  )
    .color(thumb: .white, tint: .black, track: .red)
    .thumbBorder(.red, lineWidth: 5)
    .trackBorder(.red, lineWidth: 5)
    .padding()
}
