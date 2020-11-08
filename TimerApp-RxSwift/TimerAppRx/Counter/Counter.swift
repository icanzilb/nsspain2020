//
//  CountdownTimer.swift
//  TimerApp
//
//  Created by Marin Todorov on 4/5/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import RxSwift

var hasCounted = false

class Counter {
    enum Errors: LocalizedError {
        case faux
        
        var errorDescription: String? {
            return "Counter re-used, create new one instead"
        }
    }

    private var subscriptions = DisposeBag()
    private let timer = Observable<NSInteger>
        .interval(.seconds(1), scheduler: MainScheduler.instance)
        .map { counter -> Int in
            if counter == 5 {
                if !hasCounted { hasCounted = true }
                else { throw Errors.faux }
            }
            return counter
        }
        .scan(0, accumulator: { counter, _ in counter + 1 })
    
    let shared = BehaviorSubject(value: 0)
    
    init() {
        timer
            .subscribe(shared)
            .disposed(by: subscriptions)
    }
}
