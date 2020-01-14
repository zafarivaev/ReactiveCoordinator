//
//  ReactiveCoordinator.swift
//  ReactiveCoordinator
//
//  Created by Zafar on 1/14/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import RxSwift

open class ReactiveCoordinator<ResultType>: NSObject {

    public typealias CoordinationResult = ResultType

    public let disposeBag = DisposeBag()
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()

    private func store<T>(coordinator: ReactiveCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func release<T>(coordinator: ReactiveCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    @discardableResult
    open func coordinate<T>(to coordinator: ReactiveCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.release(coordinator: coordinator) })
    }

    open func start() -> Observable<ResultType> {
        fatalError("start() method must be implemented")
    }
}
