//
//  Reachability.swift
//  Marvel
//
//  Created by Hoda Elnaghy on 1/27/24.
//

import Foundation
import Reachability
import RxSwift

class ReachabilityClass {
    var isInternetConnected: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    static let shared = ReachabilityClass()
    let reachability = try! Reachability()

    private init() {
    }

    func checkConnection() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.isInternetConnected.onNext(true)
            } else {
                self.isInternetConnected.onNext(true)
            }
        }

        reachability.whenUnreachable = { _ in
            self.isInternetConnected.onNext(false)
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}

class ConnectionManager {
    static let shared = ConnectionManager()

    var isInternetConnected: Observable<Bool> {
        return ReachabilityClass.shared.isInternetConnected.asObservable()
    }

    private init() {
        ReachabilityClass.shared.checkConnection()
    }
}
