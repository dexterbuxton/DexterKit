import SwiftUI
import Extensions

/// A view that represents a gradient thumb with customizable colors, size, and border.
///
/// The `GradientThumbView` is a circular view that displays a gradient effect
/// between two colors, with an optional border and scaling animation when selected.
struct GradientThumbView: View {

  // MARK: Properties

  /// The size of the thumb view.
  private let size: CGFloat

  /// The leading color of the gradient.
  private let colorLeading: Color

  /// The trailing color of the gradient.
  private let colorTrailing: Color

  /// The percentage of the trailing color's opacity.
  private let percent: Double

  /// The color of the border stroke.
  private let borderColor: Color

  /// The width of the border stroke.
  private let lineWidth: CGFloat

  /// A state variable indicating whether the thumb is selected.
  @State private var isSelected: Bool = false

  /// The scale factor applied to the thumb when selected.
  private var scale: CGFloat {
    isSelected ? 1.25 : 1
  }

  // MARK: Initializer

  /// Creates a new `GradientThumbView` with the specified properties.
  ///
  /// - Parameters:
  ///   - size: The size of the thumb view. Defaults to `35`.
  ///   - colorLeading: The leading color of the gradient.
  ///   - colorTrailing: The trailing color of the gradient.
  ///   - percent: The percentage of the trailing color's opacity.
  ///   - borderColor: The border color. Defaults to `.systemBackground` (reads as a cutout).
  ///   - lineWidth: The width of the border. Defaults to `3`.
  init(
    size: CGFloat = 35,
    colorLeading: Color,
    colorTrailing: Color,
    percent: Double,
    borderColor: Color = .systemBackground,
    lineWidth: CGFloat = 3
  ) {
    self.size = size
    self.colorLeading = colorLeading
    self.colorTrailing = colorTrailing
    self.percent = percent
    self.borderColor = borderColor
    self.lineWidth = lineWidth
  }

  // MARK: Views

  /// The content and behavior of the `GradientThumbView`.
  var body: some View {
    ZStack {
      Circle()
        .fill(colorLeading)
      Circle()
        .fill(colorTrailing)
        .opacity(percent)
        .overlay(
          Circle()
            .stroke(borderColor, lineWidth: lineWidth)
        )
    }
    .frame(width: size, height: size)
    .scaleEffect(scale)
    .gesture(selectGesture)
  }

  // MARK: Gestures

  /// A gesture that handles the selection animation of the thumb view.
  private var selectGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .onChanged { _ in
        animateSelection(true)
      }
      .onEnded { _ in
        animateSelection(false)
      }
  }

  // MARK: Methods

  /// Animates the selection state of the thumb view.
  ///
  /// - Parameter newValue: A Boolean value indicating the new selection state.
  private func animateSelection(_ newValue: Bool) {
    withAnimation(.easeInOut(duration: 0.2)) {
      isSelected = newValue
    }
  }
}

#Preview("Gradient Thumb Views") {
  /// A preview showcasing `GradientThumbView` across the percent range, plus a bordered example.
  HStack(spacing: 20) {
    GradientThumbView(colorLeading: .blue, colorTrailing: .red, percent: 0.0)
    GradientThumbView(colorLeading: .blue, colorTrailing: .red, percent: 0.5)
    GradientThumbView(colorLeading: .blue, colorTrailing: .red, percent: 1.0)
    GradientThumbView(
      colorLeading: .blue,
      colorTrailing: .red,
      percent: 0.5,
      borderColor: .white,
      lineWidth: 3
    )
  }
  .padding()
}
