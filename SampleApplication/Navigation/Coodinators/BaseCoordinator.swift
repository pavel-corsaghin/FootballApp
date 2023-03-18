//
//  BaseCoordinator.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

/// The base class of Coordinators. Provides default implementations for adding/removing coordinators.
class BaseCoordinator: Coordinator {

    // MARK: - Properties
    
    let coordinatorFactory: CoordinatorFactoryProtocol = CoordinatorFactory()

    private(set) var childCoordinators: [Coordinator] = []

    // MARK: - Coordinator

    /// Takes a coordinator and adds it as a child to the calling coordinator
    ///
    /// - Parameters:
    ///     - coordinator: The coordinator to be added as a child
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }

    /// Takes a coordinator and removes it as a child to the calling coordinator
    ///
    /// - Parameters:
    ///     - coordinator: The coordinator to be removed as a child
    func removeDependency(_ coordinator: Coordinator?) {
        guard !childCoordinators.isEmpty else { return }
        guard let coordinator = coordinator else { return }

        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter { $0 !== coordinator }
                .forEach { coordinator.removeDependency($0) }
        }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    /// Activates the coordinator to start managing its navigation
    func start() {
        fatalError("Child coordinator should implement")
    }
}
