//
//  LoadingView.swift
//  SuperShootVision
//
//  Created by Fatakhillah Khaqo on 02/07/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var isPulsing = false
    
    var body: some View {
        VStack(spacing: 35) {
            Image(systemName: "shield.lefthalf.filled.trianglebadge.exclamationmark")
                .font(.system(size: 80))
                .foregroundStyle(.red, .yellow)
                .symbolEffect(.pulse, options: .repeating, isActive: isPulsing)
            
            VStack(spacing: 12) {
                Text("Entering the battlefield...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Preparing the world...")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            ProgressView()
                .controlSize(.large)
                .tint(.red)
        }
        .padding(60)
        .frame(width: 500, height: 400)
        .onAppear {
            isPulsing = true
        }
    }
}
