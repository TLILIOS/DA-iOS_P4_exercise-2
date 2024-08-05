//
//  ViewModelTests.swift
//  ViewModelTests
//
//  Created by HTLILI on 05/08/2024.
//

import XCTest
@testable import UserList

final class ViewModelTests: XCTestCase {
    // Happy path test case
    func testSuccessfulShouldLoadMoreData() {
        
        //Given(Arrenge)
        let users = [User]()
        let isLoading = false
        let item = users.last!
       let userListViewModel = UserListViewModel()
        //When(Act)
        let moreData = userListViewModel.shouldLoadMoreData(currentItem: item)
        
        //Then(Assert)
        XCTAssert(true)
    }
    
}
