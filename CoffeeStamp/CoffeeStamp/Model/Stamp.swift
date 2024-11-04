//
//  Stamp.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import Foundation
import CoreData

// Core Data Model manually 생성
// final -> 하위 subclass 에서 override 막기
final class Stamp: NSManagedObject, Identifiable {
	
	// Core Data 안에 subclass 에 NSObject 로 접근하기 위해서 @NSManged 사용
	@NSManaged var name: String
	@NSManaged var company: String
	@NSManaged var isFav: Bool
	@NSManaged var notes: String
	@NSManaged var totalFreeCoffee: Int
	@NSManaged var seletedCoffee: Int
	
	// name, company 에 값이 있는 경우 저장이 안되게 save 를 disable 하기위한 computed property
	var isValid: Bool {
		!name.isEmpty && !company.isEmpty
	}
}


extension Stamp {
	private static var stampFetchRequest: NSFetchRequest<Stamp> {
		NSFetchRequest(entityName: "Stamp")
	}
	
	// all() 함수를 할때 request 를 sort 해서 array 로 return 하기
	static func all() -> NSFetchRequest<Stamp> {
		let request: NSFetchRequest<Stamp> = stampFetchRequest
		request.sortDescriptors = [
			NSSortDescriptor(keyPath: \Stamp.name, ascending: true)
		]
		return request
	}
	
	// 아무것도 없는 blank 상태의 Core Data 추가 하기
	static func empty(context: NSManagedObjectContext = StampProvider.shared.viewContext) -> Stamp {
		return Stamp(context: context)
	}
	
	// Favorite 될 수 있게 하는 함수
	static func favFilter(config: FavConfig) -> NSPredicate {
		switch config.filter {
		case .all:
			// NSPredicate 으로 모든 값 호출
			return NSPredicate(value: true)
		case .fave:
			// %@은 검색할 값을 전달할때 사용함, Core Data 에서 isFav 가 true 인것만 검색하고 알려줌
			// 만약 %@ 을 사용ㅇ해 값 형식을 대체해야 할때는 NSNumber을 사용해서 Value 값을 전달해줌
			return NSPredicate(format: "isFav == %@", NSNumber(value: true))
		}
	}
	
	// Sort 함수
	static func sort(order: Sort) -> [NSSortDescriptor] {
		[NSSortDescriptor(keyPath: \Stamp.name, ascending: order == .asc)]
	}
}


// MARK: - FAV Logic
struct FavConfig: Equatable {
	
	enum Filter {
		case all, fave
	}
	
	var filter: Filter = .all
}

// MARK: - Sort Logic
enum Sort {
	case asc, dec
}
