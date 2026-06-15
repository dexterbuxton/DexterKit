import SwiftUI
import Extensions

/// A tappable button displaying a dot indicator, driven by a `Bool` binding.
///
/// The dot is visible when `isOn` is `true` and hidden when `false`. Colors are
/// passed in, so it carries no dependency on a theming environment. For single
/// selection across many buttons, derive each binding from shared parent state:
///
/// ```swift
/// CustomIndicatorButton(
///   isOn: Binding(get: { selected == item }, set: { _ in selected = item }),
///   color: item.color,
///   dotColor: .white
/// )
/// ```
public struct CustomIndicatorButton: View {

  // MARK: Properties

  private let style: CustomButtonStyle
  private let width: CGFloat
  private let height: CGFloat
  private let color: Color
  private let dotColor: Color
  private let dotScale: CGFloat
  private let borderColor: Color
  private let lineWidth: CGFloat

  @Binding private var isOn: Bool

  // MARK: Initialization

  /// Creates a square indicator button.
  public init(
    isOn: Binding<Bool>,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    color: Color,
    dotColor: Color,
    dotScale: CGFloat = CustomButtonConfiguration.indicatorDotRatio,
    borderColor: Color = .separator,
    lineWidth: CGFloat = 0
  ) {
    self.init(
      isOn: isOn,
      style: style,
      width: size,
      height: size,
      color: color,
      dotColor: dotColor,
      dotScale: dotScale,
      borderColor: borderColor,
      lineWidth: lineWidth
    )
  }

  /// Creates an indicator button with independent width and height.
  public init(
    isOn: Binding<Bool>,
    style: CustomButtonStyle = .circle,
    width: CGFloat,
    height: CGFloat,
    color: Color,
    dotColor: Color,
    dotScale: CGFloat = CustomButtonConfiguration.indicatorDotRatio,
    borderColor: Color = .separator,
    lineWidth: CGFloat = 0
  ) {
    self._isOn = isOn
    self.style = style
    self.width = width
    self.height = height
    self.color = color
    self.dotColor = dotColor
    self.dotScale = dotScale
    self.borderColor = borderColor
    self.lineWidth = lineWidth
  }

  // MARK: Computed Helpers

  /// The dot scales off the smaller dimension so it always fits a short swatch.
  private var dotSize: CGFloat {
    min(width, height) * dotScale
  }

  // MARK: Body

  public var body: some View {
    Button {
      isOn.toggle()
    } label: {
      Circle()
        .fill(dotColor)
        .frame(width: dotSize, height: dotSize)
        .opacity(isOn ? CustomButtonConfiguration.enabledOpacity : 0)
        .animation(.easeInOut(duration: 0.2), value: isOn)
        .frame(width: width, height: height)
        .contentShape(Rectangle())
        .background(
          RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: style))
            .fill(color)
        )
        .overlay(
          RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: style))
            .strokeBorder(borderColor, lineWidth: lineWidth)
        )
    }
    .buttonStyle(CustomButtonPressStyle())
  }
}

// MARK: Preview

#Preview("App Indicator Button") {
  struct PreviewContent: View {
    @State private var isOnCircle = true
    @State private var isOnRectangle = false

    var body: some View {
      VStack(spacing: 16) {
        HStack(spacing: 16) {
          CustomIndicatorButton(isOn: $isOnCircle, color: .blue, dotColor: .white)
          CustomIndicatorButton(isOn: $isOnRectangle, style: .rectangle, color: .green, dotColor: .black)
        }
        // Rectangular (wide-short) — the new initializer.
        CustomIndicatorButton(
          isOn: .constant(true),
          style: .rectangle,
          width: 120,
          height: 32,
          color: .orange,
          dotColor: .black
        )
        // Bordered examples.
        HStack(spacing: 16) {
          CustomIndicatorButton(
            isOn: .constant(true),
            color: .white,
            dotColor: .black,
            borderColor: .black.opacity(0.25),
            lineWidth: 2
          )
          CustomIndicatorButton(
            isOn: .constant(false),
            style: .rectangle,
            color: .yellow,
            dotColor: .black,
            borderColor: .orange,
            lineWidth: 2
          )
        }
      }
      .padding()
    }
  }

  return PreviewContent()
}
