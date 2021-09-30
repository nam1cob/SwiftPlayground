import UIKit
import Foundation
import PlaygroundSupport
import XCTest

PlaygroundPage.current.needsIndefiniteExecution = true






protocol P2 {
    associatedtype PluginType
    
    func func1() -> [PluginType]
    func devour(param: PluginType)
}

// Protocol is only generic if the Self will be used for
// associatedtype element : Self // Make the protocol generic
// func holdAMeetingWithTheClan(clan: [Self]) -> Void // Make the protocol generic
// func doesNotMakeProtocolGeneric() -> Self // Does not make protocol generic

protocol P1 {
    func foo1(obj : Self) -> Void
    func foo() -> Self
    
}

struct C1 : P1 {
    func foo() -> C1 {
        return self
    }
    func foo1(obj : Self) -> Void {
        
    }
}

struct C2 : P1 {
    func foo() -> C2 {
        return self
    }
    
    func foo1(obj : Self) -> Void {
        
    }
}



protocol MythicalType {
    //associatedtype element : Self // Make the protocol generic
    func holdAMeetingWithTheClan(clan: [Self]) -> Void // Make the protocol generic
    func doesNotMakeProtocolGeneric() -> Self // Does not make protocol generic
    
}

final class Kraken: MythicalType {
    func doesNotMakeProtocolGeneric() -> Kraken {
        return Kraken()
    }
    
    func holdAMeetingWithTheClan(clan: [Kraken]) -> Void {
        //Time to discuss whether or not it's time to release the kraken.
//        return Kraken()
    }
}

final class Elf: MythicalType {
    func doesNotMakeProtocolGeneric() -> Elf {
        return Elf()
    }
    
    func holdAMeetingWithTheClan(clan: [Elf]) -> Void {
        //Elves are humanity's only hope against the Kraken.
//        return Elf()
    }
}


protocol StackProtocol {
    associatedtype Element : Equatable
    var elements : [Element] {get set}
    var size : Int {get set}
    func push(element : Element) -> Void
    func pop() -> Element?
}


class Stack<T: Equatable> : StackProtocol {
    
    var elements : [T] = []
    var size : Int = 0
    var queue = DispatchQueue(label: "com.stack.queue", attributes: [.initiallyInactive])
        
    init(maxSize: Int) {
        queue.setTarget(queue: DispatchQueue.global(qos: .background))
        queue.activate()
        size = maxSize
    }
    
    func push(element : T) -> Void {
        if elements.count > size {
            return
        }
        queue.sync {
            elements.append(element)
        }
    }
    
    func pop() -> T? {
        queue.sync {
            if elements.count == 0{
                return nil
            }
            return elements.removeLast()
        }
    }
}


class MyTestClass: XCTestCase {
    func testInit () {
        let stackInt : Stack<Int> = Stack<Int>(maxSize: 5)
        XCTAssert(stackInt.size == 5)
            
        
        let stackString : Stack<String> = Stack<String>(maxSize: 20)
        XCTAssert(stackString.size == 20)
    }
    
    func testGenericStack() {
        let stackInt : Stack<Int> = Stack<Int>(maxSize: 5)
        XCTAssert(stackInt.size == 5)
        
        stackInt.push(element: 1)
        stackInt.push(element: 2)
        stackInt.push(element: 3)
        XCTAssert(stackInt.pop() == 3)
        
        let stackStr : Stack<String> = Stack<String>(maxSize: 5)
        stackStr.push(element: "First")
        stackStr.push(element: "Second")
        stackStr.push(element: "Third")
        XCTAssert(stackStr.pop() == "Third")
        
    }
    
    func testMaxSize() {
        let stackInt : Stack<Int> = Stack<Int>(maxSize: 2)
        stackInt.push(element: 1)
        stackInt.push(element: 2)
        stackInt.push(element: 3)
        stackInt.push(element: 4)
        stackInt.push(element: 5)
        stackInt.push(element: 6)
        
        XCTAssert(stackInt.pop() == 3)
    }
    
    func testPustAndPop() {
        let stackInt : Stack<Int> = Stack<Int>(maxSize: 5)
        stackInt.push(element: 1)
        stackInt.push(element: 2)
        stackInt.push(element: 3)
        
        stackInt.pop()
        
        
        XCTAssert(stackInt.pop() == 2)
    }
    
    func testPopOnEmptyStack() {
        let stackInt : Stack<Int> = Stack<Int>(maxSize: 1)
        stackInt.push(element: 1)
        XCTAssert(stackInt.pop() == 1)
        XCTAssert(stackInt.pop() == nil)
    }
    
    func testConcurrency(){
        
        let testQueue = DispatchQueue.init(label: "com.test.stack", attributes: [.concurrent])
        let stackInt : Stack<Int> = Stack<Int>(maxSize: 100)
        for i in 1...100{
            testQueue.async {
                stackInt.push(element: i)
            }
        }
        XCTAssert(stackInt.pop() == 100)
        
    }
}

MyTestClass.defaultTestSuite.run()












protocol AMQ {
    associatedtype Answer : Equatable
    var statement : String {get set}
    var correctAnswer : Answer {get set}
    func isCorrect(answer: Answer) -> Bool
}

extension AMQ {
    func isCorrect(answer: Answer) -> Bool {
        return correctAnswer == answer
    }
}

enum TF {
    case t, f
}

enum Multiple{
    case a,b,c,d
}

struct TFQuestion : AMQ {
    var statement: String
    var correctAnswer: TF
}

struct MultipleChoiseQuestion : AMQ {
    var statement: String
    var correctAnswer: Multiple
}

let tfQ1 = TFQuestion(statement: "Statement 1", correctAnswer: .t)
let mcQ1 = MultipleChoiseQuestion(statement: "Statement 2" , correctAnswer: .c)

