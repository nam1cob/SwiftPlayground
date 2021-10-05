import UIKit
import Foundation


class BST
{
    var value: Int?
    var left: BST?
    var right: BST?

    init(value: Int) {
        self.value = value
        left = nil
        right = nil
    }
}




func inOrderTraversal(tree: BST?, array: inout [Int]) -> [Int] {
}


func sortedSquaredArray(_ array: [Int]) -> [Int] {
    
    var result = Array.init(repeating: 0, count: array.count)
    
    var smallIdx = 0
    var largeIdx = array.count - 1
    
    
    for _ in stride(from: array.count - 1, through:  0, by:  -1 ) {
        let smallIdxValue = array[smallIdx]
        let largetIdxValue = array[largeIdx]
        
        if abs(smallIdxValue) < abs(largetIdxValue){
            result[smallIdx] = smallIdxValue * smallIdxValue
            smallIdx += 1
        }else{
            result[smallIdx] = largetIdxValue * largetIdxValue
            largeIdx -= 1
        }
    }
    return result
    
    
    
}


