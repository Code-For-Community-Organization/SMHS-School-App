//
//  UserDefaultWrapper.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import Foundation
import Combine

private var cancellableSet: Set<AnyCancellable> = []

extension Published where Value: Codable {
    init(wrappedValue defaultValue: Value, key: String) {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "inf.", negativeInfinity: "-inf.", nan: "N/A")
                let value = try decoder.decode(Value.self, from: data)
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
                    let encoder = JSONEncoder()
                    encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "inf.", negativeInfinity: "-inf.", nan: "N/A")
                    let data = try encoder.encode(val)
                    UserDefaults.standard.set(data, forKey: key)
                } catch {
                    #if DEBUG
                    print("Error while decoding data: \(error)")
                    #endif
                }
            }
            .store(in: &cancellableSet)
    }
}

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
