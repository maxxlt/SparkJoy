//
//  PrintQRModal.swift
//  SparkJoy
//
//  Created by Max on 5/26/21.
//

import SwiftUI

struct PrintQRModal: View {
    @Binding var showModal: Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PrintQRModal_Previews: PreviewProvider {
    static var previews: some View {
        PrintQRModal(showModal: .constant(true))
    }
}
