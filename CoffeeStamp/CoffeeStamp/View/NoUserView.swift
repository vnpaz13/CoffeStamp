//
//  NoUserView.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import SwiftUI

struct NoUserView: View {
    var body: some View {
		VStack (spacing: 20) {
			Text("😰 No Users")
				.font(.largeTitle.bold())
			
			Text("☝️ 위에 + 버튼을 눌러서 새로운 User 를 추가하세요")
				.font(.callout)
		} //: VSTACK
    }
}

struct NoUserView_Previews: PreviewProvider {
    static var previews: some View {
        NoUserView()
    }
}
