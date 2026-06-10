import Testing
@testable import Extensions

struct IntTests {

  @Test func testGCD() throws {
    #expect(12.gcd(with: 8) == 4)
    #expect(54.gcd(with: 24) == 6)
    #expect(17.gcd(with: 5) == 1)
    #expect(9.gcd(with: 0) == 9)
    #expect(0.gcd(with: 0) == 0)
    // Sign-agnostic
    #expect((-12).gcd(with: 8) == 4)
    #expect(12.gcd(with: -8) == 4)
  }

  @Test func testLCM() throws {
    #expect(4.lcm(with: 6) == 12)
    #expect(3.lcm(with: 5) == 15)
    #expect(21.lcm(with: 6) == 42)
    // Zero on either side yields zero
    #expect(0.lcm(with: 5) == 0)
    #expect(7.lcm(with: 0) == 0)
    // Sign-agnostic (result is always positive)
    #expect((-4).lcm(with: 6) == 12)
  }
}
