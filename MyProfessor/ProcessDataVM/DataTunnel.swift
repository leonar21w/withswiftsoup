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
					continuation.resume(returning: ratings)
				case .failure(let error):
					continuation.resume(throwing: error)
				}
			}
		}
	}

	func searchProfessorAndGetRatings(departmentCode: String, courseCode: String, termCode: String) async throws {
		professorData = try await professorFetcher.getProfessorData(departmentCode: departmentCode, courseCode: courseCode, termCode: termCode)
		
		await withTaskGroup(of: (Int, ProfessorRatings?).self) { group in
			for index in professorData.indices {
				let professor = professorData[index]
				
				group.addTask {
					let ratings = try? await self.searchForRatings(professor: professor.name, department: departmentCode)
					return (index, ratings) // Return index and fetched ratings
				}
			}
			
			for await (index, ratings) in group {
				if let ratings = ratings {
					self.professorData[index].difficulty = ratings.difficulty
					self.professorData[index].overallRating = Double(ratings.overallRating) ?? 0.0
					self.professorData[index].wouldTakeAgain = Double(ratings.wouldTakeAgain)
					self.professorData[index].numRatings = ratings.reviewNum
				}
			}
		}
	}
}
