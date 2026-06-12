import Foundation

/// Identifies an SF Symbol icon.
///
/// `IconType` carries no sizing or color — those are rendering concerns supplied
/// at the call site via `Icon` or `IconView`.
public enum IconType: Hashable, Sendable, CaseIterable {

  // MARK: Navigation

  case back
  case cancel
  case done
  case forward
  case preview

  // MARK: Actions

  case add
  case clear
  case copy
  case copyReady
  case delete
  case edit
  case redo
  case remove
  case toggleOff
  case toggleOn
  case undo

  // MARK: Grid

  case dots
  case dotsDivisor
  case gridBorderOff
  case gridBorderOn
  case gridDivisorOff
  case gridDivisorOn
  case gridMinus
  case gridOff
  case gridOn
  case gridPlus
  case minus
  case plus

  // MARK: Direction

  case down
  case left
  case right
  case up

  // MARK: System Image

  /// The SF Symbol name for this icon.
  public var systemImage: String {
    switch self {

    // Navigation
    case .back:         return "chevron.backward"
    case .cancel:       return "xmark"
    case .done:         return "checkmark"
    case .forward:      return "chevron.forward"
    case .preview:      return "eye"

    // Actions
    case .add:          return "plus"
    case .clear:        return "square.slash"
    case .copy:         return "text.document"
    case .copyReady:    return "text.document.fill"
    case .delete:       return "xmark.square"
    case .edit:         return "pencil"
    case .redo:         return "arrow.uturn.forward"
    case .remove:       return "minus"
    case .toggleOff:    return "inset.filled.bottomthird.square"
    case .toggleOn:     return "inset.filled.topthird.square"
    case .undo:         return "arrow.uturn.backward"

    // Grid
    case .dots:             return "circle.grid.3x3.fill"
    case .dotsDivisor:      return "circle.grid.3x3"
    case .gridBorderOff:    return "squareshape"
    case .gridBorderOn:     return "squareshape.fill"
    case .gridDivisorOff:   return "squareshape.split.2x2"
    case .gridDivisorOn:    return "square.grid.2x2.fill"
    case .gridMinus:        return "chevron.left.square"
    case .gridOff:          return "squareshape.split.3x3"
    case .gridOn:           return "square.grid.3x3.fill"
    case .gridPlus:         return "chevron.right.square"
    case .minus:            return "minus"
    case .plus:             return "plus"

    // Direction
    case .down:     return "arrow.down"
    case .left:     return "arrow.left"
    case .right:    return "arrow.right"
    case .up:       return "arrow.up"
    }
  }

  // MARK: Accessibility Label

  /// The VoiceOver label for this icon.
  public var accessibilityLabel: String {
    switch self {

    // Navigation
    case .back:         return "Back"
    case .cancel:       return "Cancel"
    case .done:         return "Done"
    case .forward:      return "Forward"
    case .preview:      return "Preview"

    // Actions
    case .add:          return "Add"
    case .clear:        return "Clear"
    case .copy:         return "Copy"
    case .copyReady:    return "Copied"
    case .delete:       return "Delete"
    case .edit:         return "Edit"
    case .redo:         return "Redo"
    case .remove:       return "Remove"
    case .toggleOff:    return "Toggle Off"
    case .toggleOn:     return "Toggle On"
    case .undo:         return "Undo"

    // Grid
    case .dots:             return "All Dots"
    case .dotsDivisor:      return "Divisor Dots"
    case .gridBorderOff:    return "Border Off"
    case .gridBorderOn:     return "Border On"
    case .gridDivisorOff:   return "Divisor Off"
    case .gridDivisorOn:    return "Divisor On"
    case .gridMinus:        return "Divisor Down"
    case .gridOff:          return "Grids Off"
    case .gridOn:           return "Grids On"
    case .gridPlus:         return "Divisor Up"
    case .minus:            return "Down"
    case .plus:             return "Up"

    // Direction
    case .down:     return "Down"
    case .left:     return "Left"
    case .right:    return "Right"
    case .up:       return "Up"
    }
  }

  // MARK: Preview Groups

  #if DEBUG
  /// Icons grouped by category, for SwiftUI previews.
  ///
  /// Debug-only scaffolding — for runtime iteration over every icon, use
  /// `IconType.allCases`.
  public static let previewGroups: [(label: String, icons: [IconType])] = [
    ("Navigation", [.back, .forward, .cancel, .done, .preview]),
    ("Actions", [.add, .remove, .edit, .copy, .copyReady, .delete, .clear, .undo, .redo]),
    ("Toggle", [.toggleOn, .toggleOff]),
    ("Grid", [.gridOn, .gridOff, .gridBorderOn, .gridBorderOff, .gridDivisorOn, .gridDivisorOff, .gridPlus, .gridMinus, .dots, .dotsDivisor, .plus, .minus]),
    ("Direction", [.up, .down, .left, .right])
  ]
  #endif
}
