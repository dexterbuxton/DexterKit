import SwiftUI

/// A horizontal group of icon buttons sharing a single background container.
///
/// - Capsule (`.circle`) or rounded-square (`.square(spacing:)`) background
/// - The container grows by a fixed point value when any button is pressed
/// - Individual icon scale and opacity animate on press, matching `IconButton`
/// - Both styles report the same overall width for a given item count and
///   spacing — `.circle` no longer sizes to intrinsic content, so a circle
///   group and a square group with the same items/spacing line up exactly
/// - Slots inherit the resolved icon color unless they carry their own `Icon`
///
/// Size, color overrides, and press expansion come from the environment,
/// same as `IconButton`.
///
/// ```swift
/// HStack(spacing: 8) {
///   IconButtonGroup(style: .square(spacing: 8)) {
///     IconButtonItem(.undo, action: undo)
///     IconButtonItem(.redo, action: redo)
///   }
///   IconButton(.delete, style: .square, action: delete).iconColor(.red)
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
/// is disabled regardless of what it passed individually.
///
/// The group's *shared background* dims/swaps in two cases: the group itself
/// was disabled via `.disabled()`, or every item happened to disable itself
/// individually (spacer slots don't count). A group with only *some* items
/// disabled keeps its enabled background — there's one shared shape behind
/// the whole row, so it can't show two background colors at once; only the
/// individual icons reflect a mixed state.
public struct IconButtonGroup: View {

  // MARK: Types

  /// The visual style and spacing of an `IconButtonGroup`.
  public enum Style: Equatable, Sendable {
    /// Capsule background with the same shared inner padding as `.square`.
    case circle
    /// Rounded-square background with exact width from button count and spacing.
    case square(spacing: CGFloat)

    var spacing: CGFloat {
      switch self {
      case .circle: CustomButtonConfiguration.groupSpacing
      case .square(let spacing): spacing
      }
    }
  }

  // MARK: Properties

  private let items: [IconButtonItem]
  private let style: Style

  @State private var viewModel = IconButtonViewModel()
  @Environment(\.iconButtonTheme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.buttonSize) private var buttonSize
  @Environment(\.buttonPressExpansion) private var pressExpansion
  @Environment(\.iconColorOverride) private var iconColorOverride
  @Environment(\.iconBackgroundOverride) private var iconBackgroundOverride

  // MARK: Initialization

  /// Creates a button group using a result builder.
  public init(style: Style = .circle, @IconButtonItemBuilder items: () -> [IconButtonItem]) {
    self.items = items()
    self.style = style
  }

