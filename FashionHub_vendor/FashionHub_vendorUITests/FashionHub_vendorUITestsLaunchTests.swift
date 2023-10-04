//
//  FashionHub_vendorUITestsLaunchTests.swift
//  FashionHub_vendorUITests
//
//  Created by DREAMWORLD on 10/02/23.
//

import XCTest

class FashionHub_vendorUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
