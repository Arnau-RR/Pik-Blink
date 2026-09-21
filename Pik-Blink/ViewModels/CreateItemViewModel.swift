//
//  CreateItemViewModel.swift
//  Pik-Blink
//
//  Created by Arnau on 21/09/2026.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class CreateItemViewModel: ObservableObject {
    
    @Published var pikItem = ""
    @Published var selectedTab = 0


    
//    @Published var pickItem: PikItem?
//
//    init(pickItem: PikItem) {
//        self.pickItem = pickItem
//    }
    
}
