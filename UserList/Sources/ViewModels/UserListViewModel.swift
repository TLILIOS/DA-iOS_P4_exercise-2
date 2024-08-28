//
//  UserListViewModel.swift
//  UserList
//
//  Created by HTLILI on 04/08/2024.
//

import Foundation
import Combine
class UserListViewModel: ObservableObject {
    //ViewModel's OutPuts
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isGridView = false
    
    private let repository: UserListRepository
    
    init(repository: UserListRepository) {
        self.repository = repository
    }
    
    @MainActor  func fetchUsers() async {
        // Indicate loading has started
        isLoading = true
        
        do  {
            // Fetch users asynchronously
            let users = try await repository.fetchUsers(quantity: 20)
            // Update UI on main thread
            self.users.append(contentsOf: users)
            
        } catch {
            // Handle errors on main thread
            print("Error fetching users: \(error.localizedDescription)")
        }
        self.isLoading = false
    }
    
    @MainActor func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    @MainActor  func reloadUsers() async {
        users.removeAll()
        await fetchUsers()
    }
}


