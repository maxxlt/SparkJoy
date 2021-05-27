//
//  ScanQRView.swift
//  SparkJoy
//
//  Created by Max on 5/26/21.
//

import SwiftUI
import CodeScanner

struct ScanQRView: View {
    @EnvironmentObject var coreDM:CoreDataManager
    @State private var showQuery: Bool = false
    @State private var query: Item = Item()
    @State var uid: String = "TEST"
    @State private var errorPresent: Bool = false
    var body: some View {
        CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
            .onChange(of: uid, perform: {newValue in
                if (errorPresent != true){
                    print("uid = " + uid);
                    self.showQuery.toggle()
                }
                        })
            .sheet(isPresented: $showQuery, content: {
                ItemCardView(item: query)
            })
            .alert(isPresented: $errorPresent){
                Alert(title: Text("QR Invalid"), message: Text("Couldn't find any item with this QR"), dismissButton: .default(Text("OK")))
            }
    }
    func handleScan(result: Result<String, CodeScannerView.ScanError>){
        switch result {
        case .success(let code):
            uid = code
            let items = coreDM.getItemByUid(uid: code)
            if (items.count != 0){
                query = items[0]
            }
            else {
                errorPresent.toggle()
            }
            
        case .failure( _):
            print("Scanning failed")
        }
    }
}

struct ScanQRView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRView()
    }
}
