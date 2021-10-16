// RouterTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MovieBase
import XCTest

/// MockNavigationController-
class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

/// RouterTest-
class RouterTest: XCTestCase {
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    let assembly = AssemblyModel()

    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
        router.initialViewController()
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testRouter() {
        router.showDetail(film: nil)
        let detailVC = navigationController.presentedVC
        XCTAssertTrue(detailVC is ViewController)
    }
}