func printQuestionResult<Question: AMQ>(currentQuestion: Question, currentAnswer: Question.Answer) -> Bool {
    return currentQuestion.isCorrect(answer: currentAnswer)
}

//let question : AMQ = tfQ //
// Using protocol to model traits of domain entities, rather thant the domin entities themselves.



//https://khawerkhaliq.com/blog/swift-associated-types-self-requirements/


// Swift do not consider the protocol with the assosiated type as firt-class type
// i.e. they cannot be used as
// 1. type of variable/constant
// 2. elements of collection
// 3. function pram or return type.


protocol AutoMarkableQuestion {
    associatedtype Answer: Equatable
    var statement: String { get set }
    var correctAnswer: Answer { get set }
    func isCorrect(answer: Answer) -> Bool
}


extension AutoMarkableQuestion {
    func isCorrect(answer: Answer) -> Bool {
        answer == correctAnswer
    }
}

enum TrueFalseAnswer {
    case t, f
}

enum MultipleChoiceAnswer {
    case a, b, c, d
}

struct TrueFalseQuestion: AutoMarkableQuestion {
    var statement: String
    var correctAnswer: TrueFalseAnswer
    
}

struct MultipleChoiceQuestion : AutoMarkableQuestion {
    var statement: String
    var correctAnswer: MultipleChoiceAnswer
}



let tfQ = TrueFalseQuestion(statement: "Statement 1", correctAnswer: .t)
let mcQ = MultipleChoiceQuestion(statement: "Statement 2" , correctAnswer: .c)


print(tfQ.isCorrect(answer: .f))
print(tfQ.isCorrect(answer: .t))

print(mcQ.isCorrect(answer: .a))
print(mcQ.isCorrect(answer: .c))

// Protocol 'AutoMarkableQuestion' can only be used as a generic constraint because it has Self or associated type requirements
//let iniProtocol : AutoMarkableQuestion

// But the point to using the protocol is to be able to treat question at an abstact level
// so the we can use the question without having to know the actual type of each question


// let question : AutoMarkableQuestion = tfQ <- This will lead to compiler error.
// let questions : [AutoMarkableQuestion] =[tfQ, mcQ]

// This is not limitation of Swift.
// It simply means AutoMarkableQuestion is a incomplet and protocol type does not provide sufficent info about the instance on conforming type.



// Protocol oriented way for the associated type.

protocol AutoMarkable {
    associatedtype  Answer : Equatable
    var correctAnswer : Answer { get set}
    func isCorrect(answer : Answer) -> Bool
    
}
extension AutoMarkable {
    func isCorrect(answer : Answer) -> Bool {
        answer == correctAnswer
    }
}


struct TrueFalseQuestionV2 : AutoMarkable {
    let statement : String
    var correctAnswer: TrueFalseAnswer
}

struct MultipleQuestionV2 : AutoMarkable {
    let statement : String
    var correctAnswer: MultipleChoiceAnswer
}


let tfq1 = TrueFalseQuestionV2(statement: "Statement 2", correctAnswer: .t)
let mcq2 = MultipleQuestionV2(statement: "Statement 3", correctAnswer: .c)


// We have AutoMarkable as a constraint ot the type parameter Question
// which requires that any type that replaces the Question placeholder must confirm to protocol AutoMarkable.
func printResultOf<Question: AutoMarkable>(question: Question, forAnswer givenAnswer: Question.Answer) {
    print(question.isCorrect(answer: givenAnswer) ? "Correct Answer" : "Wrong Answer")
}

printResultOf(question: tfq1, forAnswer: .f)
printResultOf(question: tfq1, forAnswer: .t)

// Cannot convert value of type 'MultipleChoiceAnswer' to expected argument type 'TrueFalseAnswer'
//printResultOf(question: tfq1, forAnswer: MultipleChoiceAnswer.a)

printResultOf(question: mcq2, forAnswer: .a)
printResultOf(question: mcq2, forAnswer: .c)





// A protocol-oriented alternative to associated types

////Animal protocol is incomplete and the protocol type does not provide sufficient information about instances of conforming types
//protocol Animal {
//    associatedtype Food
//    func eat(_: Food)
//}
//
////var animal : Animal       <- Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements
////var animals : [Animal]    <- Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements
//
//// Alternate way.
//struct Grass {}
//struct Meat {}
//
//
//struct Goat : GrassEating {
//    func eat(_: Grass){
//        print("Eating Grass")
//    }
//}
//
//struct Dog : MeatEating{
//    func eat(_: Meat) {
//        print("Eating Meat")
//    }
//}
//
//
//protocol GrassEating {
//    func eat(_: Grass)
//}
//
//protocol MeatEating {
//    func eat(_: Meat)
//}
//
//
//struct Sheep: GrassEating {
//    func eat(_: Grass) {
//        print("Eating Grass")
//    }
//}
//struct Wolf: MeatEating {
//    func eat(_: Meat) {
//        print("Meat Grass")
//    }
//}
//
//
//let goat = Goat()
//let dog = Dog()
//let sheep = Sheep()
//let wolf = Wolf()
//
//let grass = Grass()
//let meat = Meat()
//
//goat.eat(grass)
//dog.eat(meat)
////dog.eat(grass) <- Cannot convert value of type 'Grass' to expected argument type 'Meat'
//
//
//let gazer : GrassEating = goat
//gazer.eat(grass)
//
//let gazers: [GrassEating] = [goat,sheep]
//
//// let gazer : GrassEating = goat           <- Value of type 'Dog' does not conform to specified type 'GrassEating'
////let gazers: [GrassEating] = [goat,sheep] <- Cannot convert value of type 'Dog' to expected element type 'GrassEating'
