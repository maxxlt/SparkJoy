//
//  ContentView.swift
//  SparkJoy
//
//  Created by Max on 5/15/21.
//
// Referred https://www.hackingwithswift.com/books/ios-swiftui/scanning-qr-codes-with-swiftui for handling the scan
import SwiftUI


struct ContentView: View {
    @EnvironmentObject var coreDM:CoreDataManager
    @State private var categoryIndex = 0;
    @State private var showModal = false;
    @State private var showScanner = false;
    @State private var items: [Item] = [Item]()
    var categories = ["Clothing", "Gaming", "School", "Work"]
    
    init() {
        UITableView.appearance().backgroundColor = .white // Uses UIColor
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
        UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    } //init
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
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
                                            item: item)
                                    })
                                
                            }
                        }
                    } //horizontal Card Scrollview
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
                } //VStack
            } //ScrollView
            .onAppear(perform: {
                items = coreDM.getItemByCategory(category: Int16(categoryIndex))
            })
            .toolbar {
                ToolbarItem(placement: .principal, content: {Text("SparkJoy")})
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    NavigationLink(destination: ScanQRView(), label: {Image("qr_icon")})
//                    Button(action: {
////                        self.showScanner.toggle()
//                    }) {
//                        Image("qr_icon")
//                    } //Button
//                    .sheet(isPresented: $showScanner){
//                        CodeScannerView(codeTypes: [.qr], simulatedData: "921BC6D1-74AA-4C39-AC93-AFA2C1E0FB21", completion: self.handleScan)
//                    }
                }
            } // Toolbar
        } //NavigationView
    } //body
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
