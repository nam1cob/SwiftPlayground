import Foundation
import XCTest
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
class Address {
    var street = ""
    var city = ""
    var state = "";
    enum AddressAttributes: Int {
        case Street
        case City
        case State
    }
    func updateAttribute(value: String, attribute: AddressAttributes){
        switch attribute {
        case .Street:
            street = value;
        case .City:
            city = value;
        case .State:
            state = value;
        }
    }
}

class MyTest : XCTestCase {
    
//    func 1testArray() {
//        var array : [Address] = []
//        let address = Address()
//        let i = Int.random(in: 0...2)
//        address.updateAttribute(value: "SomeValue", attribute: Address.AddressAttributes.init(rawValue: i)!)
//        measure {
//            for _ in 1...100 {
//                array.append(address)
//            }
//        }
//    }
//
//
//    func 1testContiguousArray() {
//        var array : ContiguousArray<Address> = []
//        let address = Address()
//        let i = Int.random(in: 0...2)
//        address.updateAttribute(value: "SomeValue", attribute: Address.AddressAttributes.init(rawValue: i)!)
//        measure {
//            for _ in 1...100 {
//                array.append(address)
//            }
//        }
//    }
    
    
    func testPerformanceForClassArray() {
      let address = Address()
      var array: [Address]  = []
      self.measure {
        for _ in 0..<100 {
          array.append(address)
        }
      }
    }
    func testPerformanceForClassContiguousArray() {
      let address = Address()
      var array: ContiguousArray<Address> = []
      self.measure {
        for _ in 0..<100 {
          array.append(address)
        }
      }
    }
    
}
//MyTest.defaultTestSuite.run()




// COW (Copy Over Write)


//COW enable value type to be reference when they are coppied.
// The real copy only happens when the arelady exsiting strong refrence and you are trying to
// modify the copy


struct Car {
    let model = "M3"
}

final class Ref<T>{
    var value : T
    
    init(v: T) {
        value = v
    }
}


struct Box<T> {
    var ref : Ref<T>
    
    init(_ r : Ref<T>) {
        ref = r
    }
    
    
    var value: T {
        get {
            return ref.value
        }
        set{
            if(!isKnownUniquelyReferenced(&ref)){
                ref = Ref(v: newValue)
                return
            }
            ref.value = newValue
        }
    }
}


class boo {
    var value : Int = 0
}

struct someStuct {
    var value : Int = 0
}
struct foo : Equatable {
    static func == (lhs: foo, rhs: foo) -> Bool {
        return lhs.structObj?.value == rhs.structObj?.value
    }
    
    var obj : boo?
    var structObj : someStuct?
    
}

var fooObj : foo = foo()
var booObj = boo()
CFGetRetainCount(booObj)

fooObj.obj = booObj
CFGetRetainCount(booObj)
fooObj.structObj = someStuct(value: 3)


var fooObj2 : foo = fooObj
CFGetRetainCount(booObj)

fooObj.structObj?.value = 10
fooObj.obj?.value = 20

print(fooObj.obj?.value)
print(fooObj2.obj?.value)


print(fooObj.structObj?.value)
print(fooObj2.structObj?.value)

CFGetRetainCount(booObj)



if fooObj == fooObj2 {
    print("Equal")
}else{
    print("Not Equal")
}

