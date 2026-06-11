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

  /// A flag indicating whether the slider is currently being moved.
  @State private var isMoving = false

  /// The leading color of the gradient thumb.
  private var thumbColorLeading: Color?

  /// The trailing color of the gradient thumb.
  private var thumbColorTrailing: Color?

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
  ///   - thumbColor: The color of the slider's thumb.
  ///   - trackColors: The colors of the slider's track.
  public init(
    value: Binding<Double>,
    in range: ClosedRange<Double> = 0...1,
    step: Double = 0.1,
    thumbSize: CGFloat = 30,
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
  ///   - colorLeading: The leading color of the gradient thumb.
  ///   - colorTrailing: The trailing color of the gradient thumb.
  public init(
    value: Binding<Double>,
    in range: ClosedRange<Double> = 0...1,
    step: Double = 0.1,
    thumbSize: CGFloat = 30,
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
          color: thumbColor
        )
      }
      if let colorLeading = thumbColorLeading,
         let colorTrailing = thumbColorTrailing {
        GradientThumbView(
          size: CGFloat(config.thumbSize),
          colorLeading: colorLeading,
          colorTrailing: colorTrailing,
          percent: config.percent)
      }
    }
  }

  /// The main body of the `GradientSlider`.
  public var body: some View {
    GeometryReader { reader in
      ZStack {
        GradientTrackView(colors: trackColors)
          .simultaneousGesture(tapGesture(given: reader.size.width))
        thumbView
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
    GradientSlider(
      value: .constant(1.0),
      colorLeading: .pink,
      colorTrailing: .cyan
    )
  }
  .padding()
}
