import Testing
@testable import CustomColors

struct RGBTests {

  @Test func testInitializer() throws {
    var rgb = RGB()
    #expect(rgb.r == 0 && rgb.g == 0 && rgb.b == 0)
    #expect(rgb.rValue == 0 && rgb.gValue == 0 && rgb.bValue == 0)

    rgb = RGB(r: 111, g: 11, b: 1)
    #expect(rgb.r == 111 && rgb.g == 11 && rgb.b == 1)
    #expect(rgb.rValue == 0.43529411764705883 && rgb.gValue == 0.043137254901960784 && rgb.bValue == 0.00392156862745098)

    var tone = RGB(value: 85)
    #expect(tone.r == 85 && tone.g == 85 && tone.b == 85)
    #expect(tone.rValue == 0.3333333333333333 && tone.gValue == 0.3333333333333333 && tone.bValue == 0.3333333333333333)

    rgb = RGB(r: 0.4353, g: 0.0431, b: 0.0039)
    #expect(rgb.r == 111 && rgb.g == 11 && rgb.b == 1)
    #expect(rgb.rValue == 0.4353 && rgb.gValue == 0.0431 && rgb.bValue == 0.0039)

    tone = RGB(value: 0.333)
    #expect(tone.r == 85 && tone.g == 85 && tone.b == 85)
    #expect(tone.rValue == 0.333 && tone.gValue == 0.333 && tone.bValue == 0.333)
  }

  @Test func testSettingValues() throws {
    // Integer Values
    var rgb = RGB()
    rgb.r = 33
    #expect(rgb.r == 33)
    #expect(rgb.rValue == 0.12941176470588237)
    rgb.g = 44
    #expect(rgb.g == 44)
    #expect(rgb.gValue == 0.17254901960784313)
    rgb.b = 55
    #expect(rgb.b == 55)
    #expect(rgb.bValue == 0.21568627450980393)

    // Double Values
    rgb.rValue = 0.25
    #expect(rgb.rValue == 0.25)
    #expect(rgb.r == 64)
    rgb.bValue = 0.2
    #expect(rgb.bValue == 0.2)
    #expect(rgb.b == 51)
    rgb.gValue = 0.55
    #expect(rgb.gValue == 0.55)
    #expect(rgb.g == 140)
  }

  @Test func testInvalidValues() throws {
    // Extremely positive
    var rgb = RGB(r: 256, g: 1024, b: 1_000_000)
    #expect(rgb.r == 255 && rgb.g == 255 && rgb.b == 255)
    #expect(rgb.rValue == 1.0 && rgb.gValue == 1.0 && rgb.bValue == 1.0)
    rgb.r = 1000
    #expect(rgb.r == 255)
    #expect(rgb.rValue == 1.0)
    rgb.g = 1000
    #expect(rgb.g == 255)
    #expect(rgb.gValue == 1.0)
    rgb.b = 1000
    #expect(rgb.b == 255)
    #expect(rgb.bValue == 1.0)

    rgb = RGB(r: 1.23456789, g: 12.3456789, b: 12345.6789)
    #expect(rgb.r == 255 && rgb.g == 255 && rgb.b == 255)
    #expect(rgb.rValue == 1.0 && rgb.gValue == 1.0 && rgb.bValue == 1.0)
    rgb.rValue = 9.87654321
    #expect(rgb.r == 255)
    #expect(rgb.rValue == 1.0)
    rgb.gValue = 9.87654321
    #expect(rgb.g == 255)
    #expect(rgb.gValue == 1.0)
    rgb.bValue = 9.87654321
    #expect(rgb.b == 255)
    #expect(rgb.bValue == 1.0)

    // Extremely negative
    rgb = RGB(r: -1, g: -256, b: -1_000_000)
    #expect(rgb.r == 0 && rgb.g == 0 && rgb.b == 0)
    #expect(rgb.rValue == 0.0 && rgb.gValue == 0.0 && rgb.bValue == 0.0)
    rgb.r = -1000
    #expect(rgb.r == 0)
    #expect(rgb.rValue == 0.0)
    rgb.g = -1000
    #expect(rgb.g == 0)
    #expect(rgb.rValue == 0.0)
    rgb.b = -1000
    #expect(rgb.b == 0)
    #expect(rgb.rValue == 0.0)

    rgb = RGB(r: -1.23456789, g: -12.3456789, b: -12345.6789)
    #expect(rgb.r == 0 && rgb.g == 0 && rgb.b == 0)
    #expect(rgb.rValue == 0.0 && rgb.gValue == 0.0 && rgb.bValue == 0.0)
    rgb.rValue = -9.87654321
    #expect(rgb.r == 0)
    #expect(rgb.rValue == 0.0)
    rgb.gValue = -9.87654321
    #expect(rgb.g == 0)
    #expect(rgb.gValue == 0.0)
    rgb.bValue = -9.87654321
    #expect(rgb.b == 0)
    #expect(rgb.bValue == 0.0)
  }

