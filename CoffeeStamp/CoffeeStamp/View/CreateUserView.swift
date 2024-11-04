//
//  CreateUserView.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import SwiftUI

struct CreateUserView: View {
	
	// Sheet 을 닫기 위한 dismiss
	@Environment(\.dismiss) private var dismiss
	
	// ViewModel 연결
	@ObservedObject var vm: StampViewModel
	
	var body: some View {
		List {
			Section {
				TextField("Name*", text: $vm.stamp.name)
					.keyboardType(.namePhonePad)
				
				TextField("Company*", text: $vm.stamp.company)
					.keyboardType(.namePhonePad)
				
				Toggle("Favorite", isOn: $vm.stamp.isFav)
			} header: {
				Text("GENERAL")
					.foregroundColor(.black)
			} footer: {
				Text("* You should fill in Name & Company name")
			}//: SECTION
			
			Section("Note") {
				TextField("", text: $vm.stamp.notes, axis: .vertical)
					.keyboardType(.namePhonePad)
			}//: SECTION
			.foregroundColor(.black)
			
		} //: LIST
		// list Background
		.scrollContentBackground(.hidden)
		.background(Color.accentColor.opacity(0.3))
		.navigationTitle(vm.isNew ? "New User" : "Update User")
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button {
					// USER SAVE ACTION
					validate()
					dismiss()
				} label: {
					Text("Done")
				}
				.disabled(!vm.stamp.isValid)
			}
			
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					// TODO: DISMISS ACTION
					dismiss()
				} label: {
					Text("Cancel")
				}
				
			}
		}
	}
}


extension CreateUserView {
	func validate() {
		if vm.stamp.isValid {
			do {
				try vm.viewModelSave()
			} catch {
				print("No Stamp Data")
			}
		}
	}
}


//struct CreateUserView_Previews: PreviewProvider {
//    static var previews: some View {
//		NavigationStack {
//			CreateUserView()
//		}
//    }
//}
