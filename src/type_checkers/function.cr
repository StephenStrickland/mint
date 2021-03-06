module Mint
  class TypeChecker
    type_error FunctionArgumentConflict
    type_error FunctionTypeMismatch

    def check(node : Ast::Function) : Type
      scope node do
        node.arguments.each do |argument|
          name =
            argument.name.value

          other =
            (node.arguments - [argument]).find(&.name.value.==(name))

          raise FunctionArgumentConflict, {
            "node"  => argument,
            "other" => other,
            "name"  => name,
          } if other
        end

        arguments =
          check node.arguments

        body_type =
          check node.body

        return_type =
          check node.type

        check node.wheres

        resolved =
          Comparer.compare(body_type, return_type)

        raise FunctionTypeMismatch, {
          "expected" => return_type,
          "got"      => body_type,
          "node"     => node,
        } unless resolved

        Type.new("Function", arguments + [return_type])
      end
    end
  end
end
