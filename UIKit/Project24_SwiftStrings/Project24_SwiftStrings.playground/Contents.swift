import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)")
}

//Not possible print(name[3])

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

// Works, but can be slow due to the inner loop in subscript
let letter2 = name[3]

name.isEmpty // faster than count == 0





let password = "12345"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        // Convert substring to String
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

print(password.deletingPrefix("12"))
print(password.deletingSuffix("45"))





let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        //NOTE: Uppercasing a character is a string because of different languages
        return firstLetter.uppercased() + self.dropFirst()
    }
}

print(weather.capitalizedFirst)





let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
}

input.containsAny(of: languages)

// Array has a method that lets up do this
languages.contains(where: input.contains)





let str = "This is a test string"
let attributes: [NSAttributedString.Key:Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedStr = NSAttributedString(string: str, attributes: attributes)

let attributeStr = NSMutableAttributedString(string: str)
attributeStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributeStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributeStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributeStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributeStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))





//MARK: Challenge 1

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}

"pet".withPrefix("car")
"landslide".withPrefix("land")





//MARK: Challenge 2

extension String {
    var isNumeric: Bool {
        if let _ = Double(self) {
            return false
        } else {
            return true
        }
    }
}

"1.24".isNumeric
"fish".isNumeric
"25".isNumeric





//MARK: Challenge 3

extension String {
    var lines: [String] {
        return self.split(separator: "\n").map( { substr in String.init(substr) })
    }
}

"this\nis\na\ntest".lines
