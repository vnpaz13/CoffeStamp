//
//  UserDetailView.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import SwiftUI

struct UserDetailView: View {
	
	// Navigation SplitView 에서 iPad 와 iPhone 크기를 다르게 하기 위한 environment
	@Environment(\.horizontalSizeClass) var horzontalSizeClass
	var isiPhone: Bool {
		horzontalSizeClass == .compact
	}
	
	@ObservedObject var vm: StampViewModel
	
    var body: some View {
		
		List {
			Text(isiPhone ? "아이폰" : "아이패드")
			
			Section("General") {
				
				LabeledContent {
					Text(vm.stamp.name)
				} label: {
					Text("Name")
				}
				
				LabeledContent {
					Text(vm.stamp.company)
				} label: {
					Text("Company")
				}
				
				LabeledContent {
					Text("\(vm.stamp.totalFreeCoffee)")
				} label: {
					Text("Total Free Coffee")
				}
				

			}//: SECTION
			
			Section("Stamp \(vm.stamp.seletedCoffee)/7") {
				// 아이폰 일때
				if isiPhone {
					VStack (spacing: 20)  {
						HStack {
							ForEach(1..<4, id: \.self) { index in
								Image(systemName: "cup.and.saucer")
									.resizable()
									.frame(width: 50, height: 50)
									.onTapGesture {
										// SELETED COFFEE ACTION
										
										vm.stamp.seletedCoffee = index
										save()
									}
									.foregroundColor(index <= vm.stamp.seletedCoffee ? .accentColor : .gray.opacity(0.3))
							} //: LOOP
							.padding(.horizontal, 20)
						} //: HSTACK
						.frame(maxWidth: .infinity, alignment: .center)
						
						HStack {
							ForEach(4..<8, id: \.self) { index in
								Image(systemName: "cup.and.saucer")
									.resizable()
									.frame(width: 50, height: 50)
									.onTapGesture {
										// SELETED COFFEE ACTION
										vm.stamp.seletedCoffee = index
										save()
									}
									.foregroundColor(index <= vm.stamp.seletedCoffee ? .accentColor : .gray.opacity(0.3))
							} //: LOOP
							.padding(.horizontal, 15)
						} //: HSTACK
						.frame(maxWidth: .infinity, alignment: .center)
						
						
						Image(systemName: "cup.and.saucer.fill")
							.resizable()
							.frame(width: 100, height: 100)
							.foregroundColor(.accentColor)
							.onTapGesture {
								//  COUNT TOTAL FREE COFFEE ACTION
								vm.stamp.totalFreeCoffee += 1
								vm.stamp.seletedCoffee = 0
								save()
							}
					} //: VSTACK
				} else {
					// 아이패드 일때
					
					VStack (spacing: 30)  {
						HStack {
							ForEach(1..<8, id: \.self) { index in
								Image(systemName: "cup.and.saucer")
									.resizable()
									.frame(width: 50, height: 50)
									.onTapGesture {
										//  SELETED COFFEE ACTION
										vm.stamp.seletedCoffee = index
										save()
									}
									.foregroundColor(index <= vm.stamp.seletedCoffee ? .accentColor : .gray.opacity(0.3))
									.padding(.horizontal)
							} //: LOOP
							.padding(.horizontal, 20)
						} //: HSTACK
						.frame(maxWidth: .infinity, alignment: .center)
						
						Image(systemName: "cup.and.saucer.fill")
							.resizable()
							.frame(width: 100, height: 100)
							.foregroundColor(.accentColor)
							.onTapGesture {
								//  COUNT TOTAL FREE COFFEE ACTION
								vm.stamp.totalFreeCoffee += 1
								vm.stamp.seletedCoffee = 0
								save()
							}
					} //: VSTACK

				}//:CONDITIONAL
			}//: SECTION
			
			
			Section("Notes") {
				Text(vm.stamp.notes)
			}
		} //: LIST
		.scrollContentBackground(.hidden) // Background Color 보이게 하기
		.background(Color.accentColor.opacity(0.5))
		.navigationTitle("Test Name")
		.navigationBarTitleDisplayMode(.inline)
    }
	
	
	func save() {
		do {
			try vm.viewModelSave()
		} catch {
			print("Error: \(error)")
}
	}
}





//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//		NavigationStack {
//			UserDetailView()
//		}
//    }
//}
