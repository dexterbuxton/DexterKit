import SwiftUI

// MARK: Icon Button Item Builder

/// Result builder for constructing `IconButtonItem` arrays declaratively.
@resultBuilder
public struct IconButtonItemBuilder {

  public static func buildExpression(_ expression: IconButtonItem) -> [IconButtonItem] {
    [expression]
  }

  public static func buildBlock(_ components: [IconButtonItem]...) -> [IconButtonItem] {
    components.flatMap { $0 }
  }

  public static func buildOptional(_ component: [IconButtonItem]?) -> [IconButtonItem] {
    component ?? []
  }

  public static func buildEither(first component: [IconButtonItem]) -> [IconButtonItem] {
    component
  }

  public static func buildEither(second component: [IconButtonItem]) -> [IconButtonItem] {
    component
  }

  public static func buildArray(_ components: [[IconButtonItem]]) -> [IconButtonItem] {
    components.flatMap { $0 }
  }
}

// MARK: Icon Button Item

/// A single slot in an `IconButtonGroup`.
///
/// Use a symbol initializer to inherit the group's icon color, or pass a full
/// `Icon` to override the color for this slot only.
///
/// ```swift
/// IconButtonItem(.undo, action: {})                       // group color
/// IconButtonItem(Icon(.delete, color: .red), action: {})  // custom color
/// IconButtonItem(EmptyIcon(), action: {})                 // tappable, draws nothing
/// ```
///
/// `EmptyIcon` differs from `.spacer`: a spacer reserves space and is inert,
/// while an empty symbol is a live, tappable slot that simply renders no symbol.
public struct IconButtonItem {

  // MARK: Properties

  let symbolName: String?
  let accessibilityLabel: String
  let accentColor: Color?
  let colorOverride: Color?
  let isDisabled: Bool
  let isEmpty: Bool
  let action: () -> Void

  // MARK: Initialization

  /// An inert slot that reserves a button's worth of space but renders nothing.
  /// Keeps surrounding buttons' widths and alignment unchanged.
  public static var spacer: IconButtonItem { IconButtonItem() }

  /// Creates an inert spacer slot.
  public init() {
    self.symbolName = nil
    self.accessibilityLabel = ""
    self.accentColor = nil
    self.colorOverride = nil
    self.isDisabled = true
    self.isEmpty = true
    self.action = {}
  }

  /// Creates a slot with a pre-coloured `Icon`, using its own color.
  public init(_ icon: Icon, isDisabled: Bool = false, action: @escaping () -> Void) {
    self.symbolName = icon.symbolName
    self.accessibilityLabel = icon.accessibilityLabel
    self.accentColor = icon.accentColor
    self.colorOverride = icon.color
    self.isDisabled = isDisabled
    self.isEmpty = false
    self.action = action
  }

  /// Creates a slot from a built-in `IconType`, using the group's default color.
  /// Concrete overload so leading-dot cases (`.minus`, `.add`) keep resolving.
  public init(
    _ type: IconType,
    accentColor: Color? = nil,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.init(symbol: type, accentColor: accentColor, isDisabled: isDisabled, action: action)
  }

  /// Creates a slot from any symbol identity, using the group's default color.
  public init(
    _ symbol: some IconRepresentable,
    accentColor: Color? = nil,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.init(symbol: symbol, accentColor: accentColor, isDisabled: isDisabled, action: action)
  }

  /// Shared designated symbol initializer.
  private init(
    symbol: some IconRepresentable,
    accentColor: Color?,
    isDisabled: Bool,
    action: @escaping () -> Void
  ) {
    self.symbolName = symbol.symbolName
    self.accessibilityLabel = symbol.accessibilityLabel
    self.accentColor = accentColor
    self.colorOverride = nil
    self.isDisabled = isDisabled
    self.isEmpty = false
    self.action = action
  }

  // MARK: Computed Helpers

  /// Resolves the icon for rendering, falling back to the group's default color
  /// when the slot carries no color of its own.
  func resolvedIcon(defaultColor: Color) -> Icon {
    Icon(
      symbolName: symbolName,
      accessibilityLabel: accessibilityLabel,
      color: colorOverride ?? defaultColor,
      accentColor: accentColor
    )
  }
}
