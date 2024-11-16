//
//  DigestData.swift
//  MyProfessor
//
//  Created by Leonard on 11/15/24.
//

import Foundation

class DigestDataVM: ObservableObject {
	
	@Published var departmentCode: String = ""
	@Published var courseCode: String = ""
	@Published var termCode: String = ""
	
	
	@Published var professorFetcher = ProfessorsFetcher()
	@Published var ratings = RatingsFetcherModel()
	
	//MARK: make a function that will be called in the for each loop in view
	
	func searchProfessorRatings() async throws -> [Professor] {
		try! await professorFetcher.getProfessorData(departmentCode: departmentCode, courseCode: courseCode, termCode: termCode)
	}
	
}
