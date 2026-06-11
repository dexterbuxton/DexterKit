import SwiftUI
import CustomColors
import Extensions

/// A grid color picker over a `Palette`.
///
/// Lays out a fixed number of columns with flexible rows. The final (partial)
/// row adapts to the sizing automatically:
/// - **Fixed width** — swatches can't grow, so a short last row is centered.
/// - **Fill width + fixed height** — the short last row stretches its swatches
///   wider (same height) to fill the width.
/// - **Fill width + square** — swatches stay uniform, so a short last row centers.
///
/// Each swatch is an `AppIndicatorButton`, so selection shows the app's dot
/// indicator and tapping uses the standard press animation. Selection is keyed
/// on `Palette.Element.ID`, so it survives reordering and duplicate colors.
///
/// ```swift
/// PalettePicker(palette: .material, selection: $id)
/// PalettePicker(palette: .material, width: .fill, height: .fixed(28), selection: $id)
/// ```
public struct PalettePicker: View {

  // MARK: Configuration

  /// How wide each swatch is.
  public enum Width: Equatable, Sendable {
    /// Each swatch is exactly this many points wide; the picker is content-width.
    case fixed(CGFloat)
    /// Swatches divide the available width equally; the picker fills its container.
    case fill
  }

  /// How tall each swatch is.
  public enum Height: Equatable, Sendable {
    /// Height follows width — square swatches (default).
    case matchWidth
    /// An explicit height, independent of width.
    case fixed(CGFloat)
  }

  // MARK: Properties

  private let palette: Palette
  private let columns: Int
  private let width: Width
  private let height: Height
  private let style: CustomButtonStyle
  @Binding private var selection: Palette.Element.ID?

  /// The width the picker has been given, measured in `.fill` mode.
  @State private var availableWidth: CGFloat = 0

  private let spacing: CGFloat = 8

  // MARK: Initialization

  public init(
    palette: Palette,
    columns: Int = 8,
    width: Width = .fixed(44),
    height: Height = .matchWidth,
    style: CustomButtonStyle = .rectangle,
    selection: Binding<Palette.Element.ID?>
  ) {
    self.palette = palette
    self.columns = max(1, columns)
    self.width = width
    self.height = height
    self.style = style
    self._selection = selection
  }

  // MARK: Body

  public var body: some View {
    switch width {
    case .fixed(let swatchWidth):
      // Content-width: the picker is exactly as wide as a full row.
      grid(fullRowWidth: swatchWidth)
    case .fill:
      // Fill-width: claim the full container, measure it, size swatches from it.
      grid(fullRowWidth: fillSwatchWidth)
        .frame(maxWidth: .infinity, alignment: .center)
        .onGeometryChange(for: CGFloat.self) { proxy in
          proxy.size.width
        } action: { measuredWidth in
          availableWidth = measuredWidth
        }
    }
  }

  // MARK: Layout

  @ViewBuilder
  private func grid(fullRowWidth: CGFloat) -> some View {
    let rows = palette.entries.chunked(into: columns)
    let lastIndex = rows.count - 1

    VStack(alignment: .center, spacing: spacing) {
      ForEach(rows.indices, id: \.self) { rowIndex in
        let entries = rows[rowIndex]
        let swatchWidth = width(forRow: entries.count, isLast: rowIndex == lastIndex, fullRowWidth: fullRowWidth)
        let swatchHeight = resolvedHeight(forWidth: swatchWidth)

        HStack(spacing: spacing) {
          ForEach(entries) { entry in
            swatch(for: entry, width: swatchWidth, height: swatchHeight)
          }
        }
      }
    }
  }

  /// The swatch width for a given row — stretched only for a partial final row
  /// when the width is free to flex and the height is pinned.
  private func width(forRow rowCount: Int, isLast: Bool, fullRowWidth: CGFloat) -> CGFloat {
    guard isLast, stretchesLastRow, rowCount > 0, rowCount < columns else {
      return fullRowWidth
    }
    let totalSpacing = spacing * CGFloat(rowCount - 1)
    return max(0, (availableWidth - totalSpacing) / CGFloat(rowCount))
  }

  /// True when a short last row should stretch to fill the width rather than center.
  private var stretchesLastRow: Bool {
    if case .fill = width, case .fixed = height {
      return true
    }
    return false
  }

  /// In `.fill` mode, the equal width each full-row swatch gets from the container.
  private var fillSwatchWidth: CGFloat {
    let totalSpacing = spacing * CGFloat(columns - 1)
    return max(0, (availableWidth - totalSpacing) / CGFloat(columns))
  }

  private func resolvedHeight(forWidth swatchWidth: CGFloat) -> CGFloat {
    switch height {
    case .matchWidth: swatchWidth
    case .fixed(let value): value
    }
  }

  // MARK: Swatch

  @ViewBuilder
  private func swatch(for entry: Palette.Element, width: CGFloat, height: CGFloat) -> some View {
    CustomIndicatorButton(
      isOn: Binding(
        get: { selection == entry.id },
        set: { _ in selection = entry.id }
      ),
      style: style,
      width: width,
      height: height,
      color: entry.color,
      dotColor: entry.hexValue.isLight ? .black : .white
    )
    .accessibilityLabel(entry.name ?? entry.hexValue.description)
    .accessibilityAddTraits(selection == entry.id ? [.isSelected] : [])
  }
}

// MARK: Preview

#Preview("Palette Picker") {
  struct PreviewWrapper: View {
    @State private var selection: Palette.Element.ID?

    var body: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 28) {
          // 16 colors over 6 columns → 6 / 6 / 4, so every variant shows a partial last row.

          labeled("Fixed width · square — centered last row") {
            PalettePicker(palette: .material, columns: 6, selection: $selection)
          }

          labeled("Fixed width · fixed height — centered last row") {
            PalettePicker(palette: .material, columns: 6, height: .fixed(28), selection: $selection)
          }

          labeled("Fill width · square — centered last row") {
            PalettePicker(palette: .material, columns: 6, width: .fill, selection: $selection)
          }

          labeled("Fill width · fixed height — stretched last row") {
            PalettePicker(palette: .material, columns: 6, width: .fill, height: .fixed(28), selection: $selection)
          }

          labeled("Circle style") {
            PalettePicker(palette: .material, columns: 6, style: .circle, selection: $selection)
          }
        }
        .padding()
      }
    }

    @ViewBuilder
    private func labeled<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .font(.caption)
          .foregroundStyle(.secondary)
        content()
      }
    }
  }

  return PreviewWrapper()
}
