//
//  SwiftUIView.swift
//  SparkJoy
//
//  Created by Max on 5/25/21.
//

import SwiftUI

struct NewItemModal: View {
    @EnvironmentObject var coreDM:CoreDataManager
    @Binding var showModal: Bool
    @State var desc_placeholder: String = "Description"
    @State var title: String = ""
    @State var desc: String = ""
    @State var location: String = ""
    @State var value: String = ""
    @State private var categoryIndex = 0;
    @State private var showAlert = false;
    var categories = ["Clothing", "Gaming", "School", "Work"]
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Item Information")) {
                    TextField("Title", text: $title)
                        .padding(.leading, 5.0)
                    ZStack {
                        if self.desc.isEmpty {
                                TextEditor(text:$desc_placeholder)
                                    .frame(height: 41.0)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .opacity(0.6)
                                    .disabled(true)
                        }
                        TextEditor(text: $desc)
                            .frame(height: 41.0)
                            .font(.body)
                            .opacity(self.desc.isEmpty ? 0.25 : 1)
                    }
                    
                    TextField("Location", text: $location)
                        .padding(.leading, 5.0)
                    TextField("Value", text: $value)
                        .keyboardType(.decimalPad)
                        .padding(.leading, 5.0)
                }
                Section(header: Text("Category")){
                    Picker(selection: $categoryIndex, label: Text("Choose category")){
                        ForEach(0 ..< categories.count){
                            Text(self.categories[$0]).tag($0)
                        }
                    }
                }
                Section {
                    Button(action:
                            {
                                if (title.isEmpty || desc.isEmpty || value.isEmpty || location.isEmpty){
                                    showAlert.toggle()
                                }
                                else {
                                    self.showModal.toggle();
                                    coreDM.saveItem(title: self.title, desc: self.desc, location: self.location, value: Float(value) ?? 0.00, category: Int16(categoryIndex))
                                }
                            },
                           label: {
                        Image("add_item_btn")
                    })
                        .alert(isPresented: $showAlert){
                            Alert(title: Text("Wrong input"), message: Text("Please fill out all the info"), dismissButton: .default(Text("Try again")))
                        }
                }
            }
            .padding(24)
            .navigationBarTitle(Text("New Item"))
        }
        
    }
}

struct NewItemModal_Previews: PreviewProvider {
    static var previews: some View {
        NewItemModal(showModal: .constant(true))
    }
}
