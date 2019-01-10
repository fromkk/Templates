//
//  TemplateConfigureInterfaces.swift
//  TemplatesCore
//
//  Created by Kazuya Ueoka on 2019/01/10.
//

import Foundation

public protocol TemplateConfigureInteractorProtocol {
    func set(_ value: String, forKey key: String)
    func remove(_ key: String)
    func fetch() -> [String: String]
}
