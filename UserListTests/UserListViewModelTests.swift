//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by HTLILI on 19/08/2024.
//
import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {
    var viewModel: UserListViewModel!
    var mockRepository: UserListRepository!
    
    override func setUp() async throws {
        try await super.setUp()
        // Initialize the mock repository and ViewModel before each test
        mockRepository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
        viewModel = UserListViewModel(repository: mockRepository)
    }
    override func tearDown() async throws {
        viewModel = nil
        mockRepository = nil
        try await super.tearDown()
    }
    
    //     Test pour vérifier que les utilisateurs sont correctement chargés
    func testFetchUsersSuccess() async throws {
        // Happy path test case:

        // When
        await viewModel.fetchUsers()
        
        // Then
        
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users[0].name.first, "John")
        XCTAssertEqual(viewModel.users[0].name.last, "Doe")
        XCTAssertEqual(viewModel.users[1].name.first, "Jane")
        XCTAssertEqual(viewModel.users[1].name.last, "Smith")
        
    }
    
    // Test for handling fetch error
    func testFetchUsersFailure() async throws {
        // Given
         mockRepository = UserListRepository(executeDataRequest: mockExecuteDataRequestFailure(_:))
         viewModel = UserListViewModel(repository: mockRepository)
        
        // When
        await viewModel.fetchUsers()
        
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    // Test pour vérifier le rechargement des utilisateurs
    func testReloadUsers() async throws {
        // Charger initialement les utilisateurs
        await viewModel.fetchUsers()
        
        // When
        await viewModel.reloadUsers()
        
        // Then
        XCTAssertEqual(viewModel.users.count, 2)  // Doit être 2 car les mêmes utilisateurs sont chargés à nouveau
        XCTAssertEqual(viewModel.users[0].name.first, "John")
        XCTAssertEqual(viewModel.users[0].name.last, "Doe")
    }
    
    func testShouldLoadMoreData() async throws {
        // Charger initialement les utilisateurs
        await viewModel.fetchUsers()
        
        guard let lastUser = viewModel.users.last else {
            XCTFail("Last user should exist")
            return
        }
        
        // When
        let shouldLoadMore = await viewModel.shouldLoadMoreData(currentItem: lastUser)
        
        // Then
        XCTAssertTrue(shouldLoadMore)
    }
    
    // Mock de la fonction executeDataRequest
    private func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Utilisation de la même réponse JSON simulée que dans les tests de repository
        let sampleJSON = """
            {
                "results": [
                    {
                        "name": {
                            "title": "Mr",
                            "first": "John",
                            "last": "Doe"
                        },
                        "dob": {
                            "date": "1990-01-01",
                            "age": 31
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    },
                    {
                        "name": {
                            "title": "Ms",
                            "first": "Jane",
                            "last": "Smith"
                        },
                        "dob": {
                            "date": "1995-02-15",
                            "age": 26
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    }
                ]
            }
        """
        
        let data = sampleJSON.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
    
    private func mockExecuteDataRequestFailure(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Simulate a network error by throwing an error
        throw URLError(.badServerResponse)
    }
}

