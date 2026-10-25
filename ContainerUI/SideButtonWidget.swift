//
//  SideButtonWidget.swift
//  ContainerUI
//
//  Created by Raphaël Daumas on 20/06/2025.
//

import SwiftUI

struct SideButtonWidget: View {
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack
        {
            if (isSelected)
            {
                Color.sideButtonSelected
            }
            
            RoundedRectangle(cornerRadius: 15)
            
//            Button {
//                
//            } label: {
//                HStack
//                {
//                    Image(systemName: "gear")
//                    
//                    Text("Parameters")
//                }
//            }
        }
        .frame(height: 79)
    }
}

#Preview {
    SideButtonWidget(isSelected: .constant(true))
}
