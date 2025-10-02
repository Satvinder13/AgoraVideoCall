//
//  ForLoopVC.swift
//  Agora Demo
//
//  Created by iOS Team on 31/07/25.
//

import UIKit

class ForLoopVC: UIViewController {

    var arr = [1,2,5,4,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tapShowOutputBtn(_ sender: UIButton) {
        //MARK: - SUM
        //        var sum = 0
        //        for number in arr {
        //            sum += number
        //        }
        //        print("\(sum)")
        //                  OR
        //        var sum = 0
        //        arr.forEach { (number) in
        //            sum += number
        //        }
        
        //MARK: - REVERSE
        //        var reverseArr : [Int] = []
        //        reverseArr = arr.reversed()
        
        //        var reverseArr : [Int] = []
        //        for num in arr.reversed() {
        //            reverseArr.append(num)
        //        }
        //        print(reverseArr)
        
        //        var largestNumber = arr[0]
        //        for m in arr{
        //            if m > largestNumber{
        //                largestNumber = m
        //            }
        //        }
        //        print(largestNumber)
        
//        func reverseString(_ input: String) -> String {
//            var reverseString = ""
//            for reverseStringCharacter in input {
//                reverseString = String(reverseStringCharacter) + reverseString
//            }
//            return reverseString
//        }

//        func checkPalindrome(word: String) -> Bool {
//            let arrString = Array(word.lowercased().filter{$0.isLetter || $0.isNumber})
//            for index in 0..<arrString.count/2{
//                if arrString[index] != arrString[arrString.count - index - 1]{
//                    return false
//                }
//            }
//            return true
//        }
        
//        func checkLongestCommonPrefix(strings: [String]?) -> String {
//            guard let strings = strings else {
//                return ""
//            }
//            
//            guard strings.count > 0 else {
//                return ""
//            }
//            
//            var longestCommonPrefix = strings[0]
//            for string in strings[1...] {
//                while !string.hasPrefix(longestCommonPrefix) {
//                    if longestCommonPrefix.isEmpty {
//                        return ""
//                    }
//                    longestCommonPrefix = String(longestCommonPrefix.dropLast())
//                }
//            }
//            return longestCommonPrefix
//        }
        
        //        func swap<u>(a: inout u, b: inout u) {
        //            (a, b) = (b, a)
        //        }
        //        var h = "10"
        //        var k = "11"
        //        swap(a: &h, b: &k)
        //        print(h,k)
        
        //        var a = 11
        //        var b = 10
        //        a = a + b
        //        b = a - b
        //        a = a - b
        //        print(a,b)
        
        //        for primeNumber in 2...53{
        //            var isPrimeNumber = true
        //            for i in 2..<primeNumber{
        //                if primeNumber % i == 0{
        //                    isPrimeNumber = false
        //                    break
        //                }
        //            }
        //            if isPrimeNumber{
        //                print(primeNumber)
        //            }
        //        }
        
        //        let number = 9
        //        for i in 1...10 {
        //            print("\(number) * \(i) = \(number * i)")
        //        }
        
//        let a = [3,4,3,4,5,1,2,1,2,2,2]
//        for i in 0..<a.count{
//            var appearSingleTime = true
//            for j in 0..<a.count{
//                if i != j && a[i] == a[j]{
//                    appearSingleTime = false
//                    break
//                }
//            }
//            if appearSingleTime{
//                print(a[i], i)
//            }
//        }
        
//        let lb = Int(pow(2.0, 31)) * -1
//        let up = Int(pow(2.0, 31)) * 1
//        let string = String(x).replacingOccurrences(of: "0+$", with: "", options: .regularExpression)
//        let array = Array(string)
//        var arr : String = ""
//        for char in array{
//            if char != "-"{
//                arr = String(char) + arr
//            }
//        }
//        if x < 0{
//            arr = "-" + arr
//        }
//        guard Int(arr) ?? 0 < up || Int(arr) ?? 0 > lb else {
//            return 0
//        }
//        return Int(arr) ?? 0
        
    }
}
