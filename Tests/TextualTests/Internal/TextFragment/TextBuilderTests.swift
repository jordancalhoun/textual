#if os(macOS) || os(iOS)
  import SwiftUI
  import Testing

  @testable import Textual

  @MainActor
  struct TextBuilderTests {
    @Test func renderingManyAttributedRunsDoesNotOverflowStack() {
      let renderer = ImageRenderer(
        content: TextFragment(Self.attributedStringWithManyRuns(count: 2_500))
          .frame(width: 320)
          .fixedSize(horizontal: false, vertical: true)
          .coordinateSpace(.textContainer)
      )
      renderer.proposedSize = .init(width: 320, height: 4_000)

      #if os(macOS)
        #expect(renderer.nsImage != nil)
      #else
        #expect(renderer.uiImage != nil)
      #endif
    }

    @Test func renderingHighlightedCodeSizedRunsDoesNotOverflowStack() {
      let renderer = ImageRenderer(
        content: TextFragment(Self.attributedStringWithManyRuns(count: 40_000))
          .frame(width: 320)
          .fixedSize(horizontal: false, vertical: true)
          .coordinateSpace(.textContainer)
      )
      renderer.proposedSize = .init(width: 320, height: 4_000)

      #if os(macOS)
        #expect(renderer.nsImage != nil)
      #else
        #expect(renderer.uiImage != nil)
      #endif
    }

    private static func attributedStringWithManyRuns(count: Int) -> AttributedString {
      (0..<count).reduce(into: AttributedString()) { result, index in
        var fragment = AttributedString(index.isMultiple(of: 40) ? "\n" : "x")
        fragment.font = index.isMultiple(of: 2) ? .body.bold() : .body
        result += fragment
      }
    }
  }
#endif
