import Foundation
import Testing
import Textual

extension StructuredText {
  @MainActor
  struct InitialRenderingTests {
    @Test func parsesMarkupBeforeFirstBodyIsBuilt() {
      let parser = RecordingParser()
      let view = StructuredText("# Artifact heading", parser: parser)

      _ = view.body

      #expect(parser.inputs == ["# Artifact heading"])
    }
  }
}

@MainActor
private final class RecordingParser: MarkupParser {
  var inputs: [String] = []

  func attributedString(for input: String) throws -> AttributedString {
    inputs.append(input)
    return AttributedString(input)
  }
}
