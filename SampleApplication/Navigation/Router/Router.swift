//
//  Router.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

protocol Router: Presentable {

    var rootController: UINavigationController { get }

    func present(router: Router)
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?)
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: (() -> Void)?)

    func popModule()
    func popModule(transition: UIViewControllerAnimatedTransitioning?)
    func popModule(transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    func popToModule(module: Presentable?, animated: Bool)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)

    func popToRootModule(animated: Bool)
}
