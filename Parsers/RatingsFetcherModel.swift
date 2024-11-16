//
//  RatingsFetcherModel.swift
//  MyProfessor
//
//  Created by Leonard on 11/5/24.
//
import Foundation
import SwiftSoup

struct ProfessorRatings {
	var difficulty: Double
	var wouldTakeAgain: Int
	var overallRating: String
	var reviewNum: Int
}

class RatingsFetcherModel: HttpUtil, ObservableObject {
	func getRatings(professorName: String, departmentCode: String, completion: @escaping (Result<ProfessorRatings?, Error>) -> Void) {
		let baseUrl = "https://www.ratemyprofessors.com/search/professors/1967?q=\(professorName)"
		guard let url = URL(string: baseUrl) else {
			completion(.failure(NSError(domain: "RatingsFetcherModel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
			return
		}
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data, let html = String(data: data, encoding: .utf8) else {
				completion(.failure(NSError(domain: "RatingsFetcherModel", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to load data"])))
				return
			}

			do {
				let soup = try SwiftSoup.parse(html)
				let teacherCards = try soup.select("a[class^=TeacherCard_]")
				var bestMatch: ProfessorRatings?

				for card in teacherCards {
					let department = try card.select("div[class^=CardSchool__Department]").first()?.text() ?? ""
					let nameFromCard = try card.select("div[class^=CardName__StyledCardName]").first()?.text() ?? ""

					if self.matchDepartment(department: department, departmentCode: departmentCode),
					   self.similarNames(name1: professorName, name2: nameFromCard) {
						if let ratings = self.buildRatings(card: card),
						   ratings.reviewNum > (bestMatch?.reviewNum ?? 0) {
							bestMatch = ratings
						}
					}
				}

				completion(.success(bestMatch))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	func matchDepartment(department: String, departmentCode: String) -> Bool {
		return department.lowercased().contains(departmentCode.lowercased())
	}
	
	func similarNames(name1: String, name2: String) -> Bool {
		let name1Components = name1.split(separator: " ")
		let name2Components = name2.split(separator: " ")

		guard name1Components.count == 2, name2Components.count == 2 else { return false }

		let (first1, last1) = (String(name1Components[0]), String(name1Components[1]))
		let (first2, last2) = (String(name2Components[0]), String(name2Components[1]))

		return (first1 == first2 && last1 == last2) || (first1 == last2 && last1 == first2)
	}

	func buildRatings(card: Element) -> ProfessorRatings? {
		do {
			let ratingRow = try card.select("div[class^=CardNumRating_]")
			guard ratingRow.count > 3 else { return nil }
			
			let reviewNumText = try ratingRow[3].text().replacingOccurrences(of: "ratings", with: "").trimmingCharacters(in: .whitespaces)
			guard let reviewNum = Int(reviewNumText), reviewNum > 0 else { return nil }

			let feedbackRows = try card.select("div[class^=CardFeedback_]")
			var wouldTakeAgain = 0
			var difficulty = 0.0

			for feedback in feedbackRows {
				let text = try feedback.text().lowercased()
				if text.contains("would take again") {
					let value = try feedback.select("div").last()?.text().replacingOccurrences(of: "%", with: "")
					wouldTakeAgain = Int(value ?? "") ?? -1
				} else if text.contains("level of difficulty") {
					let value = try feedback.select("div").last()?.text()
					difficulty = Double(value ?? "") ?? 0.0
				}
			}

			let overallRating = try ratingRow[2].text()

			return ProfessorRatings(difficulty: difficulty, wouldTakeAgain: wouldTakeAgain, overallRating: overallRating, reviewNum: reviewNum)
		} catch {
			print("Error parsing card: \(error)")
			return nil
		}
	}
}
