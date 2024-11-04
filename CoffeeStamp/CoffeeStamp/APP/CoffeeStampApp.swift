//
//  CoffeeStampApp.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import SwiftUI

@main
struct CoffeeStampApp: App {
	
	@StateObject var vm: StampViewModel = .init(provider: StampProvider.shared)
	
    var body: some Scene {
        WindowGroup {
			MainView()
			// Core Data 를 SwiftUI 에 managedObjectContext 로 넘겨줘야 coreData 를 가져옴
				.environment(\.managedObjectContext, StampProvider.shared.viewContext)
			// ViewModel 넘겨주기
				.environmentObject(vm)
        }
    }
}
