//
//  ChecklistRow.swift
//  BMS_SwiftUI_Sample_v4_Basic
//
//  THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
//  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//  PARTICULAR PURPOSE.
//
//  Created by Rob Roy
//  Copyright © 2020 Brother Mobile Solutions. All rights reserved.
//

import SwiftUI

// This defines a table row with a Title, an optional Subtitle, and a CheckMark to indicate the item is selected.
struct ChecklistRow: View {
    var title:String
    var subtitle:String?
    var isChecked:Bool
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(self.title)
                    .font(.body)

                if subtitle != nil {
                    Text(self.subtitle!)
                        .font(.subheadline)

                }
            }
            
            Spacer()
            if isChecked {
                // NOTE: c.f. SF Symbols app for list of available graphics
                // that can be used with systemName.
                Image(systemName: "checkmark")
            }
        }.padding()
     }
}

struct ChecklistRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChecklistRow(title: "Testing 1,2,3", isChecked: true)
            ChecklistRow(title: "Hello World", isChecked: false)
            ChecklistRow(title: "Main", subtitle: "Subtitle", isChecked: true)
        }
        .previewLayout(.fixed(width:300, height:50))

    }
}