  /// Creates a button group from an array of items.
  public init(style: Style = .circle, items: [IconButtonItem]) {
    self.items = items
    self.style = style
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
  private var containerDisabled: Bool {
    guard !groupDisabled else { return true }
    let interactiveItems = items.filter { !$0.isEmpty }
    guard !interactiveItems.isEmpty else { return false }
    return interactiveItems.allSatisfy(\.isDisabled)
  }

  // MARK: Body

  public var body: some View {
    let resolvedBackground = theme.colors.resolvedBackground(override: iconBackgroundOverride, disabled: containerDisabled)
    let resolvedWeight = theme.weight

    HStack(spacing: style.spacing) {
      ForEach(Array(items.indices), id: \.self) { index in
        let item = items[index]
        if item.isEmpty {
          Color.clear
            .frame(width: buttonSize.width, height: buttonSize.height)
        }
        else {
          let itemDisabled = resolvedDisabled(for: item)
          let resolvedIconColor = theme.colors.resolvedForeground(override: iconColorOverride, disabled: itemDisabled)
          let icon = item.resolvedIcon(defaultColor: resolvedIconColor)
          let isAnimating = viewModel.animatingButtonIndex == index
          Button(action: item.action) {
            IconView(
              icon,
              size: min(buttonSize.width, buttonSize.height) * CustomButtonConfiguration.iconSizeRatio,
              weight: isAnimating
                ? resolvedWeight.bolder(by: CustomButtonConfiguration.pressedWeightSteps)
                : resolvedWeight
            )
              .scaleEffect(isAnimating ? groupedIconScale : CustomButtonConfiguration.normalIconScale)
              .animation(.easeOut(duration: CustomButtonConfiguration.iconScaleAnimationDuration), value: viewModel.animatingButtonIndex)
              .frame(width: buttonSize.width, height: buttonSize.height)
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
    .frame(height: buttonSize.height)
    .padding(.horizontal, CustomButtonConfiguration.groupInnerPadding)
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
    case .square:
      AnyShape(RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: .square)))
    }
  }

  /// Explicit, non-optional width for both styles — no shape relies on
  /// SwiftUI measuring its intrinsic content size.
  private var groupWidth: CGFloat {
    let padding = CustomButtonConfiguration.groupInnerPadding * 2
    return CGFloat(items.count) * buttonSize.width + CGFloat(items.count - 1) * style.spacing + padding
  }

  // MARK: Animation Helpers

  /// The scale ratio that grows the group's shared width by exactly
  /// `pressExpansion` points on each side, regardless of item count or style.
  private var pressedScaleX: CGFloat {
    (groupWidth + pressExpansion * 2) / groupWidth
  }

  /// The scale ratio that grows the group's shared height by exactly
  /// `pressExpansion` points on each side.
  private var pressedScaleY: CGFloat {
    (buttonSize.height + pressExpansion * 2) / buttonSize.height
  }

  /// Press-feedback opacity only. Disabled dimming lives in the icon's
  /// resolved color (see `resolvedIconColor` in `body`), so this doesn't
  /// take a disabled flag.
  private func resolvedPressOpacity(for index: Int) -> Double {
    viewModel.isButtonPressed(at: index)
      ? CustomButtonConfiguration.pressedIconOpacity
      : CustomButtonConfiguration.enabledOpacity
  }

  /// Scales the icon by the same point expansion a standalone press produces,
  /// expressed relative to the icon's size.
  ///
  /// NOTE: the `.circle` / `.square` multiplier split (1.0 / 1.4) predates the
  /// `groupWidth` unification above, when `.square` had no shared inner
  /// padding to compensate for. Now that both styles share identical padding,
  /// this split may want re-tuning visually — flagging rather than silently
  /// re-deriving it, since it's a look-and-feel call, not a correctness one.
  private var groupedIconScale: CGFloat {
    let iconSize = min(buttonSize.width, buttonSize.height) * CustomButtonConfiguration.iconSizeRatio
    let multiplier: CGFloat
    switch style {
    case .circle: multiplier = 1.0
    case .square: multiplier = 1.4
    }
    let expansion = buttonSize.height * (CustomButtonConfiguration.pressedIconScale - 1) * multiplier
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
    // Square group aligned with a standalone button at the same spacing.
    HStack(spacing: 8) {
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.undo, action: {})
        IconButtonItem(.redo, action: {})
      }
      IconButton(.trash, style: .square, action: {}).iconColor(.red)
    }
    // Circle and square groups with the same items/spacing now report the
    // same width — this is the fix this rewrite verifies visually.
    HStack(spacing: 8) {
      IconButtonGroup(style: .circle) {
        IconButtonItem(.undo, action: {})
        IconButtonItem(.redo, action: {})
      }
      IconButtonGroup(style: .square(spacing: CustomButtonConfiguration.groupSpacing)) {
        IconButtonItem(.undo, action: {})
        IconButtonItem(.redo, action: {})
      }
    }
    // Spacer slot — reserves a button's space without rendering one.
    IconButtonGroup(style: .square(spacing: 8)) {
      IconButtonItem(.back, action: {})
      IconButtonItem.spacer
      IconButtonItem.spacer
      IconButtonItem(.forward, action: {})
    }
  }
  .padding()
}

#Preview("Icon Button Group Disabled") {
  let defaultDisabledColors = IconButtonColors(
    foreground: Color(white: 0.2),
    background: Color(white: 0.9),
    foregroundDisabled: Color(white: 0.2).opacity(0.4),
    backgroundDisabled: Color(white: 0.9).opacity(0.4)
  )
  let defaultDisabledTheme = IconButtonTheme(colors: defaultDisabledColors)

  let customDisabledColors = IconButtonColors(
    foreground: .blue,
    background: .yellow,
    foregroundDisabled: .red,
    backgroundDisabled: .green
  )
  let customDisabled = IconButtonTheme(colors: customDisabledColors)

  return VStack(alignment: .leading, spacing: 50) {
    VStack(spacing: 8) {
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(defaultDisabledTheme)
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(defaultDisabledTheme)
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, isDisabled: true, action: {})
      }
      .theme(defaultDisabledTheme)
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.back, action: {})
        IconButtonItem(.cancel, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(defaultDisabledTheme)
      .disabled(true)
    }

    VStack(spacing: 8) {
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(customDisabled)
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, action: {})
      }
      .theme(customDisabled)
      IconButtonGroup(style: .square(spacing: 8)) {
        IconButtonItem(.back, isDisabled: true, action: {})
        IconButtonItem(.cancel, isDisabled: true, action: {})
        IconButtonItem(.forward, isDisabled: true, action: {})
      }
      .theme(customDisabled)
      IconButtonGroup(style: .square(spacing: 8)) {
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
