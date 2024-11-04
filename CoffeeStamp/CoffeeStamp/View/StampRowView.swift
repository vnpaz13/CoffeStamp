//
//  StampRowView.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import SwiftUI

struct StampRowView: View {
	
	@ObservedObject var vm: StampViewModel
	
	var body: some View {
		HStack(spacing: 10) {
			
			Text(vm.stamp.name)
				.font(.title2.bold())
			
			Text(vm.stamp.company)
				.font(.caption)
			

		} //: VSTACK
		.frame(maxWidth: .infinity, alignment: .leading)
		.overlay(alignment: .topTrailing) {
			Button {
				//  FAV ACTION
				vm.stamp.isFav.toggle()
				save()
			} label: {
				Image(systemName: "star")
					.font(.title3)
					.symbolVariant(.fill)
					.foregroundColor(vm.stamp.isFav ? .yellow : .gray.opacity(0.3))
			}
			.buttonStyle(.plain)

		} //: OVERLAY
		.padding(10)
    }
	
	// Save Fav
	func save() {
		do {
			try vm.viewModelSave()
		} catch {
			print("Error: \(error)")
}
	}
}

//
//struct StampRowView_Previews: PreviewProvider {
//    static var previews: some View {
//		StampRowView(index: 1)
//    }
//}
