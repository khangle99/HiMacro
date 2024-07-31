import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct HiSwiftyMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext) throws -> [DeclSyntax] {
            let memberList = declaration.memberBlock.members
            let varList = memberList.compactMap({ member -> String? in
              // is a property
              guard
                let binding = member
                    .decl.as(VariableDeclSyntax.self)?
                    .bindings.first,
                let propertyName = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                let type = binding.typeAnnotation?.type.description.trimmingCharacters(in: .whitespacesAndNewlines)
              else {
                return nil
              }
                
                // ignore a variable
                if let _ = member.decl.as(VariableDeclSyntax.self)?.attributes.first(where: { element in
                  element.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.description == "SwiftyKeyIgnored"
                }) {
                    return nil
                }
                
                // Raw value enum handle
                if let _ = member.decl.as(VariableDeclSyntax.self)?.attributes.first(where: { element in
                  element.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.description == "RawValueEnum"
                }) {
                    return "\(member.debugDescription)"
                }
                
                var isOptional = false
                if let _ = binding.typeAnnotation?.type.as(OptionalTypeSyntax.self) {
                    isOptional = true
                }

                //return "\(member.debugDescription)"
                
                let isCustomType = self.isCustomType(typeStr: type)
                let swiftyGetValueStr = self.swiftyJsonCodeToGetValue(type: type, isOptional: isOptional)
                var swiftyGetValueStrNoOptionalMark = type
               
                if let _ = swiftyGetValueStrNoOptionalMark.firstIndex(of: "?") {
                    swiftyGetValueStrNoOptionalMark.removeLast()
                }
             
                
              // if it has a SwiftyKey macro on it
              if let customKeyMacro = member.decl.as(VariableDeclSyntax.self)?.attributes.first(where: { element in
                element.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.description == "SwiftyKey"
              }) {

                // Uses the value in the Macro
                let customKeyValue = customKeyMacro.as(AttributeSyntax.self)!
                  .arguments!.as(LabeledExprListSyntax.self)!
                  .first!
                  .expression
                  
                  return isCustomType ? 
                  "self.\(propertyName) = \(swiftyGetValueStrNoOptionalMark)(json: json[\(customKeyValue)])"
                  : "self.\(propertyName) = json[\(customKeyValue)].\(swiftyGetValueStr)"
              } else {
                  return isCustomType ? 
                  "self.\(propertyName) = \(swiftyGetValueStrNoOptionalMark)(json: json[\"\(propertyName)\"])"
                  : "self.\(propertyName) = json[\"\(propertyName)\"].\(swiftyGetValueStr)"
              }
            })
            
            
            let initJson: DeclSyntax = """
                              init(json: JSON) {
                                \(raw: varList.joined(separator: "\n"))
                              }
                              """

            return [initJson]
    }
    
    static func isCustomType(typeStr: String) -> Bool {
        return !["String", "String?", "Int", "Int?", "Bool", "Bool?", "Float", "Float?", "Double", "Double?"].contains(typeStr)
    }
    
    static func swiftyJsonCodeToGetValue(type: String, isOptional: Bool) -> String {
        if isOptional {
            switch type {
            case "String", "String?":
                return "string"
            case "Int", "Int?":
                return "int"
            case "Double", "Double?":
                return "double"
            case "Float", "Float?":
                return "float"
            case "Bool", "Bool?":
                return "bool"
            default:
                return ""
            }
        } else {
            switch type {
            case "String", "String?":
                return "stringValue"
            case "Int", "Int?":
                return "intValue"
            case "Double", "Double?":
                return "doubleValue"
            case "Float", "Float?":
                return "floatValue"
            case "Bool", "Bool?":
                return "boolValue"
            default:
                return ""
            }
        }
       
    }
}

public struct SwiftyKey: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    return []
  }
}

public struct SwiftyKeyIgnoredMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        return []
    }
}

public struct RawValueEnumMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        return []
    }
}


@main
struct HiMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SwiftyKey.self,
        SwiftyKeyIgnoredMacro.self,
        HiSwiftyMacro.self,
        RawValueEnumMacro.self
    ]
}
