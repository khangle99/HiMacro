// The Swift Programming Language
// https://docs.swift.org/swift-book


@attached(peer)
public macro SwiftyKey(name: String) = #externalMacro(module: "HiMacroMacros", type: "SwiftyKey")

@attached(peer, names: overloaded)
public macro SwiftyKeyIgnored() = #externalMacro(module: "HiMacroMacros", type: "SwiftyKeyIgnoredMacro")

@attached(peer, names: overloaded)
public macro RawValueEnum() = #externalMacro(module: "HiMacroMacros", type: "RawValueEnumMacro")

@attached(member, names: arbitrary)
public macro HiSwifty() = #externalMacro(module: "HiMacroMacros", type: "HiSwiftyMacro")
