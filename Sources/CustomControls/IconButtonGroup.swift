import SwiftUI

/// A horizontal group of icon buttons sharing a single background container.
///
/// - Capsule (`.circle`) or rounded-rectangle (`.rectangle(spacing:)`) background
/// - The container scales when any button is pressed
/// - Individual icon scale and opacity animate on press, matching `IconButton`
/// - Rectangle width is exact — pass the same `spacing` used in the surrounding
///   `HStack` so the group lines up with standalone buttons
/// - Slots inherit `iconColor` unless they carry their own `Icon`
///
/// ```swift
/// HStack(spacing: 8) {
///   IconButtonGroup(style: .rectangle(spacing: 8)) {
///     IconButtonItem(.undo, action: undo)
///     IconButtonItem(.redo, action: redo)
///   }
///   IconButton(.delete, style: .rectangle, action: delete)
/// }
/// ```
public struct IconButtonGroup: View {

  // MARK: Types

  /// The visual style and spacing of an `IconButtonGroup`.
  public enum Style: Equatable, Sendable {
    /// Capsule background with inner horizontal padding.
    case circle
    /// Rounded-rectangle background with exact width from button count and spacing.
    case rectangle(spacing: CGFloat)

    var spacing: CGFloat {
      switch self {
      case .circle: CustomButtonConfiguration.groupSpacing
      case .rectangle(let spacing): spacing
      }
    }
  }

  // MARK: Properties

  private let items: [IconButtonItem]
  private let style: Style
  private let size: CGFloat
  private let backgroundColor: Color
  private let iconColor: Color

  @State private var viewModel = IconButtonViewModel()

  // MARK: Initialization

  /// Creates a button group using a result builder.
  public init(
    style: Style = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    backgroundColor: Color = Color.primary.opacity(0.08),
    iconColor: Color = .primary,
    @IconButtonItemBuilder items: () -> [IconButtonItem]
  ) {
    self.items = items()
    self.style = style
    self.size = size
    self.backgroundColor = backgroundColor
    self.iconColor = iconColor
  }

  /// Creates a button group from an array of items.
  public init(
    style: Style = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    backgroundColor: Color = Color.primary.opacity(0.08),
    iconColor: Color = .primary,
    items: [IconButtonItem]
  ) {
    self.items = items
    self.style = style
    self.size = size
    self.backgroundColor = backgroundColor
    self.iconColor = iconColor
  }

  // MARK: Body

  public var body: some View {
    HStack(spacing: style.spacing) {
      ForEach(Array(items.indices), id: \.self) { index in
        let item = items[index]
        let icon = item.resolvedIcon(defaultColor: iconColor)
        Button(action: item.action) {
          IconView(icon, size: size * CustomButtonConfiguration.iconSizeRatio)
            .scaleEffect(viewModel.animatingButtonIndex == index ? groupedIconScale : CustomButtonConfiguration.normalIconScale)
            .animation(.easeOut(duration: CustomButtonConfiguration.iconScaleAnimationDuration), value: viewModel.animatingButtonIndex)
            .frame(width: size, height: size)
            .contentShape(Rectangle())
        }
        .opacity(resolvedOpacity(for: index, isDisabled: item.isDisabled))
        .animation(.easeOut(duration: CustomButtonConfiguration.iconAnimationDuration), value: viewModel.isButtonPressed(at: index))
        .disabled(item.isDisabled)
        .accessibilityLabel(icon.type.accessibilityLabel)
        .buttonStyle(CustomGroupButtonPressStyle(index: index, viewModel: viewModel))
      }
    }
    .frame(height: size)
    .padding(.horizontal, circleInnerPadding)
    .frame(width: groupWidth)
    .background(
      groupShape
        .fill(backgroundColor)
        .scaleEffect(
          x: viewModel.animatingButtonIndex != nil ? pressedScaleX : CustomButtonConfiguration.normalScale,
          y: viewModel.animatingButtonIndex != nil ? pressedScaleY : CustomButtonConfiguration.normalScale
        )
        .animation(.easeOut(duration: CustomButtonConfiguration.backgroundAnimationDuration), value: viewModel.animatingButtonIndex)
    )
  }

  // MARK: Layout Helpers

  private var groupShape: AnyShape {
    switch style {
    case .circle:
      AnyShape(Capsule())
    case .rectangle:
      AnyShape(RoundedRectangle(cornerRadius: CustomButtonConfiguration.roundedRectangleCornerRadius))
    }
  }

  private var groupWidth: CGFloat? {
    switch style {
    case .circle:
      nil
    case .rectangle(let spacing):
      CGFloat(items.count) * size + CGFloat(items.count - 1) * spacing
    }
  }

  private var circleInnerPadding: CGFloat {
    if case .circle = style {
      return CustomButtonConfiguration.groupInnerPadding
    }
    return 0
  }

  // MARK: Animation Helpers

  private var pressedExpansion: CGFloat {
    let multiplier: CGFloat
    switch style {
    case .circle:       multiplier = 0.25
    case .rectangle:    multiplier = 0.5
    }
    return size * (CustomButtonConfiguration.pressedBackgroundScale - 1) * multiplier
  }

  private var pressedScaleX: CGFloat {
    let width: CGFloat
    switch style {
    case .circle:
      let innerPadding = CustomButtonConfiguration.groupInnerPadding * 2
      width = CGFloat(items.count) * size + CGFloat(items.count - 1) * style.spacing + innerPadding
    case .rectangle(let spacing):
      width = CGFloat(items.count) * size + CGFloat(items.count - 1) * spacing
    }
    return (width + pressedExpansion * 2) / width
  }

  private var pressedScaleY: CGFloat {
    CustomButtonConfiguration.pressedBackgroundScale
  }

  private func resolvedOpacity(for index: Int, isDisabled: Bool) -> Double {
    if isDisabled {
      return CustomButtonConfiguration.disabledOpacity
    }
    return viewModel.isButtonPressed(at: index)
      ? CustomButtonConfiguration.pressedIconOpacity
      : CustomButtonConfiguration.enabledOpacity
  }

  /// Scales the icon by the same point expansion a standalone press produces,
  /// expressed relative to the icon's size. Rectangle uses a larger multiplier
  /// to compensate for the absence of inner padding.
  private var groupedIconScale: CGFloat {
    let iconSize = size * CustomButtonConfiguration.iconSizeRatio
    let multiplier: CGFloat
    switch style {
    case .circle:       multiplier = 1.0
    case .rectangle:    multiplier = 1.4
    }
    let expansion = size * (CustomButtonConfiguration.pressedIconScale - 1) * multiplier
    return (iconSize + expansion) / iconSize
  }
}

// MARK: Preview

#Preview("Icon Button Group") {
  VStack(alignment: .leading, spacing: 24) {
    IconButtonGroup {
      IconButtonItem(.minus, action: {})
      IconButtonItem(.plus, action: {})
    }

    IconButtonGroup {
      IconButtonItem(.back, action: {})
      IconButtonItem(.forward, action: {})
      IconButtonItem(.cancel, action: {})
      IconButtonItem(.done, action: {})
    }

    // Rectangle group aligned with a standalone button at the same spacing.
    HStack(spacing: 8) {
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.undo, action: {})
        IconButtonItem(.redo, action: {})
      }
      IconButton(.delete, style: .rectangle, color: .primary, accentColor: .red, action: {})
    }
  }
  .padding()
}
