//
//  ItemCardView.swift
//  SparkJoy
//
//  Created by Max on 5/17/21.
//

import SwiftUI

struct ItemCardView: View {
    
    var title = ""
    var description = ""
    var location = ""
    var value = ""
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .frame(width: 300, height: 400)
                .padding(10)
                .shadow(radius: 3, x: 0, y: 3)
            VStack (alignment: .leading){
                Text(title)
                    .font(.title)
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
                    .padding(.top, 4)
                    .padding(.leading, 24)
                    .padding(.trailing,24)
                Text("Value")
                    .font(.title2)
                    .foregroundColor(Color.gray)
                    .padding(.top, 24)
                    .padding(.leading, 24)
                    .padding(.trailing,24)
                Text(value)
                    .font(.headline)
                    .padding(.top, 4)
                    .padding(.leading, 24)
                    .padding(.trailing,24)
                    .padding(.bottom, 32)
                
                
            }.frame(width: 300, height: 400, alignment: .topLeading)
        
        }
    }
}

struct ItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCardView()
    }
}