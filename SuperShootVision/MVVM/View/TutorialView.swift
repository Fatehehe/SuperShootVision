//
//  TutorialView.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI

struct TutorialView: View {
    @Environment(AppModel.self) var appModel
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    @State private var currentStep = 0
    let totalSteps = 4
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Persiapan Tempur")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .padding(.top, 50)
                .padding(.bottom, 20)
            
            TabView(selection: $currentStep) {
                TutorialSlide(icon: "hand.raised.fill", title: "1. Siapkan Senjata", description: "Renggangkan jari di tangan kiri kamu untuk memunculkan panah sihir.")
                    .tag(0)
                
                TutorialSlide(icon: "hand.thumbsup.fill", title: "2. Siapkan Busur", description: "Lakukan gaya 'Thumbs Up' (jempol) untuk memunculkan busur.")
                    .tag(1)
                
                TutorialSlide(icon: "scope", title: "3. Tarik Panah", description: "Dekatkan busur ke panah, kemudian tarik tangan kanan kamu ke belakang.")
                    .tag(2)
                
                TutorialSlide(icon: "flame.fill", title: "4. Tembak!", description: "Buka semua jari tangan kanan kamu untuk melepaskan tembakan maut!")
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 350)
            
            ZStack {
                if currentStep < totalSteps - 1 {
                    Button(action: {
                        withAnimation { currentStep += 1 }
                    }) {
                        Text("Selanjutnya")
                            .font(.title3.bold())
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                } else {
                    Button(action: {
                        appModel.currentGameState = .loading
                        Task {
                            await openImmersiveSpace(id: appModel.immersiveSpaceID)
                        }
                    }) {
                        Label("Paham, Mari Mulai!", systemImage: "checkmark.circle.fill")
                            .font(.title3.bold())
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.green)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 50)
        }
        .frame(width: 700, height: 600)
    }
}

struct TutorialSlide: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 90))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.cyan)
                .padding(.bottom, 10)
            
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text(description)
                .font(.title2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
        }
    }
}
