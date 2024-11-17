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
				daLogo
					.padding(.leading)
					.padding(.top, 35)
			}
		}
	}
	
	
	
	private var daLogo: some View {
		Image("DA-Logo-MyProfessor")
			.resizable()
			.frame(width: 150, height: 62)
	}
	
	private var myProfessorBox: some View {
		ZStack(alignment: .center) {
			myProfessorBoxContent
				.offset(y: 19)
				.background(professorBox)
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
	
	private var professorBox: some View {
		Rectangle()
			.foregroundColor(.clear)
			.frame(width: 159, height: 123)
			.background(Color(red: 0.91, green: 0.91, blue: 0.91))
			.cornerRadius(14)
			.shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
		
	}
	
	private var myProfessorBoxContent: some View {
		Text("My\nProfessor")
			.font(.custom("title", size: 32))
			.fontWeight(.bold)
			.foregroundStyle(Color.black)
			.padding(5)
		
	}
}


#Preview {
	Searchpage()
}
