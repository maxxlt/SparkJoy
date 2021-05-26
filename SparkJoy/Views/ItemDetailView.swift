//
//  ItemDetailView.swift
//  SparkJoy
//
//  Created by Max on 5/25/21.
//

import SwiftUI

struct ItemDetailView: View {
    var title = ""
    var description = ""
    var location = ""
    var value = ""
    
    var body: some View {
        VStack (alignment: .leading){
            Text(title)
                .font(.title)
                .foregroundColor(.black)
                .padding(.top, 32)
                .padding(.leading, 24)
                .padding(.trailing,24)
            Text("Description")
                .font(.title2)
                .foregroundColor(Color.gray)
                .padding(.top, 24)
                .padding(.leading, 24)
            Text(description)
                .font(.headline)
                .foregroundColor(.black)
                .foregroundColor(.black)
                .padding(.top, 4)
                .padding(.leading, 24)
                .padding(.trailing,24)
            Text("Locaton")
                .font(.title2)
                .foregroundColor(Color.gray)
                .padding(.top, 24)
                .padding(.leading, 24)
                .padding(.trailing,24)
            Text(location)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 4)
                .padding(.leading, 24)
                .padding(.trailing,24)
            Text("Value")
                .font(.title2)
                .foregroundColor(Color.gray)
                .padding(.top, 24)
                .padding(.leading, 24)
                .padding(.trailing,24)
            Text("$" + value)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 4)
                .padding(.leading, 24)
                .padding(.trailing,24)
                .padding(.bottom, 32)
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView()
    }
}
