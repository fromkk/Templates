//
//  TemplateConfigureInteractor.swift
//  TemplatesCore
//
//  Created by Kazuya Ueoka on 2019/01/10.
//

import Foundation

public final class TemplateConfigureInteractor: TemplateConfigureInteractorProtocol {
    let prefix: String = "me.fromkk.Templates."
    let userDefaults: UserDefaults = UserDefaults.standard
    
    public init() {}
    
    public func set(_ value: String, forKey key: String) {
        userDefaults.set(value, forKey: prefix + key)
    }
    
    public func remove(_ key: String) {
        userDefaults.removeObject(forKey: prefix + key)
    }
    
    public func fetch() -> [String : String] {
        let dict = userDefaults.dictionaryRepresentation()
        var result: [String: String] = [:]
        dict.forEach { (item) in
            guard item.key.hasPrefix(prefix), let value = item.value as? String else { return }
            let key = item.key.replacingOccurrences(of: prefix, with: "")
            result[key] = value
        }
        return result
    }
    
    
}
