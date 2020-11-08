//
//  ValueLog.swift
//  CustomInstrument2
//
//  Created by Marin Todorov on 10/27/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import TimelaneCore

@propertyWrapper
public class ValueLog<Value: CustomStringConvertible> {
    @Published private var value: Value
    let subscription: Timelane.Subscription

    public var wrappedValue: Value {
        get { self.value }
        set {
            self.value = newValue
            self.subscription.event(value: .value("\(newValue)"))
        }
    }
    
    public init(wrappedValue: Value, name: String) {
        self.value = wrappedValue
        self.subscription = Timelane.Subscription(name: name)
    }
}
