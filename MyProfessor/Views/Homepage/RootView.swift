//
//  ContentView.swift
//  MyProfessor
//
//  Created by Leonard on 11/5/24.
//

import SwiftUI

struct RootView: View {
	
	@State private var isLoading = false
	@State private var pressed = false
	@State var userText = ""
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack {
					VStack {
						MyProfessorLogo()
							.padding(.top, 20)
						searchSection
							.navigationDestination(isPresented: $pressed) {
								ResultsView(departmentCode: "MATH", courseCode: "2A", termCode: "W2025")
							}
					}
					HStack {
						VStack(alignment: .leading) {
							Text("Recent searches")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundStyle(Color.black)
							
							RecentSearchCells(searchHistory: "Math 1A -2024 Fall")
							RecentSearchCells(searchHistory: "Math 1A -2024 Fall")
						}
						.padding()
						Spacer()
					}
					Spacer()
				}
			}
		}
	}
	
	private var searchSection: some View {
		VStack(alignment: .center) {
			Text("Find your professor")
				.font(.subheadline)
				.fontWeight(.bold)
			searchBar(userText: $userText, toggleField: $pressed)
		}
		.padding(50)
	}
}

#Preview {
	RootView()
}
