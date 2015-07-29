import UIKit


extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}


extension String {
    var isOperator: Bool {
        get {
            return ("+ - / * ^ %" as NSString).containsString(self)
        }
    }
    var isNumber: Bool {
        get {
            if let _ = Double(self) { return true }
            return false
        }
    }
    var precedence: Int {
        get {
            switch self {
            case "/":
                return 1
            case "*":
                return 1
            case "%":
                return 1
            case "+":
                return 2
            case "-":
                return 2
            case "^":
                return 0
            default:
                return -1
            }
        }
    }
}

class Stack {
    
    var selfvalue: [String] = []
    var peek: String {
        get {
            if selfvalue.count != 0 {
                return selfvalue[selfvalue.count-1]
            } else {
                return ""
            }
        }
    }
    var empty: Bool {
        get {
            return selfvalue.count == 0
        }
    }
    
    func push(value: String) {
        selfvalue.append(value)
    }
    
    func pop() -> String {
        var temp = String()
        if selfvalue.count != 0 {
            temp = selfvalue[selfvalue.count-1]
            selfvalue.removeAtIndex(selfvalue.count-1)
        } else if selfvalue.count == 0 {
            temp = ""
        }
        return temp
    }
    
}

class MathParser {
    
    var outputQueue: [String] = []
    var stack: Stack = Stack()
    
    func parse(var tokens: String) -> Double {
        if (tokens as NSString).containsString("(") {
            var finalToks = ""
            var isTakingChars = false
            for i in tokens.characters {
                if i == ")" {
                    finalToks += "\(i)"
                    isTakingChars = false
                }
                if isTakingChars {
                    finalToks += "\(i)"
                }
                if i == "(" {
                    if finalToks != "" {
                        finalToks += "$"
                    }
                    finalToks += "\(i)"
                    isTakingChars = true
                }
            }
            for i in finalToks.componentsSeparatedByString("$") {
                var bracketOpen = "("
                var bracketClose = ")"
                var hand = MathParser()
                tokens = tokens.stringByReplacingOccurrencesOfString(i, withString: "\(hand.parse(i.stringByReplacingOccurrencesOfString(bracketClose, withString: String()).stringByReplacingOccurrencesOfString(bracketOpen, withString: String())))")
            }
        }
        var toksArr = tokens.componentsSeparatedByString(" ")
        for token in toksArr {
            if token.isOperator {
                if stack.selfvalue.count != 0 {
                    for (var i = 0; i <= stack.selfvalue.count; i++) {
                        if stack.selfvalue.count != 0 {
                            if stack.peek.precedence <= token.precedence {
                                outputQueue.append(stack.pop())
                            }
                        }
                    }
                }
                stack.push(token)
            }
            if token.isNumber {
                outputQueue.append(token)
            }
        }
        while !stack.empty {
            outputQueue.append(stack.pop())
        }
        var newStack = Stack()
        for token in outputQueue {
            if token.isNumber {
                newStack.push(token)
            } else {
                var n1 = Double()
                var n2 = Double()
                if let _ = Double(newStack.peek) {
                    n1 = Double(newStack.pop())!
                    if let _ = Double(newStack.peek) {
                        n2 = Double(newStack.pop())!
                    }
                }
                
                var result = token == "+" ? n1 + n2 : token == "-" ? n2 - n1 : token == "*" ? n1 * n2 : token == "/" ? n2 / n1 : token == "^" ? power(n2, num2: n1) : token == "%" ? n2 % n1 : 0
                
                newStack.push("\(result)")
            }
        }
        return Double(newStack.pop())!
        return 0.0
    }
    
    func power(var num1: Double, num2: Double) -> Double {
        num1
        num2
        if num2 == 0 {
            return 1 * num1 < 0 ? -1 : 1
        }
        var result = num1
        var ans = 1, sign = 1
        if num1 < 0 {
            sign = -1
            num1 = Double(sign) * num1
        }
        if num2 > 1 {
            for i in 1...Int(num2) {
                ans *= Int(num1)
            }
        }
        sign
        ans
        result = Double(sign) * Double(ans)
        return result
    }
    
}

var math: MathParser = MathParser()
var equ = "5 - 2"
math.parse(equ)
math.outputQueue
