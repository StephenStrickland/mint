module Mint
  class TypeChecker
    type_error DecodeExpectedObject
    type_error DecodeComplexType

    def check(node : Ast::Decode) : Type
      expression =
        check node.expression

      type =
        check node.type

      raise "" unless type

      raise DecodeExpectedObject, {
        "expected" => OBJECT,
        "got"      => expression,
        "node"     => node,
      } unless Comparer.compare(expression, OBJECT)

      raise DecodeComplexType, {
        "got"  => type,
        "node" => node,
      } unless check_decode(type)

      types[node] = type

      Type.new("Result", [OBJECT_ERROR, type])
    end

    def check_decode(type : Type)
      case type
      when Record
        type.fields.all? do |_, value|
          check_decode value
        end
      else
        case type.name
        when "String", "Time", "Number", "Bool"
          true
        when "Array", "Maybe"
          if type.parameters.size == 1
            check_decode type.parameters.first
          else
            false
          end
        else
          false
        end
      end
    end
  end
end
