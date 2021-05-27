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
    var body: some View {
        CodeScannerView(codeTypes: [.qr], simulatedData: "921BC6D1-74AA-4C39-AC93-AFA2C1E0FB21", completion: self.handleScan)
            .sheet(isPresented: $showQuery, content: {
//                ItemCardView(item: query)
                Text(uid)
            })
    }
    func handleScan(result: Result<String, CodeScannerView.ScanError>){
        switch result {
        case .success(let code):
            query = coreDM.getItemByUid(uid: code)[0]
            print(query.title!)
            uid = code
            print(uid)
            self.showQuery.toggle()
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
