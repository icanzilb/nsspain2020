//
//  CountdownTimer.swift
//  TimerApp
//
//  Created by Marin Todorov on 4/5/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import Combine

var hasCounted = false

class Counter {
    enum Errors: LocalizedError {
        case faux
        
        var errorDescription: String? {
            return "Counter re-used, create new one instead"
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private let timer = Timer
        .publish(every: 1, on: RunLoop.main, in: .common)
        .autoconnect()
        .scan(0, { counter, _ in
            return counter + 1
        })
        .setFailureType(to: Counter.Errors.self)
        .tryMap { counter -> Int in
            if counter == 5 {
                if !hasCounted { hasCounted = true }
                else { throw Errors.faux }
            }
            return counter
        }
        .eraseToAnyPublisher()
    
    let shared = CurrentValueSubject<Int, Error>(0)
    
    init() {
        timer
            .subscribe(shared)
            .store(in: &subscriptions)
    }
}
