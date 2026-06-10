import Testing
@testable import Extensions

struct BinaryFloatingPointTests {

  @Test func testShortened() throws {
    // Given
    let myDouble = 0.1234
    let myFloat = 1234.56789

    // When
    let myDoubleShortened = myDouble.shortened
    let myFloatShortened = myFloat.shortened

    // Then
    #expect(myDoubleShortened == "0.12")
    #expect(myFloatShortened == "1234.57")
  }

  @Test func testNormalized() throws {
    // Given
    let percentNormalA = 0.15
    let percentNormalB = 0.72
    let percentNormalC = 0.99
    let percentNormalZero = 0.0
    let percentNormalOne = 1.0
    let percentNegative = -0.15
    let percentHighA = 1.0001
    let percentHighB = 56.024755

    // Then
    #expect(percentNormalA.normalized() == 0.15)
    #expect(percentNormalB.normalized() == 0.72)
    #expect(percentNormalC.normalized() == 0.99)
    #expect(percentNormalZero.normalized() == 0.0)
    #expect(percentNormalOne.normalized() == 1.0)
    #expect(percentNegative.normalized() == 0.0)
    #expect(percentHighA.normalized() == 1.0)
    #expect(percentHighB.normalized() == 1.0)
  }
}
