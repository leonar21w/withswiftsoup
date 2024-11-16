//
//  DigestData.swift
//  MyProfessor
//
//  Created by Leonard on 11/15/24.
//

import Foundation


class DigestDataVM: ObservableObject {
	
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

}
