import Foundation
import PlaygroundSupport
import XCTest

PlaygroundPage.current.needsIndefiniteExecution = true

final public class EventLogger {
    public static let shared = EventLogger()
    private var queue = DispatchQueue(label: "com.event.log.main", attributes: [.initiallyInactive,.concurrent])
    private var eventFiered : [String : Any] = ["Init": "PropertyInit"]
        
    private init() {
        queue.setTarget(queue: DispatchQueue.global(qos: .background))
        queue.activate()
    }
    
    public func readLog(for key: String) -> String? {
        queue.sync {
            return eventFiered[key] as? String
        }
        
    }
    
    public func writeLog(key: String, content: Any) {
        queue.sync(flags:.barrier) {
            eventFiered[key] = content
        }
    }
}



if let content = EventLogger.shared.readLog(for: "Init") {
    print(content)
}else{
    print("File not found")
}


class MyTestClass : XCTestCase{
    func testConcurrency() {
        measure {
            let concurrentQueue = DispatchQueue(label: "com.event.log", attributes: [.concurrent])
            let expectation = expectation(description: "Concurrency Expecation")
            
            for i in 1...100 {
                concurrentQueue.async {
                    EventLogger.shared.writeLog(key: "\(i)", content: "\(i)")
                }
            }
            
            while EventLogger.shared.readLog(for: "100") != String(100) {
                
            }
            
            expectation.fulfill()
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error, "Concurrent Expecation failed.")
            }
        }
    }
}


MyTestClass.defaultTestSuite.run()
// Swift collection Array and Dict when are let they are thread safe.
// Swft collection Array and Dict when are var then they are not thread safe.


