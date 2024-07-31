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
//    @RawValueEnum() var myEnum: MyEnum? = .first
    var name: String?
//    @SwiftyKey(name: "tuoi") var age: Int = 0
//    @SwiftyKeyIgnored() let color: Cat?
//    let sampleFloat: Float?
    let sampleDouble: Double
//    @SwiftyKey(name: "xe") let car: Car?

}

