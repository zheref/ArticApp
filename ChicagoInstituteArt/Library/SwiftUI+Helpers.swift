//
//  SwiftUI+Helpers.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 14/05/24.
//

import SwiftUI

struct Centered<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                content
                Spacer()
            }
            Spacer()
        }
    }
}
