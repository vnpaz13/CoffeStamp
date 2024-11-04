//
//  StampViewModel.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import Foundation
import CoreData

final class StampViewModel: ObservableObject {
	
	// MARK: - PROPERTY
	// Add, Edit, Detail 에서 사용될 Stamp
	@Published var stamp: Stamp
	@Published var isNew: Bool
	
	// MARK: - COREDATA
	let provider: StampProvider
	let context: NSManagedObjectContext
	
	init(provider: StampProvider, stamp: Stamp? = nil) {
		self.provider = provider
		self.context = provider.newContext
		
		// 현재 stamp 에 데이터가 있는 경우 edit 모드로 넘어 갈수 있게 exsist 불러오기
		if let stamp, let exsistingStamp = provider.exsist(stamp: stamp, context: context) {
			self.stamp = exsistingStamp
			self.isNew = false
		} else {
			self.stamp = Stamp(context: self.context)
			self.isNew = true
		}
		
		
		
	}
	
	// MARK: - FUNCTION
	// ADD, Edit 할때 데이터 저장
	func viewModelSave() throws {
		// contexr의 변화가 있을 경우 자기 자신을 저장하는것
		if context.hasChanges {
			try context.save()
		}
	}
}
