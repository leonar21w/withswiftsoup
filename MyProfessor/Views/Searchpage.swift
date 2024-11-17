//
//  Searchpage.swift
//  MyProfessor
//
//  Created by Leonard on 11/16/24.
//

import SwiftUI

struct Searchpage: View {
	var body: some View {
		ZStack{
			HStack{
				myProfessorBox
			}
		}
	}
	
	private var myProfessorBox: some View {
		ZStack(alignment: .center) {
			myProfessorBoxContent
				.offset(y: 19)
			coloredDots
				.offset(x: 35, y: 19)
		}
	}
	
	private var coloredDots: some View {
		HStack{
			Circle()
				.foregroundStyle(Color(red: 0.76, green: 1, blue: 0.45))
				.frame(width: 16, height: 16)
			Circle()
				.foregroundStyle(Color(red: 1, green: 0.74, blue: 0.35))
				.frame(width: 16, height: 16)
			Circle()
				.foregroundStyle(Color(red: 0.85, green: 0.38, blue: 0.38))
				.frame(width: 16, height: 16)
			
			
		}
	}
	
	private var myProfessorBoxContent: some View {
		Text("My\nProfessor")
			.font(.system(size: 32, weight: .semibold, design: .default))
			.foregroundColor(.black)
			.padding(5)
	}


}


#Preview {
	Searchpage()
}
