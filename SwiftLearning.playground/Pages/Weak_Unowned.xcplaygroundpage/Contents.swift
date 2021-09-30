
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// https://github.com/Ebazhanov/linkedin-skill-assessments-quizzes/blob/master/swift/swift-quiz.md


let value = Double(6)


enum Direction: String {
  case north, south, east, west
}

let direction = Direction.north

typealias Thing = [String: Any]
var stuff: Thing
print(type(of: stuff))


var dict : [String: Any] = [:]


var x : Int?
let y = x ?? 5


let x1 = ["1", "2"].dropFirst()


func myFunc(_ a: Int, b: Int) -> Int {
  return a + b
}


myFunc(5, b: 6)

let value1 = "\("test".count)"


let val = 5


class Blog {
    let name : String
    let url : URL
    weak var owner : Blogger?
    var publishedPosts : [Post] = []
    var onPublish : ((_ post :Post) -> ())?
    
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
        
        self.onPublish = { [weak self] post in
            self?.publishedPosts.append(post)
            print("Published post count \(String(describing: self?.publishedPosts.count))")
        }
    }
    
    deinit {
        print("Blog \(name) is the deinit")
    }
    
    func publish(post: Post) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.onPublish?(post)
            self.publishedPosts.append(post)
            print("Published post count \(String(describing: self.publishedPosts.count))")
        }
    }
    

}


class Blogger {
    let name : String
    var blog : Blog?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Blogger \(name) is the deinit")
    }
    
}

struct Post {
    let tiltle: String
    var isPublished : Bool = false
    
    init(title: String) {
        self.tiltle = title
    }
}


var blog : Blog? = Blog(name: "Naveen", url: URL(string: "https://google.com")!)
var blogger : Blogger? = Blogger(name: "Swift")

blog!.owner = blogger
blogger!.blog = blog

blog!.publish(post: Post(title: "Some title."))

blog = nil
blogger = nil


DispatchQueue.global()
DispatchQueue.main


for (key, value) in [1: "one", 2: "two"]{
  print(key, value)
}