  @Test func testRandomColor() throws {
    var random: RGB
    for _ in 0...255 {
      random = RGB.random
      let clampedR = (0...255).clamp(random.r)
      #expect(random.r == clampedR)
      let clampedG = (0...255).clamp(random.g)
      #expect(random.g == clampedG)
      let clampedB = (0...255).clamp(random.b)
      #expect(random.b == clampedB)
    }
  }

  @Test func testDescription() throws {
    var rgb = RGB(r: 123, g: 45, b: 67)
    #expect(rgb.description == "RGB(123, 45, 67)")

    rgb = RGB()
    #expect(rgb.description == "RGB(0, 0, 0)")

    #expect(RGB.red.description == "RGB(255, 0, 0)")
    #expect(RGB.green.description == "RGB(0, 255, 0)")
    #expect(RGB.blue.description == "RGB(0, 0, 255)")
  }

  @Test func isLight() {

    // Dark colors
    #expect(RGB.black.isLight == false)
    #expect(RGB.darkGray.isLight == false)
    // Pure red has high luminance
    #expect(RGB.red.isLight == true)
    // Pure blue has very low luminance
    #expect(RGB.blue.isLight == false)

    // Light colors
    #expect(RGB.white.isLight == true)
    #expect(RGB.lightGray.isLight == true)
    // Full red + green channels = very high luminance
    #expect(RGB.yellow.isLight == true)
    // Full green + blue channels
    #expect(RGB.cyan.isLight == true)

    // Perceptual edge cases
    // Luminance ~0.715 — far lighter than it naively looks
    #expect(RGB.green.isLight == true)
    // Value 127 gives luminance ~0.216, just above threshold
    #expect(RGB.gray.isLight == true)
    // Just below mid gray, falls under threshold
    #expect(RGB(value: 100).isLight == false)
    // Full red + blue gives luminance ~0.284
    #expect(RGB.magenta.isLight == true)

    // Threshold boundary
    #expect(RGB(value: 117).isLight == false)
    // One step above boundary, flips to light
    #expect(RGB(value: 118).isLight == true)
  }

  @Test func testHexInitializer() throws {
    let hex = Hex("#7B2D43")
    let rgb = RGB(hex: hex)
    #expect(rgb.r == 123 && rgb.g == 45 && rgb.b == 67)

    let rgbFromString = RGB(hex: "#7B2D43")
    #expect(rgbFromString.r == 123 && rgbFromString.g == 45 && rgbFromString.b == 67)
  }

  @Test func testStaticColors() throws {
    #expect(RGB.black.r == 0 && RGB.black.g == 0 && RGB.black.b == 0)
    #expect(RGB.black.rValue == 0.0 && RGB.black.gValue == 0.0 && RGB.black.bValue == 0.0)
    #expect(RGB.white.r == 255 && RGB.white.g == 255 && RGB.white.b == 255)
    #expect(RGB.white.rValue == 1.0 && RGB.white.gValue == 1.0 && RGB.white.bValue == 1.0)

    #expect(RGB.red.r == 255 && RGB.red.g == 0 && RGB.red.b == 0)
    #expect(RGB.red.rValue == 1.0 && RGB.red.gValue == 0.0 && RGB.red.bValue == 0.0)
    #expect(RGB.green.r == 0 && RGB.green.g == 255 && RGB.green.b == 0)
    #expect(RGB.green.rValue == 0.0 && RGB.green.gValue == 1.0 && RGB.green.bValue == 0.0)
    #expect(RGB.blue.r == 0 && RGB.blue.g == 0 && RGB.blue.b == 255)
    #expect(RGB.blue.rValue == 0.0 && RGB.blue.gValue == 0.0 && RGB.blue.bValue == 1.0)

    #expect(RGB.cyan.r == 0 && RGB.cyan.g == 255 && RGB.cyan.b == 255)
    #expect(RGB.cyan.rValue == 0.0 && RGB.cyan.gValue == 1.0 && RGB.cyan.bValue == 1.0)
    #expect(RGB.magenta.r == 255 && RGB.magenta.g == 0 && RGB.magenta.b == 255)
    #expect(RGB.magenta.rValue == 1.0 && RGB.magenta.gValue == 0.0 && RGB.magenta.bValue == 1.0)
    #expect(RGB.yellow.r == 255 && RGB.yellow.g == 255 && RGB.yellow.b == 0)
    #expect(RGB.yellow.rValue == 1.0 && RGB.yellow.gValue == 1.0 && RGB.yellow.bValue == 0.0)

    #expect(RGB.gray.r == 127 && RGB.gray.g == 127 && RGB.gray.b == 127)
    #expect(RGB.lightGray.r == 170 && RGB.lightGray.g == 170 && RGB.lightGray.b == 170)
    #expect(RGB.darkGray.r == 85 && RGB.darkGray.g == 85 && RGB.darkGray.b == 85)
    #expect(RGB.offBlack.r == 30 && RGB.offBlack.g == 30 && RGB.offBlack.b == 30)
    #expect(RGB.offWhite.r == 240 && RGB.offWhite.g == 240 && RGB.offWhite.b == 240)
  }

