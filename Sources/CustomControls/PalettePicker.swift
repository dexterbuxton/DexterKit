import SwiftUI
import CustomColors

/// A simple grid color picker over a `Palette`.
///
/// Square swatches in a fixed number of columns that fill the available width.
/// Each column is an equal fraction of the width and each swatch is square, so
/// the grid's height follows from the column count, the number of rows, and the
/// spacing — no width measurement required. 16 colors over 8 columns gives the
/// classic 2×8 layout. Swatches are rounded squares or circles via `style`.
///
/// ```swift
/// PalettePicker(palette: .material, selection: $selectedID)
/// PalettePicker(palette: .material, style: .circle, selection: $selectedID)
/// ```
public struct PalettePicker: View {

  // MARK: Properties

  private let palette: Palette
  private let columns: Int
  private let style: CustomButtonStyle
  @Binding private var selection: Palette.Element.ID?

  @Environment(\.colorScheme) private var colorScheme

  private let spacing: CGFloat = 8

  // MARK: Initialization

  public init(
    palette: Palette,
    columns: Int = 8,
    style: CustomButtonStyle = .rectangle,
    selection: Binding<Palette.Element.ID?>
  ) {
    self.palette = palette
    self.columns = max(1, columns)
    self.style = style
    self._selection = selection
  }

  // MARK: Body

  public var body: some View {
    LazyVGrid(columns: gridColumns, spacing: spacing) {
      ForEach(palette.entries) { entry in
        swatch(for: entry)
      }
    }
  }

  private var gridColumns: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
  }

  // MARK: Swatch

  @ViewBuilder
  private func swatch(for entry: Palette.Element) -> some View {
    let isSelected = selection == entry.id
    // Use whichever variant is actually showing so the dot stays legible in dark mode.
    let shownHex = (colorScheme == .dark ? entry.dark?.hexValue : nil) ?? entry.hexValue

    Button {
      selection = entry.id
    } label: {
      swatchShape
        .fill(entry.color)
        .aspectRatio(1, contentMode: .fit)
        .overlay {
          if isSelected {
            // A centered dot at 30% of the swatch — no size measurement needed.
            // Uses the opposite off-neutral so it stays soft, not harsh black/white.
            Circle()
              .fill(shownHex.isLight ? Hex.offBlack.color : Hex.offWhite.color)
              .scaleEffect(CustomButtonConfiguration.indicatorDotRatio)
          }
        }
        .contentShape(Rectangle())
    }
    .buttonStyle(CustomButtonPressStyle())
    .accessibilityLabel(entry.name ?? entry.hexValue.description)
    .accessibilityAddTraits(isSelected ? [.isSelected] : [])
  }

  private var swatchShape: AnyShape {
    switch style {
    case .circle:
      AnyShape(Circle())
    case .rectangle:
      AnyShape(RoundedRectangle(cornerRadius: CustomButtonConfiguration.roundedRectangleCornerRadius))
    }
  }
}

// MARK: Preview

#Preview("Palette Picker") {
  struct PreviewWrapper: View {
    @State private var selection: Palette.Element.ID?

    var body: some View {
      VStack(spacing: 24) {
        PalettePicker(palette: .material, selection: $selection)
        PalettePicker(palette: .material, style: .circle, selection: $selection)
      }
      .padding()
    }
  }

  return PreviewWrapper()
}
