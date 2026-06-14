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
/// Use the convenience initializer to inherit the group's icon color, or pass a
/// full `Icon` to override the color for this slot only.
///
/// ```swift
/// IconButtonItem(.undo, action: {})                          // group color
/// IconButtonItem(Icon(.delete, color: .red), action: {})     // custom color
/// ```
public struct IconButtonItem {

  // MARK: Properties

  let icon: Icon?
  let type: IconType?
  let accentColor: Color?
  let isDisabled: Bool
  let isEmpty: Bool
  let action: () -> Void

  // MARK: Initialization

  /// An empty slot that reserves a button's worth of space but renders nothing.
  ///
  /// Keeps the surrounding buttons' widths and alignment unchanged — the spacer
  /// still counts as a slot, so the group's layout is identical to a full row.
  public static var spacer: IconButtonItem { IconButtonItem() }

  /// Creates an empty spacer slot.
  public init() {
    self.icon = nil
    self.type = nil
    self.accentColor = nil
    self.isDisabled = true
    self.isEmpty = true
    self.action = {}
  }

  /// Creates a slot with an explicit `Icon`, using its own color.
  public init(_ icon: Icon, isDisabled: Bool = false, action: @escaping () -> Void) {
    self.icon = icon
    self.type = nil
    self.accentColor = nil
    self.isDisabled = isDisabled
    self.isEmpty = false
    self.action = action
  }

  /// Creates a slot using the group's default icon color.
  public init(_ type: IconType, accentColor: Color? = nil, isDisabled: Bool = false, action: @escaping () -> Void) {
    self.icon = nil
    self.type = type
    self.accentColor = accentColor
    self.isDisabled = isDisabled
    self.isEmpty = false
    self.action = action
  }

  // MARK: Computed Helpers

  /// Resolves the icon for rendering, using the group's default color as fallback.
  func resolvedIcon(defaultColor: Color) -> Icon {
    if let icon {
      return icon
    }
    guard let type else {
      return Icon(.add, color: defaultColor, accentColor: accentColor)
    }
    return Icon(type, color: defaultColor, accentColor: accentColor)
  }
}