  @Test func testRGBMix() throws {
    // Test 50% mix of red and blue
    let redBlue50 = RGB.mix(RGB.red, with: RGB.blue)
    #expect(redBlue50.r == 128 && redBlue50.g == 0 && redBlue50.b == 128)
    #expect(redBlue50.rValue == 0.5 && redBlue50.gValue == 0 && redBlue50.bValue == 0.5)

    // Test 50% mix of cyan and blue
    let cyanBlue50 = RGB.mix(RGB.cyan, with: RGB.blue)
    #expect(cyanBlue50.r == 0 && cyanBlue50.g == 128 && cyanBlue50.b == 255)
    #expect(cyanBlue50.rValue == 0 && cyanBlue50.gValue == 0.5 && cyanBlue50.bValue == 1.0)
    print(cyanBlue50.description)

    // Test 50% mix of red and green
    let redGreen50 = RGB.mix(RGB.red, with: RGB.green, percent: 0.5)
    #expect(redGreen50.r == 128 && redGreen50.g == 128 && redGreen50.b == 0)
    #expect(redGreen50.rValue == 0.5 && redGreen50.gValue == 0.5 && redGreen50.bValue == 0.0)

    // Test 25% mix of blue and yellow
    let blueYellow25 = RGB.mix(RGB.blue, with: RGB.yellow, percent: 0.25)
    #expect(blueYellow25.r == 64 && blueYellow25.g == 64 && blueYellow25.b == 191)
    #expect(blueYellow25.rValue == 0.25 && blueYellow25.gValue == 0.25 && blueYellow25.bValue == 0.75)

    // Test 75% mix of cyan and magenta
    let cyanMagenta75 = RGB.mix(RGB.cyan, with: RGB.magenta, percent: 0.75)
    #expect(cyanMagenta75.r == 191 && cyanMagenta75.g == 64 && cyanMagenta75.b == 255)
    #expect(cyanMagenta75.rValue == 0.75 && cyanMagenta75.gValue == 0.25 && cyanMagenta75.bValue == 1.0)

    // Test 0% mix (should return the first color)
    let redBlue0 = RGB.mix(RGB.red, with: RGB.blue, percent: 0.0)
    #expect(redBlue0.r == 255 && redBlue0.g == 0 && redBlue0.b == 0)
    #expect(redBlue0.rValue == 1.0 && redBlue0.gValue == 0.0 && redBlue0.bValue == 0.0)

    // Test 100% mix (should return the second color)
    let redBlue100 = RGB.mix(RGB.red, with: RGB.blue, percent: 1.0)
    #expect(redBlue100.r == 0 && redBlue100.g == 0 && redBlue100.b == 255)
    #expect(redBlue100.rValue == 0.0 && redBlue100.gValue == 0.0 && redBlue100.bValue == 1.0)
  }

  @Test func testRGBGradients() throws {
    // Test with 3 gradients including originals
    var gradients = RGB.gradients(between: RGB.red, and: RGB.blue, count: 3, includingOriginals: true)
    #expect(gradients.count == 5) // 3 gradients + 2 originals
    var colorA = gradients[2]
    var colorB = RGB(r: 128, g: 0, b: 128)
    #expect(colorA.r == colorB.r && colorA.g == colorB.g && colorA.b == colorB.b)

    // Test with 3 gradients excluding originals
    gradients = RGB.gradients(between: RGB.red, and: RGB.blue, count: 3, includingOriginals: false)
    #expect(gradients.count == 3) // Only 3 gradients
    colorA = gradients[1]
    colorB = RGB(r: 128, g: 0, b: 128)
    #expect(colorA.r == colorB.r && colorA.g == colorB.g && colorA.b == colorB.b)

    // Test with 5 gradients including originals
    gradients = RGB.gradients(between: RGB.green, and: RGB.yellow, count: 5, includingOriginals: true)
    #expect(gradients.count == 7) // 5 gradients + 2 originals
    colorA = gradients[3]
    colorB = RGB(r: 128, g: 255, b: 0)
    #expect(colorA.r == colorB.r && colorA.g == colorB.g && colorA.b == colorB.b)

    // Test with 5 gradients excluding originals
    gradients = RGB.gradients(between: RGB.green, and: RGB.yellow, count: 5, includingOriginals: false)
    #expect(gradients.count == 5) // Only 5 gradients
    colorA = gradients[4]
    colorB = RGB(r: 212, g: 255, b: 0)
    #expect(colorA.r == colorB.r && colorA.g == colorB.g && colorA.b == colorB.b)

    // Test with 0 gradients including originals
    gradients = RGB.gradients(between: RGB.cyan, and: RGB.magenta, count: 0, includingOriginals: true)
    #expect(gradients.count == 2) // Only the original colors

    // Test with 0 gradients excluding originals
    gradients = RGB.gradients(between: RGB.cyan, and: RGB.magenta, count: 0, includingOriginals: false)
    #expect(gradients.count == 0) // Only the original colors

    // Test with identical colors
    gradients = RGB.gradients(between: RGB.cyan, and: RGB.cyan, count: 5, includingOriginals: false)
    #expect(gradients.count == 5)
  }
}
