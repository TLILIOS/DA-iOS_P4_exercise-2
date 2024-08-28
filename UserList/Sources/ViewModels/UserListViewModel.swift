//
//  UserListViewModel.swift
//  UserList
//
//  Created by HTLILI on 04/08/2024.
//

import Foundation
import Combine
 class UserListViewModel: ObservableObject {
    //viewModel's OutPuts
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false

    
     private let repository: UserListRepository
//     var viewModel: UserListViewModel!
    init(repository: UserListRepository) {
        self.repository = repository
    }
     
    // a viewModel's input
   func fetchUsers() async {
       // Indicate loading has started
       await MainActor.run { isLoading = true}
    
            do {
                // Fetch users asynchronously
                let users = try await repository.fetchUsers(quantity: 20)
                // Update UI on main thread
                await MainActor.run {
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
                    
            } catch {
                // Handle errors on main thread
                await MainActor.run {
                    self.isLoading = false
                        print("Error fetching users: \(error.localizedDescription)")
                }
            }
    }
    // An OutPut
     func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    // A viewModel's input
   @MainActor  func reloadUsers() async {
         
        users.removeAll()
         await fetchUsers()
    }
}


