import SwiftUI

/// A horizontal group of icon buttons sharing a single background container.
///
/// - Capsule (`.circle`) or rounded-rectangle (`.rectangle(spacing:)`) background
/// - The container scales when any button is pressed
/// - Individual icon scale and opacity animate on press, matching `IconButton`
/// - Rectangle width is exact — pass the same `spacing` used in the surrounding
///   `HStack` so the group lines up with standalone buttons
/// - Slots inherit the resolved icon color unless they carry their own `Icon`
///
/// Colors and weight come from the `IconButtonTheme` in the environment unless
/// overridden per call.
///
/// ```swift
/// HStack(spacing: 8) {
///   IconButtonGroup(style: .rectangle(spacing: 8)) {
///     IconButtonItem(.undo, action: undo)
///     IconButtonItem(.redo, action: redo)
///   }
///   IconButton(.delete, style: .rectangle, color: .red, action: delete)
/// }
/// ```
///
/// ### Disabling
///
/// Individual items disable via `IconButtonItem(_:isDisabled:action:)` at the
/// call site — each item's icon dims (or solid-swaps, if
/// `IconButtonColors.foregroundDisabled` is set) independently. Disabling the
/// *group* — `.disabled(true)` chained on the whole `IconButtonGroup` —
/// supersedes every item's own state: while the group is disabled, every item
/// is disabled regardless of what it passed individually. This falls out of
/// how SwiftUI composes `isEnabled` through the environment, so no extra API
/// is needed:
///
/// The group's *shared background* dims/swaps in two cases: the group itself
/// was disabled via `.disabled()`, or every item happened to disable itself
/// individually (spacer slots don't count). A group with only *some* items
/// disabled keeps its enabled background — there's one shared shape behind
/// the whole row, so it can't show two background colors at once; only the
/// individual icons reflect a mixed state.
///
/// ```swift
/// IconButtonGroup {
///   IconButtonItem(.undo, isDisabled: !canUndo, action: undo)
///   IconButtonItem(.redo, action: redo)
/// }
/// .disabled(isLocked)   // true here disables both, whatever canUndo/redo say
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
  private let backgroundOverride: Color?
  private let iconColorOverride: Color?
  private let weightOverride: Font.Weight?

  @State private var viewModel = IconButtonViewModel()
  @Environment(\.iconButtonTheme) private var theme
  @Environment(\.isEnabled) private var isEnabled

  // MARK: Initialization

  /// Creates a button group using a result builder.
  public init(
    style: Style = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    backgroundColor: Color? = nil,
    iconColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    @IconButtonItemBuilder items: () -> [IconButtonItem]
  ) {
    self.items = items()
    self.style = style
    self.size = size
    self.backgroundOverride = backgroundColor
    self.iconColorOverride = iconColor
    self.weightOverride = iconWeight
  }

  /// Creates a button group from an array of items.
  public init(
    style: Style = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    backgroundColor: Color? = nil,
    iconColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    items: [IconButtonItem]
  ) {
    self.items = items
    self.style = style
    self.size = size
    self.backgroundOverride = backgroundColor
    self.iconColorOverride = iconColor
    self.weightOverride = iconWeight
  }

  // MARK: Computed Helpers

  /// Whether the group itself has been disabled via `.disabled()`. This
  /// supersedes every item's own `isDisabled`, since a disabled ambient
  /// environment forces every item's effective disabled state to `true` below.
  private var groupDisabled: Bool {
    !isEnabled
  }

  /// An item's effective disabled state — its own flag OR the group's.
  private func resolvedDisabled(for item: IconButtonItem) -> Bool {
    groupDisabled || item.isDisabled
  }

  /// Whether the group's shared background should render in its disabled
  /// state. True when the group itself was disabled via `.disabled()`, or
  /// when every *interactive* item disabled itself individually — spacer
  /// slots (`IconButtonItem.isEmpty`) don't count, since they're not buttons.
  ///
  /// This only affects the shared background; per-item icon dimming already
  /// follows each item's own `resolvedDisabled(for:)` regardless.
  private var containerDisabled: Bool {
    guard !groupDisabled else { return true }
    let interactiveItems = items.filter { !$0.isEmpty }
    guard !interactiveItems.isEmpty else { return false }
    return interactiveItems.allSatisfy(\.isDisabled)
  }

  // MARK: Body

  public var body: some View {
    let resolvedBackground = theme.colors.resolvedBackground(override: backgroundOverride, disabled: containerDisabled)
    let resolvedWeight = weightOverride ?? theme.weight

    HStack(spacing: style.spacing) {
      ForEach(Array(items.indices), id: \.self) { index in
        let item = items[index]
        if item.isEmpty {
          Color.clear
            .frame(width: size, height: size)
        }
        else {
          let itemDisabled = resolvedDisabled(for: item)
          let resolvedIconColor = theme.colors.resolvedForeground(override: iconColorOverride, disabled: itemDisabled)
          let icon = item.resolvedIcon(defaultColor: resolvedIconColor)
          let isAnimating = viewModel.animatingButtonIndex == index
          Button(action: item.action) {
            IconView(
              icon,
              size: size * CustomButtonConfiguration.iconSizeRatio,
              weight: isAnimating
                ? resolvedWeight.bolder(by: CustomButtonConfiguration.pressedWeightSteps)
                : resolvedWeight
            )
              .scaleEffect(isAnimating ? groupedIconScale : CustomButtonConfiguration.normalIconScale)
              .animation(.easeOut(duration: CustomButtonConfiguration.iconScaleAnimationDuration), value: viewModel.animatingButtonIndex)
              .frame(width: size, height: size)
              .contentShape(Rectangle())
          }
          .opacity(resolvedPressOpacity(for: index))
          .animation(.easeOut(duration: CustomButtonConfiguration.iconAnimationDuration), value: viewModel.isButtonPressed(at: index))
          .disabled(itemDisabled)
          .accessibilityLabel(icon.accessibilityLabel)
          .buttonStyle(CustomGroupButtonPressStyle(index: index, viewModel: viewModel))
        }
      }
    }
    .frame(height: size)
    .padding(.horizontal, circleInnerPadding)
    .frame(width: groupWidth)
    .background(
      groupShape
        .fill(resolvedBackground)
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

  /// Press-feedback opacity only. Disabled dimming now lives in the icon's
  /// resolved color (see `resolvedIconColor` in `body`), so this no longer
  /// takes a disabled flag.
  private func resolvedPressOpacity(for index: Int) -> Double {
    viewModel.isButtonPressed(at: index)
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
      IconButtonItem(.undo, action: {})
      IconButtonItem(.redo, action: {})
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
      IconButton(.trash, style: .rectangle, color: .red, action: {})
    }
    // Spacer slot — reserves a button's space without rendering one.
    IconButtonGroup(style: .rectangle(spacing: 8)) {
      IconButtonItem(.back, action: {})
      IconButtonItem.spacer
      IconButtonItem.spacer
      IconButtonItem(.forward, action: {})
    }
  }
  .padding()
}

