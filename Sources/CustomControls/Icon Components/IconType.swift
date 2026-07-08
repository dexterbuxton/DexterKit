import Foundation

/// Identifies an SF Symbol icon.
///
/// `IconType` carries no sizing or color — those are rendering concerns supplied
/// at the call site via `Icon` or `IconView`.
public enum IconType: Hashable, Sendable, CaseIterable {

  // MARK: Navigation

  case back
  case forward
  case cancel
  case done

  // MARK: Actions

  case plus
  case minus
  case copy
  case copyReady
  case undo
  case redo
  case trash
  case toggleOn
  case toggleOff

  // MARK: Direction

  case up
  case down
  case left
  case right

  // MARK: System Image

  /// The SF Symbol name for this icon.
  public var systemImage: String {
    switch self {

    // Navigation
    case .back:         return "chevron.backward"
    case .forward:      return "chevron.forward"
    case .cancel:       return "xmark"
    case .done:         return "checkmark"

    // Actions
    case .plus:         return "plus"
    case .minus:        return "minus"
    case .copy:         return "text.document"
    case .copyReady:    return "text.document.fill"
    case .undo:         return "arrow.uturn.backward"
    case .redo:         return "arrow.uturn.forward"
    case .trash:        return "trash"
    case .toggleOn:     return "inset.filled.topthird.square"
    case .toggleOff:    return "inset.filled.bottomthird.square"

    // Direction
    case .up:       return "arrow.up"
    case .down:     return "arrow.down"
    case .left:     return "arrow.left"
    case .right:    return "arrow.right"
    }
  }

  // MARK: Accessibility Label

  /// The VoiceOver label for this icon.
  public var accessibilityLabel: String {
    switch self {

    // Navigation
    case .back:         return "Back"
    case .forward:      return "Forward"
    case .cancel:       return "Cancel"
    case .done:         return "Done"

    // Actions
    case .plus:         return "Plus"
    case .minus:        return "Minus"
    case .copy:         return "Copy"
    case .copyReady:    return "Copy Ready"
    case .undo:         return "Undo"
    case .redo:         return "Redo"
    case .trash:        return "Trash"
    case .toggleOn:     return "Toggle On"
    case .toggleOff:    return "Toggle Off"

    // Direction
    case .up:       return "Up"
    case .down:     return "Down"
    case .left:     return "Left"
    case .right:    return "Right"
    }
  }

  // MARK: Preview Groups

  #if DEBUG
  /// Icons grouped by category, for SwiftUI previews.
  ///
  /// Debug-only scaffolding — for runtime iteration over every icon, use
  /// `IconType.allCases`.
  public static let previewGroups: [(label: String, icons: [IconType])] = [
    ("Navigation", [.back, .forward, .cancel, .done]),
    ("Actions", [.plus, .minus, .copy, .copyReady]),
    ("Undo/Redo", [.undo, .redo, .trash]),
    ("Toggle", [.toggleOn, .toggleOff]),
    ("Direction", [.up, .down, .left, .right])
  ]
  #endif
}
