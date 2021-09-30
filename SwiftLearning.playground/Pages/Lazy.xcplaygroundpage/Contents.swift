

import Foundation

struct Person{
    let name: String
    let age: Int

}
struct PeopleViewModel {
    var people: [Person]
    
    lazy var oldest: Person? = {
        print("oldest person calculated")
        return people.max(by: { $0.age < $1.age })
    }()
    
    
    mutating func addPeople(_ person: Person){
        people.append(person)
    }
}

var viewModel = PeopleViewModel(people: [
    Person(name: "Antoine", age: 30),
    Person(name: "Jaap", age: 3),
    Person(name: "Lady", age: 3),
    Person(name: "Maaike", age: 27)
])



print(viewModel.oldest)

viewModel.addPeople(Person(name: "Jan", age: 69))
print(viewModel.oldest)


// 1. Lazy value is calcuated only once if we chagne he struct later then ther will NO NEW computation
// 2. Lazy store proper are mutable. "cannot use mutating getter on immutable value: 'viewModel' is a 'let' constan"

//
//struct LazyStruct {
//    lazy var lazyBool: Bool = { false } ()
//    func accessLazyBool() -> Bool {
//        return lazyBool // Error
//    }
//}
//
//var a = LazyStruct()
//a.lazyBool // Error
