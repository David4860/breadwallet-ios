// 
//  PayIdTests.swift
//  breadwalletTests
//
//  Created by Adrian Corscadden on 2020-04-28.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
import XCTest
@testable import breadwallet

class PayIdTests : XCTestCase {
    
    func testPaymentPathInit() {
        XCTAssertNotNil(PaymentPath(address: "GiveDirectly$payid.charity"))
        XCTAssertNotNil(PaymentPath(address: "test5$payid.test.coinselect.com"))
        XCTAssertNotNil(PaymentPath(address: "reza$payid.test.coinselect.com"))
        XCTAssertNotNil(PaymentPath(address: "pay$wietse.com"))
        XCTAssertNotNil(PaymentPath(address: "john.smith$dev.payid.es"))
        XCTAssertNotNil(PaymentPath(address: "pay$zochow.ski"))
        
        XCTAssertNil(PaymentPath(address: ""))
        XCTAssertNil(PaymentPath(address: "test5payid.test.coinselect.com"))
        XCTAssertNil(PaymentPath(address: "payid.test.coinselect.com"))
        XCTAssertNil(PaymentPath(address: "rAPERVgXZavGgiGv6xBgtiZurirW2yAmY"))
        XCTAssertNil(PaymentPath(address: "unknown"))
        XCTAssertNil(PaymentPath(address: "0x2c4d5626b6559927350db12e50143e2e8b1b9951"))
    }
    
    func testBTC() {
        let path = PaymentPath(address: "adrian$stage2.breadwallet.com/payid/")
        XCTAssertNotNil(path)
        let exp = expectation(description: "Fetch PayId address")
        path?.fetchAddress(forCurrency: TestCurrencies.btc) { result in
            self.handleResult(result, expected: "mzVtspCQoEGnEbCUWVrug72yD4ShDTUbw8")
            exp.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testEth() {
        let path = PaymentPath(address: "adrian$stage2.breadwallet.com/payid/")
        XCTAssertNotNil(path)
        let exp = expectation(description: "Fetch PayId address")
        path?.fetchAddress(forCurrency: TestCurrencies.eth) { result in
            self.handleResult(result, expected: "0x8fB4CB96F7C15F9C39B3854595733F728E1963Bc")
            exp.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testUnsuportedCurrency() {
        let path = PaymentPath(address: "adrian$stage2.breadwallet.com/payid/")
        XCTAssertNotNil(path)
        let exp = expectation(description: "Fetch PayId address")
        path?.fetchAddress(forCurrency: TestCurrencies.bch) { address in
            switch address {
            case .success(_):
                XCTFail("BCH should not return a payID")
            case .failure(let error):
                XCTAssert(error == .currencyNotSupported, "Should return currency not supported error")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func handleResult(_ result: Result<String, PayIdError>, expected: String) {
        switch result {
        case .success(let address):
            XCTAssertTrue(address == expected)
        case .failure(let error):
            XCTFail("message: \(error)")
        }
    }

}