#Preview("Icon Button Group Disabled") {
  // Same color definitions as the "Icon Button Disabled" preview in
  // IconButton.swift, reused here for a direct visual comparison.

  // Gray colors with disabled colors set at the exact default opacity —
  // looks identical to plain opacity-dimming, just made explicit.
  let defaultDisabledColors = IconButtonColors(
    foreground: Color(white: 0.2),
    background: Color(white: 0.9),
    foregroundDisabled: Color(white: 0.2).opacity(0.4),
    backgroundDisabled: Color(white: 0.9).opacity(0.4)
  )
  let defaultDisabledTheme = IconButtonTheme(colors: defaultDisabledColors)

  // Colors with a solid-swap disabled pair that doesn't match a fade.
  let customDisabledColors = IconButtonColors(
    foreground: .blue,
    background: .yellow,
    foregroundDisabled: .red,
    backgroundDisabled: .green
  )
  let customDisabled = IconButtonTheme(colors: customDisabledColors)

  return VStack(alignment: .leading, spacing: 50) {
    // Default-style (opacity-matched) disabled colors.
    VStack(spacing: 8) {
      // 1: One item disabled.
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(defaultDisabledTheme)
      // 2: Two items disabled.
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(defaultDisabledTheme)
      // 3: All three disabled
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, isDisabled: true, action: {})
      }
      .theme(defaultDisabledTheme)
      // 4: Group Disabled
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, action: {})
        IconButtonItem(.cancel, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(defaultDisabledTheme)
      .disabled(true)
    }

    // Custom solid-swap disabled colors — same progression.
    VStack(spacing: 8) {
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(customDisabled)
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(customDisabled)
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, isDisabled: true, action: {})
      }
      .theme(customDisabled)
      IconButtonGroup(style: .rectangle(spacing: 8)) {
        IconButtonItem(.back, action: {})
        IconButtonItem(.cancel, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(customDisabled)
      .disabled(true)
    }
  }
  .padding()
}
