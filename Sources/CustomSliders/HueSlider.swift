import SwiftUI
import Extensions

/// A customizable gradient slider view
public struct HueSlider: View {

  @State var sliderValue: Double = 0.0

  let rainbowHues = stride(from: 0, to: 1, by: 0.01).map { hue in
    Color.init(hue: hue, saturation: 1, brightness: 1)
  }
  var rainbowThumbColor: Color {
    Color.init(hue: sliderValue, saturation: 1, brightness: 1)
  }

  public var body: some View {
    GradientSlider(
      value: $sliderValue,
      step: 1/360.0,
      thumbColor: rainbowThumbColor,
      trackColors: rainbowHues
    )
  }

}

#Preview("Gradient Sliders") {
  /// A preview showcasing multiple `GradientSlider` instances with different configurations.
  VStack(spacing: 30) {
    HueSlider()
  }
  .padding()
}
