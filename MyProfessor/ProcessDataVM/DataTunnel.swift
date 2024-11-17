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
	
	@Published var ratings = RatingsFetcherModel()
	
	func searchForRatings(professor: String, department: String) async throws -> ProfessorRatings? {
		try await withCheckedThrowingContinuation { continuation in
			ratings.getRatings(professorName: professor, departmentCode: department) { result in
				switch result {
				case .success(let ratings):
					if let ratings = ratings {
						continuation.resume(returning: ratings)
					} else {
						continuation.resume(returning: nil)
					}
				case .failure(let error):
					continuation.resume(throwing: error)
				}
			}
		}
	}

	
	func searchProfessorAndGetRatings(departmentCode: String, courseCode: String, termCode: String) async throws {
		professorData = try await professorFetcher.getProfessorData(departmentCode: departmentCode, courseCode: courseCode, termCode: termCode)
		
		await withTaskGroup(of: Void.self) { group in
			for index in professorData.indices {
				let professor = professorData[index]
				group.addTask {
					if let ratings = try? await self.searchForRatings(professor: professor.name, department: departmentCode) {
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
	}
}
