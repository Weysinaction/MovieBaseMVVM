// Router.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(film: MoviesManagedObjects?)
    func popToRoot()
}

/// Router-
class Router: RouterProtocol {
    var navigationController: UINavigationController?

    var assemblyBuilder: AssemblyBuilderProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMain(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }

    func showDetail(film: MoviesManagedObjects?) {
        if let navigationController = navigationController {
            guard let film = film,
                  let detailViewController = assemblyBuilder?.createDetail(router: self, film: film) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
