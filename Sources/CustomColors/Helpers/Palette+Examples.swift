import Foundation

public extension Palette {

  /// A Material-style base palette: 16 named swatches for a 2×8 grid.
  ///
  /// The first entry, "Neutral", is the only adaptive one — off-black in light
  /// mode, off-white in dark mode (Material Grey 900 / Grey 50). The remaining 15
  /// are single colors. (Gray is omitted so "Neutral" fills the grayscale slot and
  /// the set stays at 16.)
  static let material = Palette(
    name: "Material",
    entries: [
      Element(name: "Neutral", hex: .offBlack, dark: .offWhite),
      Element(name: "Red", hex: Hex("F44336")),
      Element(name: "Pink", hex: Hex("E91E63")),
      Element(name: "Purple", hex: Hex("9C27B0")),
      Element(name: "Deep Purple", hex: Hex("673AB7")),
      Element(name: "Indigo", hex: Hex("3F51B5")),
      Element(name: "Blue", hex: Hex("2196F3")),
      Element(name: "Cyan", hex: Hex("00BCD4")),
      Element(name: "Teal", hex: Hex("009688")),
      Element(name: "Green", hex: Hex("4CAF50")),
      Element(name: "Light Green", hex: Hex("8BC34A")),
      Element(name: "Lime", hex: Hex("CDDC39")),
      Element(name: "Yellow", hex: Hex("FFEB3B")),
      Element(name: "Amber", hex: Hex("FFC107")),
      Element(name: "Orange", hex: Hex("FF9800")),
      Element(name: "Deep Orange", hex: Hex("FF5722"))
    ]
  )

  /// A palette assembled from `RGB.colors` — demonstrates unnamed entries.
  ///
  /// `RGB.colors` is a bare list of values with no labels, so these entries have
  /// `name == nil`. Add names here if you want them shown in a picker.
  static let standard = Palette(
    name: "Standard",
    entries: RGB.colors.map { Element(rgb: $0) }
  )
}
