//
//  KeychainPublishedWrapper.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 7/4/21.
//

import Combine
import Foundation

private var cancellableSet: Set<AnyCancellable> = []

extension Published where Value: Codable {
    init(wrappedValue defaultValue: Value, keychain: String) {
        if let data = KeychainWrapper.standard.data(forKey: keychain) {
            do {
                let value = try JSONDecoder().decode(Value.self, from: data)
                self.init(initialValue: value)
            } catch {
                #if DEBUG
                print("Error while decoding data")
                #endif
                self.init(initialValue: defaultValue)
            }
        } else {
            self.init(initialValue: defaultValue)
        }

        projectedValue
            .sink { val in
                do { 
                    let data = try JSONEncoder().encode(val)
                    KeychainWrapper.standard.set(data, forKey: keychain)
                } catch {
                    #if DEBUG
                    print("Error while decoding data")
                    #endif
                }
            }
            .store(in: &cancellableSet)
    }
}
