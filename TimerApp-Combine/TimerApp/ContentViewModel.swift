//
//  ConentViewModel.swift
//  TimerApp
//
//  Created by Marin Todorov on 4/5/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import CoreGraphics
import Combine
import TimelaneCombine

class ContentViewModel: ObservableObject {
    private let totalTime: Int
    private var subscriptions = Set<AnyCancellable>()
    private var counter: Counter!

    init(totalTime: Int) {
        self.totalTime = totalTime
    }

    // Model outputs
    @Published var countdown = ""
    @Published var progress = CGFloat(0.0)

    func activate() {
        subscriptions.removeAll()
        counter = Counter()
        
        // Counter label
        counter.shared
            .filter { $0 % 2 == 0 }
            .map { "\(self.totalTime - $0)s" }
            .lane("Countdown")
            .replaceError(with: "")
            .assign(to: \.countdown, on: self)
            .store(in: &subscriptions)

        // Progress bar
        counter.shared
            .map { 1.0 - CGFloat($0) / CGFloat(self.totalTime)}
            .lane("Progress", filter: [.event])
            .replaceError(with: 0)
            .assign(to: \.progress, on: self)
            .store(in: &subscriptions)
        
        // Util
        counter.shared
            .sink(receiveCompletion: { _ in
                self.countdown = ""
                self.progress = 0.0
            }) { value in
                if self.totalTime <= value {
                    self.counter.shared.send(completion: .finished)
                }
            }
            .store(in: &subscriptions)
    }
}
