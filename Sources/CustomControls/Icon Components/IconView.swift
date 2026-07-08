import SwiftUI

// MARK: Icon

/// A lightweight value identifying a symbol and its colors, ready to render.
///
/// `Icon` is the *resolved* form of an `IconRepresentable`: it carries the
/// symbol name and accessibility label as plain values plus the colors to draw
/// them in, so it can be stored in a model or handed between views without any
/// generic baggage. For rendering, use `IconView`.
///
/// ```swift
/// Icon(IconType.undo, color: .primary)
/// Icon(IconType.delete, color: .red)
/// Icon(IconType.trash, color: .red)
/// Icon(EmptyIcon(), color: .primary)      // renders nothing
/// ```
public struct Icon: Hashable, Sendable {

  // MARK: Properties

  /// The SF Symbol name, or `nil` to render nothing.
  public let symbolName: String?

  /// The VoiceOver label for this symbol.
  public let accessibilityLabel: String

  /// The primary icon color.
  public let color: Color

  /// Optional secondary color for two-tone SF Symbols.
  public let accentColor: Color?

  /// Whether this icon renders nothing.
  public var isEmpty: Bool { symbolName == nil }

  // MARK: Initialization

  /// Creates an icon from any symbol identity.
  ///
  /// - Parameters:
  ///   - symbol: The symbol identity (e.g. an `IconType` or a custom conformer).
  ///   - color: The primary icon color.
  ///   - accentColor: Optional secondary color for two-tone SF Symbols.
  public init(_ symbol: some IconRepresentable, color: Color, accentColor: Color? = nil) {
    self.symbolName = symbol.symbolName
    self.accessibilityLabel = symbol.accessibilityLabel
    self.color = color
    self.accentColor = accentColor
  }

  /// Builds an icon directly from resolved fields. Internal plumbing for the
  /// button views, which resolve colors against the theme before rendering.
  init(symbolName: String?, accessibilityLabel: String, color: Color, accentColor: Color?) {
    self.symbolName = symbolName
    self.accessibilityLabel = accessibilityLabel
    self.color = color
    self.accentColor = accentColor
  }
}

// MARK: Icon View

/// Renders an `Icon` at a given size and weight.
///
/// Purely visual — no frame background, no tap handling. An empty icon
/// (`symbolName == nil`) renders a transparent box of the icon's size and is
/// hidden from accessibility. Use `IconButton` when interaction is needed.
///
/// ```swift
/// IconView(Icon(IconType.undo, color: .primary), size: 24)
/// IconView(Icon(IconType.delete, color: .red), size: 20, weight: .bold)
/// ```
public struct IconView: View {

  // MARK: Properties

  private let icon: Icon
  private let size: CGFloat
  private let weight: Font.Weight

  // MARK: Initialization

  /// Creates an icon view.
  ///
  /// - Parameters:
  ///   - icon: The icon data to render.
  ///   - size: The font size for the icon.
  ///   - weight: The font weight. Defaults to `CustomButtonConfiguration.iconWeight`.
  public init(_ icon: Icon, size: CGFloat, weight: Font.Weight = CustomButtonConfiguration.iconWeight) {
    self.icon = icon
    self.size = size
    self.weight = weight
  }

  // MARK: Body

  public var body: some View {
    if let symbolName = icon.symbolName {
      Image(systemName: symbolName)
        .font(.system(size: size, weight: weight))
        .symbolRenderingMode(CustomButtonConfiguration.symbolRenderingMode)
        .foregroundStyle(icon.color, icon.accentColor ?? icon.color)
    }
    else {
      Color.clear
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
  }
}

// MARK: Preview

#if DEBUG
#Preview("Icon Catalog") {
  ScrollView {
    VStack(alignment: .leading, spacing: 20) {
      ForEach(IconType.previewGroups, id: \.label) { group in
        VStack(alignment: .leading, spacing: 8) {
          Text(group.label)
            .font(.headline)
          LazyVGrid(columns: Array(repeating: GridItem(.fixed(44)), count: 6), spacing: 12) {
            ForEach(group.icons, id: \.self) { icon in
              IconView(Icon(icon, color: .primary), size: 20)
                .frame(width: 44, height: 44)
                .background(Color.primary.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
          }
        }
      }
    }
    .padding()
  }
}

#Preview("Empty Symbol") {
  HStack(spacing: 16) {
    IconView(Icon(IconType.done, color: .primary), size: 20)
      .frame(width: 44, height: 44)
      .background(Color.primary.opacity(0.08))
      .clipShape(RoundedRectangle(cornerRadius: 10))
    IconView(Icon(EmptyIcon(), color: .primary), size: 20)
      .frame(width: 44, height: 44)
      .background(Color.primary.opacity(0.08))
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
  .padding()
}
#endif
