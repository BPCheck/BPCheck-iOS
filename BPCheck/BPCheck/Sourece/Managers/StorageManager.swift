//
//  StorageManager.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/31.
//

import Foundation
import Security

class StoregaeManager {
    
    static let shared = StoregaeManager()
    
    private let account = "BPCheck"
    private let service = Bundle.main.bundleIdentifier
    
    let keyChainQuery: NSDictionary = [
        kSecClass : kSecClassGenericPassword,
        kSecAttrService : Bundle.main.bundleIdentifier ?? "default",
        kSecAttrAccount : "BPCheck"
    ]
    
    func create(_ user: Token) -> Bool {
        guard let data = try? JSONEncoder().encode(user) else { return false }
        
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service!,
            kSecAttrAccount : account,
            kSecValueData : data
        ]
        
        SecItemDelete(keyChainQuery)
        
        return SecItemAdd(keyChainQuery, nil) == errSecSuccess
    }
    
    func read() -> Token? {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service!,
            kSecAttrAccount : account,
            kSecReturnData : kCFBooleanTrue!,
            kSecMatchLimit : kSecMatchLimitOne
        ]
        
        var dataTypeRef: CFTypeRef?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = try? JSONDecoder().decode(Token.self, from: retrievedData)
            return value
        }else {
            return nil
        }
    }
    
    func delete() -> Bool {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service!,
            kSecAttrAccount : account
        ]
        
        return SecItemDelete(keyChainQuery) == noErr
    }
    
}
