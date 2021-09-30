import UIKit
import Foundation

enum Country {
    case India
}

struct Player {
    let firstName : String
    let lastName : String
    let age : Int
}

struct Team {
    let players : [Player]
}





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
// It simply means AutoMarkableQuestion is aincomplet and protocol type does not provide sufficent info about the instance on conforming type.



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

//Animal protocol is incomplete and the protocol type does not provide sufficient information about instances of conforming types
protocol Animal {
    associatedtype Food
    func eat(_: Food)
}

//var animal : Animal       <- Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements
//var animals : [Animal]    <- Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements

// Alternate way.
struct Grass {}
struct Meat {}


struct Goat : GrassEating {
    func eat(_: Grass){
        print("Eating Grass")
    }
}

struct Dog : MeatEating{
    func eat(_: Meat) {
        print("Eating Meat")
    }
}


protocol GrassEating {
    func eat(_: Grass)
}

protocol MeatEating {
    func eat(_: Meat)
}


struct Sheep: GrassEating {
    func eat(_: Grass) {
        print("Eating Grass")
    }
}
struct Wolf: MeatEating {
    func eat(_: Meat) {
        print("Meat Grass")
    }
}


let goat = Goat()
let dog = Dog()
let sheep = Sheep()
let wolf = Wolf()

let grass = Grass()
let meat = Meat()

goat.eat(grass)
dog.eat(meat)
//dog.eat(grass) <- Cannot convert value of type 'Grass' to expected argument type 'Meat'


let gazer : GrassEating = goat
gazer.eat(grass)

let gazers: [GrassEating] = [goat,sheep]

// let gazer : GrassEating = goat           <- Value of type 'Dog' does not conform to specified type 'GrassEating'
//let gazers: [GrassEating] = [goat,sheep] <- Cannot convert value of type 'Dog' to expected element type 'GrassEating'
