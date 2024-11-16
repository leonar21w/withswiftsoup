//
//  ContentView.swift
//  MyProfessor
//
//  Created by Leonard on 11/5/24.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var tryout = ProfessorsFetcher()
	@StateObject var trythis = RatingsFetcherModel()
	var body: some View {
		Text("test this shit")
			.onTapGesture {
				Task {
					try await tryout.getTerms()
					try await tryout.getProfessorData(departmentCode: "PHYS", courseCode: "4A", termCode: "W2025")
					try await trythis.getRatings(professorName: "Eduardo Luna", departmentCode: "PHYS") { result in
						switch result {
							case .success(let ratings):
								if let ratings = ratings {
									print("Ratings fetched successfully: \(ratings)")
								} else {
									print("No ratings found for the professor.")
								}
							case .failure(let error):
								print("Failed to fetch ratings: \(error.localizedDescription)")
						}
					}
				}
				
			}
	}
}
#Preview {
    ContentView()
}
