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
    @State private var showModal = false;
    @State private var items: [Item] = [Item]()
    var categories = ["Clothing", "Gaming", "School", "Work"]
    
    init() {
        UITableView.appearance().backgroundColor = .white // Uses UIColor
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
        UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    //                    HStack {
                    //                        Text("SparkJoy")
                    //                            .font(.largeTitle)
                    //                            .fontWeight(.bold)
                    //                            .padding(.leading)
                    //                            .padding(.top)
                    //                        Spacer()
                    //                        Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    //                            Image("qr_icon")
                    //                                .padding(.trailing)
                    //                                .padding(.top)
                    //                        }
                    //
                    //                    }
                    //                    .frame(minWidth: 0,
                    //                           maxWidth: .infinity,
                    //                           minHeight: 0,
                    //                           maxHeight: 50,
                    //                           alignment: .topLeading)
                    
                    Picker(selection: $categoryIndex, label: Text("Choose category")){
                        ForEach(0 ..< categories.count){
                            Text(self.categories[$0]).tag($0)
                        }
                    }
                    .onChange(of: categoryIndex) { (index) in
                        print("Index: \(index)")
                        items = coreDM.getItemByCategory(category: Int16(index))
                    }
                    
                    ScrollView (.horizontal, showsIndicators: false){
                        HStack{
                            ForEach (items, id: \.self) { item in
                                NavigationLink(
                                    destination: ItemDetailView(item: item), label: {
                                                                    ItemCardView(
                                                                        title: "\(item.title ?? "")",
                                                                        description: "\(item.desc ?? "")",
                                                                        location: "\(item.location ?? "")",
                                                                        value: "\(item.value)")
                                                                })
                                
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    Button(action:
                            {
                                self.showModal.toggle();
                                
                            },
                           label: {
                            Image("new_item_btn")
                           })
                        .sheet(isPresented: $showModal){
                            
                            NewItemModal(showModal: self.$showModal)
                        }
                        .frame(minWidth: 0,
                               maxWidth: 300,
                               minHeight: 0,
                               maxHeight: 57)
                        .padding()
                }
            }
            .onAppear(perform: {
                items = coreDM.getItemByCategory(category: Int16(categoryIndex))
            })
            .navigationBarTitle("SparkJoy", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Image("qr_icon")
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
