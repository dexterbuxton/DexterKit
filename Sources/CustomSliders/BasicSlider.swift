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
  init(
    value: Binding<Double>,
    in range: ClosedRange<Double> = 0...1,
    step: Double = 0.1,
    thumbSize: CGFloat = 30
  ) {
    self._value = value
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
          thumbSize: config.thumbSize
        )
        .simultaneousGesture(tapGesture(given: reader.size.width))
        ThumbView(
          size: CGFloat(config.thumbSize),
          color: thumbColor
        )
        .position(config.position(given: reader.size.width))
        .simultaneousGesture(moveGesture(given: reader.size.width))
      }
      .animation(isMoving ? .none : .easeInOut(duration: 0.3), value: config.value)
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
}

#Preview("Sliders") {
  /// A preview showcasing multiple `BasicSlider` instances with different values.
  VStack(spacing: 30) {
    BasicSlider(value: .constant(0.0))
      .trackForeground(.black)
      .thumbColor(.black)
    BasicSlider(value: .constant(0.25))
      .trackForeground(.purple)
    BasicSlider(value: .constant(0.5))
      .trackForeground(.green)
    BasicSlider(value: .constant(0.75))
      .trackForeground(.red)
    BasicSlider(value: .constant(1.0))
  }
  .padding()
}
