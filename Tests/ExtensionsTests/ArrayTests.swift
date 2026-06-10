import Testing
@testable import Extensions

struct ArrayTests {

  @Test func testChunked() throws {
    #expect([1, 2, 3, 4, 5].chunked(into: 2) == [[1, 2], [3, 4], [5]])
    #expect([1, 2, 3].chunked(into: 5) == [[1, 2, 3]])
    #expect([1, 2, 3, 4, 5].chunked(into: 0) == [])
    #expect([Int]().chunked(into: 3) == [])
  }

  @Test func testRemovingDuplicates() throws {
    #expect([1, 2, 2, 3, 1].removingDuplicates() == [1, 2, 3])
    #expect(["a", "b", "a", "c", "b"].removingDuplicates() == ["a", "b", "c"])
    #expect([Int]().removingDuplicates() == [])
  }

  @Test func testToJoinedString() throws {
    #expect([1, 2, 3].toJoinedString() == "1, 2, 3")
    #expect([1, 2, 3].toJoinedString(separator: " | ") == "1 | 2 | 3")
    #expect(["solo"].toJoinedString() == "solo")
    #expect([Int]().toJoinedString().isEmpty)
  }
}
