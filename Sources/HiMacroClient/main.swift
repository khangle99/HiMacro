import HiMacro

@HiSwifty
class Car {
    var id: String
}

class Cat {}

enum MyEnum: String {
    case first
    case sec
    case third
}

@HiSwifty
class MyModel {
    @SwiftyKey(name: "enum_key")
    @RawValueEnum(Int.self)
    var myEnum: MyEnum? = .first
//    var name: String?
//    @SwiftyKey(name: "tuoi") var age: Int = 0
//   @SwiftyKeyIgnored let color: Cat?
//    let sampleFloat: Float?
//    @SwiftyKeyIgnored  let sampleDouble: Double
//    @SwiftyKey(name: "xe") let car: Car?

}

