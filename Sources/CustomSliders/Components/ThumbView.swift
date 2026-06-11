import SwiftUI

/// A customizable thumb view for sliders or other UI components.
///
/// `ThumbView` is a circular view that can be customized with size, color, border, and line width.
/// It includes a scaling animation when selected.
struct ThumbView: View {
  // MARK: Properties

  /// The size of the thumb view.
  private let size: CGFloat

  /// The fill color of the thumb view.
  private let color: Color

  /// The width of the border around the thumb view.
  private let lineWidth: CGFloat

  /// The color of the border around the thumb view.
  private let borderColor: Color

  /// A state variable indicating whether the thumb view is selected.
  @State private var isSelected: Bool = false

  /// The scale factor applied to the thumb view when selected.
  private var scale: CGFloat {
    isSelected ? 1.25 : 1
  }

  // MARK: Initializer

  /// Creates a new `ThumbView` with the specified properties.
  ///
  /// - Parameters:
  ///   - size: The size of the thumb view. Default is `40`.
  ///   - color: The fill color of the thumb view. Default is a gray color.
  ///   - lineWidth: The width of the border around the thumb view. Default is `3`.
  ///   - borderColor: The color of the border around the thumb view. Default is white.
  init(
    size: CGFloat = 40,
    color: Color = Color.init(white: 0.6),
    lineWidth: CGFloat = 3,
    borderColor: Color = .white
  ) {
    self.size = size
    self.color = color
    self.lineWidth = lineWidth
    self.borderColor = borderColor
  }

  // MARK: Views

  /// The body of the `ThumbView`.
  ///
  /// This view consists of a circular shape with a customizable fill color, border, and scaling animation.
  var body: some View {
    ZStack {
      Circle()
        .fill(color)
        .frame(width: size)
        .overlay(
          Circle()
            .stroke(borderColor, lineWidth: lineWidth)
        )
    }
    .scaleEffect(scale)
    .gesture(selectGesture)
  }

  // MARK: Gestures

  /// A drag gesture that triggers the selection animation.
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

#Preview("Thumb Views (Mac)") {
  /// A preview showcasing `ThumbView` with red, yellow, and green colors.
  HStack(spacing: 20) {
    ThumbView(color: .red)
    ThumbView(color: .yellow)
    ThumbView(color: .green)
  }
  .padding()
}

#Preview("Thumb Views (CMYK)") {
  /// A preview showcasing `ThumbView` with CMYK colors and custom border styles.
  HStack(spacing: 40) {
    ThumbView(
      size: 35,
      color: .cyan,
      lineWidth: 15,
      borderColor: .cyan.opacity(0.2)
    )
    ThumbView(
      size: 35,
      color: .pink,
      lineWidth: 15,
      borderColor: .pink.opacity(0.2)
    )
    ThumbView(
      size: 35,
      color: .yellow,
      lineWidth: 15,
      borderColor: .yellow.opacity(0.3)
    )
    ThumbView(
      size: 35,
      color: .black,
      lineWidth: 15,
      borderColor: .black.opacity(0.15)
    )
  }
  .padding()
}
