//
//  MainView.swift
//  CoffeeStamp
//
//  Created by VnPaz on 6/7/24.
//

import SwiftUI

struct MainView: View {
	// MARK: - PROPERTY
	
	// CoreData fetch 해오기
	@FetchRequest(fetchRequest: Stamp.all()) private var stamps
	
	// ViewModel 연결
	@EnvironmentObject var vm: StampViewModel
	
	// Provider Sington 연결
	var provier = StampProvider.shared
	
	
	// MARK: - STATE
	
	// seleted Single item and add, edit stamp
	@State var seletedItem: Stamp?
	@State var stamptoEdit: Stamp?
	
	// Fav
	@State private var isFav: Bool = false
	@State private var favConfig: FavConfig = .init()
	
	// Sort
	@State private var sort: Sort = .asc
	@State private var isAsc: Bool = false
	
	// MARK: - BODY
	var body: some View {
		NavigationSplitView {
			ZStack {
				
				if stamps.isEmpty {
					NoUserView()
				} else {
					List {
						ForEach(stamps) { stamp in
							
							NavigationLink {
								// Destinaltion -> UserDetailView()
								UserDetailView(vm: .init(provider: provier, stamp: stamp))
							} label: {
								
								// Label -> StampRowView()
								StampRowView(vm: .init(provider: provier, stamp: stamp))
									.swipeActions(edge: .leading, allowsFullSwipe: false) {
										// DELETE ACTION
										Button {
											
											do {
												try provier.delete(stamp: stamp, context: provier.viewContext)
											} catch {
												print("Error: \(error)")
											}
										} label: {
											Label("Delete", systemImage: "trash")
										}
										.tint(.red)
										
									}//: SWIPEACTION
								
									.swipeActions(edge: .trailing, allowsFullSwipe: true) {
										//  EDIT ACTION
										Button {
											stamptoEdit = stamp
										} label: {
											Label("Edit", systemImage: "pencil")
										}
										.tint(.orange)

										
									} //: SWIFEACTION
							} //: NAVIGATION LINK
							
						} //: LOOP
						
						// List 배경설정
						.listRowSeparator(.hidden)
						.listRowBackground(
							RoundedRectangle(cornerRadius: 20)
								.fill(Color.accentColor.opacity(0.5))
								.padding(.vertical, 5)
						)
						
					} //: LIST
					
				}  //: CONDITION
				
			} //: ZSTACK
			.navigationTitle("Coffee Stamp")
			.toolbar {
				// Add Button
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						// TODO: ADD ACTION
						stamptoEdit = .empty(context: provier.newContext)
						
					} label: {
						Image(systemName: "plus")
							.symbolVariant(.circle)
							.font(.title2)
					}
					
				}
				
				// Fav Button
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						//  FAV ACTION
						if isFav {
							favConfig.filter = FavConfig.Filter.all
							isFav.toggle()
						} else {
							favConfig.filter = FavConfig.Filter.fave
							isFav.toggle()
						}
					} label: {
						Image(systemName: isFav ? "star.fill" : "star")
							.font(.title2)
							.tint(.yellow)
					}
					
				}
				
				// Sort Button
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						// SORT ACTION
						if isAsc {
							sort = Sort.asc
							isAsc.toggle()
						} else {
							sort = Sort.dec
							isAsc.toggle()
						}
					} label: {
						Image(systemName: isAsc ? "arrow.up" : "arrow.down")
							.symbolVariant(.circle)
							.font(.title2)
							.tint(.mint)
					}
					
				}
			} //: TOOLBAR
			.sheet(item: $stamptoEdit) {
				// Dismiss
				stamptoEdit = nil
			} content: { stamp in
				NavigationStack {
					CreateUserView(vm: .init(provider: provier, stamp: stamp))
				}
			}
			.onChange(of: favConfig) { newFav in
				stamps.nsPredicate = Stamp.favFilter(config: newFav)
			}
			.onChange(of: sort) { newSort in
				stamps.nsSortDescriptors = Stamp.sort(order: newSort)
			}
			
		} detail: {
			// Navigaion Link 를 눌렀을때 View -> value 값을 넘겨줘야 되는데 NavigationLink 를 사용해서 넘겨줘야 되기때문에 안됨
		} //: NAVIGATION
		
	}
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
