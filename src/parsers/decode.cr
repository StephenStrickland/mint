module Mint
  class Parser
    syntax_error DecodeExpectedExpression
    syntax_error DecodeExpectedType
    syntax_error DecodeExpectedAs

    def decode : Ast::Decode | Nil
      start do |start_position|
        return unless keyword "decode"
        whitespace! SkipError

        expression = expression! DecodeExpectedExpression

        whitespace
        keyword! "as", DecodeExpectedAs
        whitespace

        type = type! DecodeExpectedType

        Ast::Decode.new(
          expression: expression,
          from: start_position,
          type: type,
          to: position,
          input: data)
      end
    end
  end
end
