//
//  ItemDetailView.swift
//  SparkJoy
//
//  Created by Max on 5/25/21.
//
// Referred from https://www.hackingwithswift.com/books/ios-swiftui/generating-and-scaling-up-a-qr-code

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ItemDetailView: View {
    let uid: String
    let title: String
    var desc = ""
    var location = ""
    var value = ""
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State private var showModal = false;
    @State var wifiIPAddress:String = "Not Used"
    
    init(item: Item){
        self.uid = item.uid ?? ""
        self.title = item.title ?? ""
        self.desc = item.desc ?? ""
        self.location = item.location ?? ""
        self.value = String(item.value)
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        ScrollView{
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
                Text(desc)
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
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)
            VStack {
                Image(uiImage: generateQRCode(from: "\(self.uid)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Button(action: {
                    self.showModal.toggle();
                }, label: {
                    Text("Print QR")
                })
                .sheet(isPresented: $showModal){
                    PrintQRModal(showModal: self.$showModal, uid: self.uid, printersToSearch: SupportedModels.getArrayOfAllSupportedWIFIModels(),doSearchOnAppear: true,
                                 wifiIPAddress: $wifiIPAddress)
                }
            }
            .frame(minWidth: 0, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 224, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        }
        
        
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let item = Item()
        ItemDetailView(item: item)
    }
}
