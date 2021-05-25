//
//  ContentView.swift
//  SparkJoy
//
//  Created by Max on 5/15/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coreDM:CoreDataManager
    @State private var categoryIndex = 0;
    
    var categories = ["Clothing", "Gaming", "School", "Work"]
    
    init() {
            UITableView.appearance().backgroundColor = .white // Uses UIColor
            UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
            UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
        }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack {
                    Text("SparkJoy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .padding(.top)
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Image("qr_icon")
                            .padding(.trailing)
                            .padding(.top)
                    }
                    
                }
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: 50,
                       alignment: .topLeading)
                Picker(selection: $categoryIndex, label: Text("Choose category")){
                    ForEach(0 ..< categories.count){
                        Text(self.categories[$0]).tag($0)
                    }
                }
                ScrollView (.horizontal, showsIndicators: false){
                    HStack{
                        ForEach (0 ..< 5) { i in ItemCardView(title: "\(i)", description: "\(i)s description", location: "\(i)s location", value: "\(i)s value")
                            
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Image("new_item_btn")
                }
                .frame(minWidth: 0,
                       maxWidth: 300,
                       minHeight: 0,
                       maxHeight: 57)
                .padding()
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
