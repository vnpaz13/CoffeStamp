//
//  KoreanTest.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import SwiftUI

struct KoreanTest: View {
	@State var test: String = ""
	var body: some View {
		
		VStack {
			Text("한국어 잘 나오나?")
			
			TextField("한국어 테스트", text: $test)
		} //: VSTACK
	}
}

#Preview {
    KoreanTest()
}
