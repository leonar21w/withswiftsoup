//
//  DataTunnel.swift
//  MyProfessor
//
//  Created by Leonard on 11/15/24.
//

import Foundation

@MainActor
class DataTunnelVM: ObservableObject {

	@Published var professorFetcher = ProfessorsFetcher()
	@Published var professorData: [Professor] = []
	@Published var ratingsVM = DigestDataVM()
	
	func searchProfessorAndGetRatings(departmentCode: String, courseCode: String, termCode: String) async throws -> [Professor] {
		professorData = try await professorFetcher.getProfessorData(departmentCode: departmentCode, courseCode: courseCode, termCode: termCode)
		
		await withTaskGroup(of: Void.self) { group in
			for index in professorData.indices {
				let professor = professorData[index]
				group.addTask {
					if let ratings = try? await self.ratingsVM.searchForRatings(professor: professor.name, department: departmentCode) {
						DispatchQueue.main.async {
							self.professorData[index].difficulty = ratings.difficulty
							self.professorData[index].overallRating = Double(ratings.overallRating) ?? 0.0
							self.professorData[index].wouldTakeAgain = Double(ratings.wouldTakeAgain)
							self.professorData[index].numRatings = ratings.reviewNum
						}
					}
				}
			}
		}
		
		return professorData
	}
}
