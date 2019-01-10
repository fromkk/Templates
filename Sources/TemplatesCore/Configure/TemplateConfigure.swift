//
//  TemplateConfigure.swift
//  TemplatesCore
//
//  Created by Kazuya Ueoka on 2019/01/10.
//

import Foundation

public final class TemplateConfigure {
    let interactor: TemplateConfigureInteractorProtocol
    public init(interactor: TemplateConfigureInteractorProtocol) {
        self.interactor = interactor
    }
    
    public func set(_ value: String, for key: String) {
        interactor.set(value, forKey: key)
    }
    
    public func remove(_ key: String) {
        interactor.remove(key)
    }
    
    public func fetch() -> [String: String] {
        return interactor.fetch()
    }
}
