//
//  ConentViewModel.swift
//  TimerApp
//
//  Created by Marin Todorov on 4/5/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import CoreGraphics
import RxSwift
import RxTimelane

/// Provides timer bindings for the timer view.
class TimerViewModel: ObservableObject {
    private var subscriptions = DisposeBag()
    private var counter: Counter!

    var totalTime: Int
    init(totalTime: Int) {
        self.totalTime = totalTime
    }

    // MARK: - Model outputs

    @Published var countdown = ""
    @Published var progress = CGFloat(0.0)

    // MARK: - Model actions

    func activate(time: Int? = nil) {
        // Fixing loose subscriptions issue
        subscriptions = DisposeBag()
        
        let totalTime = time ?? self.totalTime

        counter = Counter()
        
        // Counter label
        counter.shared
            .filter { $0 % 2 == 0 }
            .map { "\(totalTime - $0)s" }
            .lane("Countdown")
            .subscribe(onNext: { self.countdown = $0 })
            .disposed(by: subscriptions)

        // Progress bar
        counter.shared
            .map { 1.0 - CGFloat($0) / CGFloat(totalTime)}
            .lane("Progress", filter: [.event])
            .subscribe(onNext: { self.progress = $0 })
            .disposed(by: subscriptions)

        // Util
        counter.shared
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: {
                    if totalTime < $0 {
                        self.counter.shared.on(.completed)
                    }
                },
                onError: { _ in
                    self.countdown = ""
                    self.progress = 0.0
                },
                onCompleted: {
                    self.countdown = ""
                })
            .disposed(by: subscriptions)
    }
}
