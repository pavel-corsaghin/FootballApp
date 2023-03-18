//
//  NavigationRouter.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

final class NavigationRouter: NSObject, Router {
    
    // MARK: - Properties
    
    let rootController: UINavigationController
    private var completions: [UIViewController: () -> Void] = [:]
    private var transition: UIViewControllerAnimatedTransitioning?
    
    // MARK: - Initializer
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init()
        self.rootController.delegate = self
    }
    
    override init() {
        rootController = UINavigationController()
        super.init()
        rootController.delegate = self
    }
    
    // MARK: - Presentable
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    // MARK: - Router
    
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController.present(controller, animated: animated, completion: nil)
    }
    
    func present(router: Router) {
        present(router.rootController, animated: true)
    }
    
    func push(_ module: Presentable?) {
        push(module, transition: nil)
    }
    
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?) {
        push(module, transition: transition, animated: true)
    }
    
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        push(module, transition: transition, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: (() -> Void)?) {
        self.transition = transition
        
        guard let controller = module?.toPresent() else { return }
        guard (controller is UINavigationController) == false else {
            assertionFailure("Deprecated push UINavigationController")
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        rootController.pushViewController(controller, animated: animated)
    }
    
    func popModule() {
        popModule(transition: nil)
    }
    
    func popModule(transition: UIViewControllerAnimatedTransitioning?) {
        popModule(transition: transition, animated: true)
    }
    
    func popModule(transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        self.transition = transition
        guard let controller = rootController.popViewController(animated: animated) else { return }
        runCompletion(for: controller)
    }
    
    func popToModule(module: Presentable?, animated: Bool) {
        guard let module = module else { return }
        let controllers = rootController.viewControllers
        for controller in controllers where controller == module as? UIViewController {
            rootController.popToViewController(controller, animated: animated)
        }
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController.setViewControllers([controller], animated: false)
        rootController.navigationBar.isHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        guard let controllers = rootController.popToRootViewController(animated: animated) else { return }
        controllers.forEach { controller in
            runCompletion(for: controller)
        }
    }
    
    // MARK: - Helpers
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension NavigationRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(previousController) else {
            return
        }
        
        runCompletion(for: previousController)
    }
}
