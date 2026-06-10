import Testing
@testable import Extensions

struct ClosedRangeTests {

  @Test func testClampClosedRangeIntegers() throws {
    let integerRange = (0...10)
    // Test values within range
    #expect(integerRange.clamp(5) == 5)
    #expect(integerRange.clamp(8) == 8)
    #expect(integerRange.clamp(2) == 2)
    // Test upper and lower bounds
    #expect(integerRange.clamp(0) == 0)
    #expect(integerRange.clamp(10) == 10)
    // Test out of bounds
    #expect(integerRange.clamp(-2) == 0)
    #expect(integerRange.clamp(15) == 10)
  }

  @Test func testClampPercentDouble() throws {
    let percent = (0.0...1.0)
    // Test values within range
    #expect(percent.clamp(0.5) == 0.5)
    #expect(percent.clamp(0.8) == 0.8)
    #expect(percent.clamp(0.2) == 0.2)
    // Test upper and lower bounds
    #expect(percent.clamp(0.0) == 0.0)
    #expect(percent.clamp(1.0) == 1.0)
    // Test out of bounds
    #expect(percent.clamp(-2.0) == 0.0)
    #expect(percent.clamp(1.5) == 1.0)
  }

  @Test func testClampPostiveAndNegative() throws {
    let integerRange = (-10...10)
    // Test values within range
    #expect(integerRange.clamp(3) == 3)
    #expect(integerRange.clamp(-4) == -4)
    #expect(integerRange.clamp(0) == 0)
    // Test upper and lower bounds
    #expect(integerRange.clamp(-10) == -10)
    #expect(integerRange.clamp(10) == 10)
    // Test out of bounds
    #expect(integerRange.clamp(-15) == -10)
    #expect(integerRange.clamp(15) == 10)
  }
}
