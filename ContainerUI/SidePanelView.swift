//
//  SidePanelView.swift
//  ContainerUI
//
//  Created by Raphaël Daumas on 20/06/2025.
//

import SwiftUI

struct SidePanelView: View {
    var body: some View {
        ZStack
        {
            Color(hex: 0x1D1D1D)
            
            VStack
            {
                Text("Containers")
                
                Text("Parameters")
            }
        }
    }
}

#Preview {
    SidePanelView()
}
