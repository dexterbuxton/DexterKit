import SwiftUI

// MARK: Icon

/// A lightweight value identifying an icon and its colors.
///
/// Use `Icon` to pass icon data around independently — storing it in a model or
/// handing it between views. For rendering, use `IconView`.
///
/// ```swift
/// Icon(.undo, color: .primary)
/// Icon(.delete, color: .red)
/// Icon(.gridOn, color: .primary, accentColor: .blue)
/// ```
public struct Icon: Hashable, Sendable {

  // MARK: Properties

  public let type: IconType
  public let color: Color
  public let accentColor: Color?

  // MARK: Initialization

  /// Creates an icon value.
  ///
  /// - Parameters:
  ///   - type: The icon type to display.
  ///   - color: The primary icon color.
  ///   - accentColor: Optional secondary color for two-tone SF Symbols.
  public init(_ type: IconType, color: Color, accentColor: Color? = nil) {
    self.type = type
    self.color = color
    self.accentColor = accentColor
  }
}

// MARK: Icon View

/// Renders an `Icon` at a given size and weight.
///
/// Purely visual — no frame, no background, no tap handling. Use `IconButton`
/// when interaction is needed.
///
/// ```swift
/// IconView(Icon(.undo, color: .primary), size: 24)
/// IconView(Icon(.delete, color: .red), size: 20, weight: .bold)
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
    Image(systemName: icon.type.systemImage)
      .font(.system(size: size, weight: weight))
      .symbolRenderingMode(CustomButtonConfiguration.symbolRenderingMode)
      .foregroundStyle(icon.color, icon.accentColor ?? icon.color)
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

#Preview("Accent Color") {
  // Accent color is the secondary palette layer, so it only shows on multi-layer
  // SF Symbols; single-layer symbols render in the primary color alone.
  let layered: [IconType] = [.toggleOn, .toggleOff, .copyReady, .gridOn, .gridDivisorOn, .dots]

  return VStack(spacing: 16) {
    HStack(spacing: 16) {
      ForEach(layered, id: \.self) { icon in
        IconView(Icon(icon, color: .primary, accentColor: .blue), size: 28)
          .frame(width: 44, height: 44)
          .background(Color.primary.opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    Text("Accent (blue) appears on multi-layer symbols")
      .font(.caption)
      .foregroundStyle(.secondary)
  }
  .padding()
}
#endif
