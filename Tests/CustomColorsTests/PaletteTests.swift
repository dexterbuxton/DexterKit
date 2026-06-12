import Testing
@testable import CustomColors

struct PaletteTests {

  // MARK: Element

  @Test func testElementConversions() throws {
    let named = Palette.Element(name: "Red", hex: Hex("F44336"))
    #expect(named.name == "Red")
    #expect(named.hexValue.code == "F44336")
    #expect(named.rgbValue.r == 244)

    let unnamed = Palette.Element(rgb: RGB(r: 0, g: 255, b: 0))
    #expect(unnamed.name == nil)
    #expect(unnamed.hexValue.code == "00FF00")
    #expect(unnamed.hsbValue.h == 120)
  }

  @Test func testDescriptionPrefersName() throws {
    #expect(Palette.Element(name: "Lime", hex: Hex("CDDC39")).description == "Lime")
    #expect(Palette.Element(hex: Hex("CDDC39")).description == "#CDDC39")
  }

  // MARK: Collection

  @Test func testAddAcrossRepresentations() throws {
    var palette = Palette(name: "Test")
    #expect(palette.isEmpty)
    palette.add(Hex("F44336"), name: "Red")
    palette.add(RGB(r: 0, g: 255, b: 0))
    palette.add(HSB(h: 240, s: 100, b: 100), name: "Blue")
    #expect(palette.count == 3)
    #expect(palette.entries.first?.name == "Red")
    #expect(palette.entries[1].name == nil)
  }

  @Test func testInsertClamps() throws {
    var palette = Palette(entries: [
      Palette.Element(hex: Hex("000000")),
      Palette.Element(hex: Hex("FFFFFF"))
    ])
    palette.insert(Palette.Element(name: "Red", hex: Hex("F44336")), at: 99)
    #expect(palette.entries.last?.name == "Red")
    palette.insert(Palette.Element(name: "Blue", hex: Hex("0000FF")), at: -5)
    #expect(palette.entries.first?.name == "Blue")
    #expect(palette.count == 4)
  }

  @Test func testRemove() throws {
    let red = Palette.Element(name: "Red", hex: Hex("F44336"))
    var palette = Palette(entries: [red, Palette.Element(hex: Hex("00FF00"))])
    #expect(palette.remove(id: red.id)?.name == "Red")
    #expect(palette.count == 1)
    #expect(palette.remove(at: 5) == nil)
    #expect(palette.remove(at: 0)?.hexValue.code == "00FF00")
    #expect(palette.isEmpty)
  }

  @Test func testReversed() throws {
    let palette = Palette(name: "Mine", entries: [
      Palette.Element(name: "A", hex: Hex("000000")),
      Palette.Element(name: "B", hex: Hex("FFFFFF"))
    ])
    let flipped = palette.reversed()
    #expect(flipped.name == "Mine")
    #expect(flipped.entries.first?.name == "B")
    #expect(flipped.entries.last?.name == "A")
  }

  // MARK: Examples

  @Test func testMaterialExample() throws {
    #expect(Palette.material.name == "Material")
    #expect(Palette.material.count == 16)
    #expect(Palette.material.entries.allSatisfy { $0.name != nil })
    #expect(Palette.material.entries.first?.name == "Neutral")
    #expect(Palette.material.entries.first?.hexValue.code == "212121")
    #expect(Palette.material.entries.first?.dark?.hexValue.code == "FAFAFA")
  }

  @Test func testLightDarkVariant() throws {
    let adaptive = Palette.Element(name: "Background", hex: Hex("FFFFFF"), dark: Hex("000000"))
    #expect(adaptive.hexValue.code == "FFFFFF")        // light / default
    #expect(adaptive.dark?.hexValue.code == "000000")  // dark override
    #expect(adaptive.value.rgbValue.r == 255)

    let plain = Palette.Element(hex: Hex("FF0000"))
    #expect(plain.dark == nil)
  }

}
