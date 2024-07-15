import HiMacro

@HiSwifty
class Car {
    var id: String
}

class Cat {}


@HiSwifty
class MyModel {
    var name: String
    @SwiftyKey(name: "tuoi") var age: Int = 0
    @SwiftyKeyIgnored() let color: Cat?
    let sampleFloat: Float?
    let sampleDouble: Double
    @SwiftyKey(name: "xe") let car: Car?

}

