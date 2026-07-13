import Testing
import SwiftUI
@testable import CustomControls

@MainActor
struct IconButtonGroupSpacingTests {

  // MARK: Left-Alone Cases

  @Test func testSpacingAtOrBelowTwo_noReallocation() throws {
    // Test 1: Spacing 0 — untouched, no edge padding, regardless of count
    #expect(IconButtonGroup.reallocatesSpacing(itemCount: 2, spacing: 0) == false)
    #expect(IconButtonGroup.edgePadding(itemCount: 2, spacing: 0) == 0)
    #expect(IconButtonGroup.effectiveGapSpacing(itemCount: 2, spacing: 0) == 0)

    // Test 2: Spacing 1 with 5 buttons — still untouched
    #expect(IconButtonGroup.reallocatesSpacing(itemCount: 5, spacing: 1) == false)
    #expect(IconButtonGroup.edgePadding(itemCount: 5, spacing: 1) == 0)
    #expect(IconButtonGroup.effectiveGapSpacing(itemCount: 5, spacing: 1) == 1)

    // Test 3: Spacing exactly 2 — the boundary, still untouched
    #expect(IconButtonGroup.reallocatesSpacing(itemCount: 2, spacing: 2) == false)
    #expect(IconButtonGroup.edgePadding(itemCount: 2, spacing: 2) == 0)
  }

  // MARK: Uncapped Reallocation

  @Test func testTwoButtons_spacingFour() throws {
    // leading 1, gap 2, trailing 1
    #expect(IconButtonGroup.gapCount(itemCount: 2) == 1)
    #expect(IconButtonGroup.isCapped(itemCount: 2, spacing: 4) == false)
    #expect(IconButtonGroup.edgePadding(itemCount: 2, spacing: 4) == 1)
    #expect(IconButtonGroup.effectiveGapSpacing(itemCount: 2, spacing: 4) == 2)
  }

  @Test func testThreeButtons_spacingFour() throws {
    // leading 2, gap 2, gap 2, trailing 2
    #expect(IconButtonGroup.gapCount(itemCount: 3) == 2)
    #expect(IconButtonGroup.isCapped(itemCount: 3, spacing: 4) == false)
    #expect(IconButtonGroup.edgePadding(itemCount: 3, spacing: 4) == 2)
    #expect(IconButtonGroup.effectiveGapSpacing(itemCount: 3, spacing: 4) == 2)
  }

  @Test func testFourButtons_spacingFour() throws {
    // Below the default cap (6), so still uncapped: leading 3, trailing 3.
    #expect(IconButtonGroup.gapCount(itemCount: 4) == 3)
    #expect(IconButtonGroup.isCapped(itemCount: 4, spacing: 4) == false)
    #expect(IconButtonGroup.edgePadding(itemCount: 4, spacing: 4) == 3)
    #expect(IconButtonGroup.effectiveGapSpacing(itemCount: 4, spacing: 4) == 2)
  }

  // MARK: Capped Reallocation

  @Test func testManyButtons_spacingFour_capsAtMaxGroupInnerPadding() throws {
    // 8 buttons → 7 gaps, which exceeds the default cap of 6.
    #expect(IconButtonGroup.gapCount(itemCount: 8) == 7)
    #expect(IconButtonGroup.isCapped(itemCount: 8, spacing: 4))
    #expect(IconButtonGroup.edgePadding(itemCount: 8, spacing: 4) == CustomButtonConfiguration.maxGroupInnerPadding)
  }

  // MARK: Total Width Invariant

  @Test func testGroupWidthMatchesBareButtonRow_uncapped() throws {
    // A group's total width must always equal N bare buttons at the same
    // spacing — reallocation only ever relocates space, never adds or
    // removes it.
    let width = IconButtonGroup.groupWidth(itemCount: 2, buttonWidth: 44, spacing: 4)
    let bareRowWidth: CGFloat = 2 * 44 + 1 * 4
    #expect(width == bareRowWidth)
  }

  @Test func testGroupWidthMatchesBareButtonRow_capped() throws {
    let width = IconButtonGroup.groupWidth(itemCount: 8, buttonWidth: 44, spacing: 4)
    let bareRowWidth: CGFloat = 8 * 44 + 7 * 4
    #expect(width == bareRowWidth)
  }

  @Test func testGroupWidthUnaffectedByReallocation_belowThreshold() throws {
    // Spacing <= 2 takes the "leave alone" path entirely, but should still
    // report the same width formula as everything else.
    let width = IconButtonGroup.groupWidth(itemCount: 2, buttonWidth: 44, spacing: 1)
    let bareRowWidth: CGFloat = 2 * 44 + 1 * 1
    #expect(width == bareRowWidth)
  }

  // MARK: Circle Style

  @Test func testCircleStyleReallocatesIdenticallyToSquare() throws {
    // .circle always uses groupSpacing (8) internally, so it should go
    // through the exact same reallocation as an equivalent .square group.
    let circleSpacing = IconButtonGroup.Style.circle.spacing
    #expect(circleSpacing == CustomButtonConfiguration.groupSpacing)

    let circleEdge = IconButtonGroup.edgePadding(itemCount: 2, spacing: circleSpacing)
    let squareEdge = IconButtonGroup.edgePadding(itemCount: 2, spacing: CustomButtonConfiguration.groupSpacing)
    #expect(circleEdge == squareEdge)

    let circleGap = IconButtonGroup.effectiveGapSpacing(itemCount: 2, spacing: circleSpacing)
    let squareGap = IconButtonGroup.effectiveGapSpacing(itemCount: 2, spacing: CustomButtonConfiguration.groupSpacing)
    #expect(circleGap == squareGap)
  }
}
