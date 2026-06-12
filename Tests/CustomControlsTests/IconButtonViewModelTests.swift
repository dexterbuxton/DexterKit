import Testing
@testable import CustomControls

@MainActor
struct IconButtonViewModelTests {

  @Test func testPressDownSetsState() {
    let viewModel = IconButtonViewModel()
    #expect(viewModel.isButtonPressed(at: 0) == false)

    viewModel.setButtonPressed(at: 0, isPressed: true)
    #expect(viewModel.isButtonPressed(at: 0))
    #expect(viewModel.isButtonScaled(at: 0))
    #expect(viewModel.animatingButtonIndex == 0)
  }

  @Test func testOtherIndicesUnaffected() {
    let viewModel = IconButtonViewModel()
    viewModel.setButtonPressed(at: 2, isPressed: true)
    #expect(viewModel.isButtonPressed(at: 2))
    #expect(viewModel.isButtonPressed(at: 0) == false)
    #expect(viewModel.isButtonScaled(at: 1) == false)
  }

  @Test func testReleaseClearsPressedImmediately() {
    let viewModel = IconButtonViewModel()
    viewModel.setButtonPressed(at: 0, isPressed: true)
    viewModel.setButtonPressed(at: 0, isPressed: false)
    // `pressed` clears synchronously on release; the scaled/animating state may
    // linger asynchronously to finish the cycle, so it is intentionally not asserted.
    #expect(viewModel.isButtonPressed(at: 0) == false)
  }
}
