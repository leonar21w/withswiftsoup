//
//  RecentSearchCells.swift
//  MyProfessor
//
//  Created by Leonard on 11/17/24.
//

import SwiftUI

struct RecentSearchCells: View {
	
	//format this like the preview sample
	@State var searchHistory: String
	
	
    var body: some View {
		Text(searchHistory)
			.font(.footnote)
			.fontWeight(.semibold)
			.foregroundStyle(Color.gray)
			.padding(10)
			.background(background)
    }
	
	private var background: some View {
		RoundedRectangle(cornerRadius: 20)
			.fill(Color.gray.opacity(0.3))
	}
}

#Preview {
	RecentSearchCells(searchHistory: "Math 1A -2024 Fall")
}
