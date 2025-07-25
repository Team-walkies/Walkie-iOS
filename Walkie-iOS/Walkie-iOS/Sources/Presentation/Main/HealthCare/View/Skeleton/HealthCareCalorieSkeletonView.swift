//
//  HealthCareCalorieSkeletonView.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/25/25.
//

import SwiftUI

struct HealthCareCalorieSkeletonView: View {
    
    var body: some View {
        HStack(
            spacing: 8
        ) {
            SkeletonRect(
                width: 40,
                height: 40,
                cornerRadius: 99
            )
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                SkeletonRect(
                    width: 100,
                    height: 20,
                    cornerRadius: 8
                )
                
                SkeletonRect(
                    width: 180,
                    height: 20,
                    cornerRadius: 8
                )
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(8, corners: .allCorners)
    }
}
