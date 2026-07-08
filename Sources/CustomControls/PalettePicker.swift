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
/// Two selection modes are supported:
///
/// - **Single** — `selection: Binding<Palette.Element.ID?>`. Tapping a swatch
///   replaces the selection.
/// - **Multiple (capacity-bound)** — `selection: Binding<[Palette.Element.ID]>`,
///   `capacity:`. The selection always holds exactly `capacity` entries once
///   seeded — there's no bare deselect. Tapping any swatch (selected or not)
///   moves it to the front of the list; if that pushes the count past
///   `capacity`, the oldest entry (the back of the list) is dropped. So a tap
///   on a new color adds and evicts in one step, and re-tapping an
///   already-selected color just protects it from being the next one evicted.
///
/// ```swift
/// PalettePicker(palette: .material, selection: $selectedID)
/// PalettePicker(palette: .material, style: .circle, selection: $selectedID)
/// PalettePicker(palette: .material, selection: $selectedIDs, capacity: 2)
/// ```
public struct PalettePicker: View {

  // MARK: Types

  private enum SelectionMode {
    case single(Binding<Palette.Element.ID?>)
    case multiple(Binding<[Palette.Element.ID]>, capacity: Int)
  }

  // MARK: Properties

  private let palette: Palette
  private let columns: Int
  private let style: CustomButtonStyle
  private let mode: SelectionMode

  @Environment(\.colorScheme) private var colorScheme

  private let spacing: CGFloat = 8

  // MARK: Initialization

  /// Creates a single-selection picker.
  public init(
    palette: Palette,
    columns: Int = 8,
    style: CustomButtonStyle = .square,
    selection: Binding<Palette.Element.ID?>
  ) {
    self.palette = palette
    self.columns = max(1, columns)
    self.style = style
    self.mode = .single(selection)
  }

  /// Creates a capacity-bound multi-selection picker.
  ///
  /// The selection is never empty and never exceeds `capacity` once seeded —
  /// there is no bare deselect. Tapping any swatch moves it to the front of
  /// the selection; entries beyond `capacity` are dropped from the back.
  ///
  /// - Parameters:
  ///   - capacity: The fixed number of colors the selection holds (e.g. `1`
  ///     for a single required color, `2` for a two-stop gradient).
  public init(
    palette: Palette,
    columns: Int = 8,
    style: CustomButtonStyle = .square,
    selection: Binding<[Palette.Element.ID]>,
    capacity: Int
  ) {
    self.palette = palette
    self.columns = max(1, columns)
    self.style = style
    self.mode = .multiple(selection, capacity: max(1, capacity))
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

  // MARK: Selection Helpers

  private func isSelected(_ id: Palette.Element.ID) -> Bool {
    switch mode {
    case .single(let selection):
      return selection.wrappedValue == id
    case .multiple(let selection, _):
      return selection.wrappedValue.contains(id)
    }
  }

  /// Handles a tap on any swatch, dispatching by selection mode.
  ///
  /// In multiple mode, the tapped id always moves to the front of the list
  /// (deduping first so re-tapping an existing selection just reorders it),
  /// then anything beyond `capacity` is trimmed from the back.
  private func select(_ id: Palette.Element.ID) {
    switch mode {
    case .single(let selection):
      selection.wrappedValue = id
    case .multiple(let selection, let capacity):
      var ids = selection.wrappedValue
      ids.removeAll { $0 == id }
      ids.insert(id, at: 0)
      if ids.count > capacity {
        ids.removeLast(ids.count - capacity)
      }
      selection.wrappedValue = ids
    }
  }

  // MARK: Swatch

  @ViewBuilder
  private func swatch(for entry: Palette.Element) -> some View {
    let selected = isSelected(entry.id)
    // Use whichever variant is actually showing so the dot stays legible in dark mode.
    let shownHex = (colorScheme == .dark ? entry.dark?.hexValue : nil) ?? entry.hexValue

    Button {
      select(entry.id)
    } label: {
      swatchShape
        .fill(entry.color)
        .aspectRatio(1, contentMode: .fit)
        .overlay {
          if selected {
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
    .accessibilityAddTraits(selected ? [.isSelected] : [])
  }

  private var swatchShape: AnyShape {
    switch style {
    case .circle:
      AnyShape(Circle())
    case .square:
      AnyShape(RoundedRectangle(cornerRadius: CustomButtonConfiguration.squareCornerRadius))
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

#Preview("2 Selections") {
  struct PreviewWrapper: View {
    @State private var selection: [Palette.Element.ID] = Array(
      Palette.material.entries.prefix(2).map(\.id)
    )

    var body: some View {
      VStack(spacing: 24) {
        PalettePicker(palette: .material, selection: $selection, capacity: 2)
        PalettePicker(palette: .material, style: .circle, selection: $selection, capacity: 2)
      }
      .padding()
    }
  }

  return PreviewWrapper()
}
