//
//  ContentView.swift
//  MyProfessor
//
//  Created by Leonard on 11/5/24.
//

import SwiftUI

struct ContentView: View {
	@StateObject var viewModel = DataTunnelVM()

	@State private var isLoading = true
	@State private var pressed = false

	var body: some View {
		
		Text("get physics 4a proffesors")
			.padding(.top, 50)
			.onTapGesture {
				Task {
					do {
						try await viewModel.searchProfessorAndGetRatings(
							departmentCode: "PHYS",
							courseCode: "4A",
							termCode: "W2025"
						)
						isLoading = false
					} catch {
						print("Error loading data: \(error.localizedDescription)")
						isLoading = false
					}
				}
			}
		
		
		VStack {
			if viewModel.professorData.isEmpty && !isLoading {
				Text("No professors found.")
					.font(.headline)
					.foregroundColor(.gray)
			} else {
				List(viewModel.professorData, id: \.name) { professor in
					VStack(alignment: .leading) {
						Text(professor.name)
							.font(.headline)
							.padding(.bottom, 4)

						Text("Difficulty: \(professor.difficulty, specifier: "%.1f")")
						Text("Overall Rating: \(professor.overallRating, specifier: "%.1f")")
						Text("Would Take Again: \(professor.wouldTakeAgain, specifier: "%.0f")%")
						Text("Number of Ratings: \(professor.numRatings)")
							.padding(.bottom, 4)

						Text("Schedules:")
							.font(.subheadline)
							.padding(.top, 8)

						//go over possible schedules
						ForEach(Array(professor.allSchedules.keys), id: \.self) { courseID in
							if let times = professor.allSchedules[courseID] {
								VStack(alignment: .leading) {
									Text("Course ID: \(courseID)")
										.font(.footnote)
										.bold()
									ForEach(times, id: \.self) { time in
										Text(time)
											.font(.footnote)
									}
								}
								.padding(.bottom, 8)
							}
						}
					}
					.padding(.vertical, 4)
				}
			}
		}
	}
}
