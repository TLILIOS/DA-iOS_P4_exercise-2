//
//  UserListViewModel.swift
//  UserList
//
//  Created by HTLILI on 04/08/2024.
//

import Foundation
final class UserListViewModel: ObservableObject {
    // TODO: - Those properties should be viewModel's OutPuts
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false

    // TODO: - The property should be declared in the viewModel
     let repository = UserListRepository()
    // TODO: - Should be a viewModel's input
     func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                self.users.append(contentsOf: users)
                isLoading = false
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }

    // TODO: - Should be an OutPut
     func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    // TODO: - Should be a viewModel's input
     func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
    
}
