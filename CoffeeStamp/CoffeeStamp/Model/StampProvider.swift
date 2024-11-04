//
//  StampProvider.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

// CoreData 에서 ViewContext 내용을 가져오기 위한 singleton instance 생성을 위한 class
import Foundation
import CoreData

class StampProvider {
	
	// singleton instance 선언
	static let shared = StampProvider()
	
	// Container
	private let container: NSPersistentContainer
	
	// ViewContex
	var viewContext: NSManagedObjectContext {
		container.viewContext
	}
	
	// Add Stamp context 추가하는 computed property
	var newContext: NSManagedObjectContext {
		
		// NSMangedObejct 가  main thread 에서 작동할 수 있게 설정 -> View 에 나타내는 것이기에 main thread 에서 해줘야 나중에 error 안생김
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		
		// 위에 설정한 값을 현제 ccontainer StoreCoordinator 에 작동되게 함
		context.persistentStoreCoordinator = container.persistentStoreCoordinator
		return context
	}
	
	// MARK: - INIT
	private init() {
		container = NSPersistentContainer(name: "StampDataModel")
		
		// ViewContext 가 변화 될때 자동으로 기존 데이터에 merge 시켜서 자동 업데이트 시켜줌
		container.viewContext.automaticallyMergesChangesFromParent = true
		
		container.loadPersistentStores { (desciption, error) in
			if let error = error {
				print("ERROR LOADING CORE DATA. \(error)")
			} else {
				print("SUCCESSFULLY LOADED CORE DATA. \(desciption)")
			}
		}
	}
	
	// Stamp Core Data 에 저장되어 있는지 없는지 확인하기
	func exsist(stamp: Stamp, context: NSManagedObjectContext) -> Stamp? {
		try? context.existingObject(with: stamp.objectID) as? Stamp
	}
	
	// Detle Data
	func delete(stamp: Stamp, context: NSManagedObjectContext) throws {
		// 현제 Stamp 가 있는 확인하기
		if let exsistingStamp = exsist(stamp: stamp, context: context) {
			// 선택된 context 를 core data 에서 삭제
			context.delete(exsistingStamp)
			// 삭제 한다음에 다시 저장해주기 -> 비동기 처리해야되서 Task 를 사용 (background 상태에서 작업할 수 있게 함)
			Task(priority: .background) {
				try await context.perform {
					try context.save()
				}
			}
		}
	}
	
}
