//
//  UserListVMProtocol.swift
//  UserList
//
//  Created by HTLILI on 07/08/2024.
//

import Foundation

protocol UserListVMProtocol {
    func shouldLoadMoreData(currentItem item: User) -> Bool
    
    func reloadUsers()
}
