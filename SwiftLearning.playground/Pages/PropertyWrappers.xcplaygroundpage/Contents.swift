import Foundation

var greeting = "Hello, playground"

// Limiation of property wrapper
// 1. do not have throw fucntion
// 2. composition of the wrapped value is a limitation of swift.
@propertyWrapper
struct UserDefaultWrapper<Value> {
    private let key: String
    private let storage: UserDefaults
    private let defaultValue : Value

    init(wrappedValue defaultValue:Value,
        key: String,
        storage: UserDefaults = .standard){
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
    
    var wrappedValue : Value? {
        get { storage.value(forKey: key) as? Value }
        set { storage.setValue(newValue, forKey: key) }
    }
}

extension UserDefaults {
    static var shared: UserDefaults {
        let combined = UserDefaults.standard
        combined.addSuite(named: "group.johnsundell.app")
        return combined
    }
}


struct SettingViewModel {
    @UserDefaultWrapper<Bool>(key: "markMessage")
    var autoMarkMessageRead = true
    
    @UserDefaultWrapper<Int>(key: "sizeOfSearchResult")
    var sizeOfSearchResult = 1
}


var vm = SettingViewModel()
vm.autoMarkMessageRead = true
vm.sizeOfSearchResult = 1

