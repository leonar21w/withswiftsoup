//
//  ContentView.swift
//  MyProfessor
//
//  Created by Leonard on 11/5/24.
//

import SwiftUI

struct ContentView: View {
	
	@State var depcode: String = "PHYS"
	@State var cCode: String = "4A"
	@State var termcode: String = "W2025"
	@StateObject var vm = DataTunnelVM()
	
	@State var text: String = "test it"
	var body: some View {
		Text(text)
			.onTapGesture {
				Task {
					try await print(vm.searchProfessorAndGetRatings(departmentCode: depcode, courseCode: cCode, termCode: termcode))
				}
			}
		
		
	}
}

