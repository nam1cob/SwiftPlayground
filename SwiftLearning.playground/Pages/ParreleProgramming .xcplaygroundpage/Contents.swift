

import Foundation
import PlaygroundSupport
import XCTest

PlaygroundPage.current.needsIndefiniteExecution = true

// Dispatch Semaphore
let concurrentQueue = DispatchQueue(label: "com.concurrent.queue", attributes: [.concurrent])
let semaphore = DispatchSemaphore(value: 1)

var value = 1
for i in 0...4 {
    concurrentQueue.async {
        print("\(i) waiting")
        semaphore.wait() // -1
        sleep(1)
        value = i
        print("\(value) finished")
        semaphore.signal() // +1
        
    }
}

// Dispatch Barrier
//var value = 0
//let concurrentQueue = DispatchQueue(label: "com.queue.concurrent", attributes: [.concurrent,.initiallyInactive])
//concurrentQueue.setTarget(queue: DispatchQueue.global(qos: .background))
//concurrentQueue.activate()
//concurrentQueue.async {
//    for i in 0...4 {
//        value = i
//        print(value)
//    }
//}
//
//concurrentQueue.async(group: nil, qos: DispatchQoS.background, flags: .barrier) {
//    for i in 5...9 {
//        value = i
//        print(value)
//    }
//
//}
//
//
//concurrentQueue.async {
//    for i in 10...14 {
//        value = i
//        print(value)
//    }
//}


// Dispatch work item
//let concurrentQueue = DispatchQueue(label: "com.queue.concurent")
//
////func perfromAsyncTaskWithConcurrentWorkItem() {
//var number = 1
//let workItem = DispatchWorkItem() {
//    print("Task \(number) Started")
//    for _ in 0...4 {
//        Thread.sleep(forTimeInterval: TimeInterval(1))
//    }
//    print("Task \(number) Ended")
//}
//
//concurrentQueue.async(execute: workItem)
//concurrentQueue.asyncAfter(deadline: DispatchTime.now() + 1, execute: workItem)
////workItem.cancel()
//
//concurrentQueue.async(execute: workItem)
//if workItem.isCancelled {
//    print("Cancelled")
//}


// Dispatch Group
//var concurrentQueue = DispatchQueue(label: "com.queue.concurrent", attributes: [.concurrent])
//func longRunningTask(with completion: @escaping () -> Void) {
//    let group = DispatchGroup()
//    group.enter()
//    concurrentQueue.async {
//        print("Task 1 Started")
//        for _ in 1...4 {
//            Thread.sleep(forTimeInterval: TimeInterval.init(1))
//            //print(i)
//        }
//        print("Task 1 Ended")
//        group.leave()
//    }
//
//    group.enter()
//    concurrentQueue.async {
//        print("Task 2 Started")
//        for _ in 5...10 {
//            Thread.sleep(forTimeInterval: TimeInterval.init(1))
//            //print(i)
//        }
//        print("Task 2 Ended")
//        group.leave()
//    }
//    group.wait()
//    completion()
//}
//
//longRunningTask {
//    print("Completed")
//}




// Target Queue
//var serial = DispatchQueue(label: "com.queue.Serial",attributes: .concurrent)
//
//
//var value: Int = 2
//
//extension DispatchQueue {
//    static var currentLable : String? {
//        let name = __dispatch_queue_get_label(nil)
//        return String(cString: name, encoding: .utf8)
//    }
//
//}
//
//
//let serialQueue = DispatchQueue(label: "serialQueue")
//let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: [.initiallyInactive, .concurrent])
//concurrentQueue.setTarget(queue: serialQueue)
//concurrentQueue.activate()
//
//// Setting traget queue after on an activated queue will result in compiler error.
//// Target queue must be set before the activation
//
//
//
//concurrentQueue.async {
//    DispatchQueue.currentLable
//    for j in 0...4 {
//        value = j
//        print("\(value) ✡️")
//    }
//}
//
//
//concurrentQueue.async {
//    DispatchQueue.currentLable
//    for j in 5...7 {
//        value = j
//        print("\(value) ✴️")
//    }
//}







//
//func doSomeLongRunningOperation() {
//    for _ in 1...10 {
//        serial.sync {
//            let mainThread = Thread.isMainThread ? "YES" : "NO"
//
//            var k = 0
//            for j in 1...20000 {
//               k += j
//            }
//            print("Task 1 is finised. On main thread : \(mainThread)")
//        }
//    }
//    print("Task 1 async started")
//}
//
//
//doSomeLongRunningOperation()
//
//serial.async {
//    for _ in 1...10 {
//        serial.async {
//            let mainThread = Thread.isMainThread ? "YES" : "NO"
//
//            var k = 0
//            for j in 1...10000 {
//                k += j
//            }
//            print("Task 2 is finised. On main thread : \(mainThread)")
//        }
//    }
//    print("Task 2 async started")
//}
//
//print("Start of Serial async opeation")
//
//var greeting = "Hello, playground"
//
//var value: Int = 2
//
//DispatchQueue.main.async {
//    for i in 1...5000{
//        value = i
//        print("\(value) 🎉")
//    }
//}
//
//
//DispatchQueue.main.async {
//    for i in 5001...10000 {
//        value = i
//        print("\(value) 🎈")
//    }
//}



