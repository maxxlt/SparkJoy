//
//  PrintQRModal.swift
//  SparkJoy
//
//  Created by Max on 5/26/21.
//

import SwiftUI

struct PrintQRModal: View {
    @EnvironmentObject var brotherPrinter:BrotherPrinter
    @Binding var showModal: Bool
    var printersToSearch:[String]
    var doSearchOnAppear:Bool // caller decides this. For now, from PrinterSearchTopView->true, from WIFIChannelView->false.
    @Binding var wifiIPAddress:String
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name(SearchWIFIPrinters.wifiSearchNotificationName))
    @State var discoveredPrinterList:[BRPtouchDeviceInfo] = [] // list of devices returned by search
    @State var selectedPrinter:BRPtouchDeviceInfo? = nil // used to check row and update printer model
    @State var infoText:String = ""
    @State var isSearching:Bool = false
    @State private var showAlert = false;
    
    let printerSearch = SearchWIFIPrinters()
    
    var body: some View {
        VStack{
            Text("Select Printer..")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top, 32)
                .padding([.leading, .bottom, .trailing], 24)
                
            Spacer()
            List {
                ForEach(discoveredPrinterList, id:\.self) { discoveredPrinter in
                    Button(action: {
                        self.handleRowTap(deviceInfo: discoveredPrinter)
                        
                    })
                    {
                        // NOTE: For WIFI, the serialNumber will be best to use for unique identity (check mark)
                        // "strPrinterName" will NOT be unique. It seems that strPrinterName = strModelName.
                        ChecklistRow (title: discoveredPrinter.strSerialNumber,
                                      subtitle: discoveredPrinter.strPrinterName,
                                      isChecked: self.selectedPrinter?.strSerialNumber == discoveredPrinter.strSerialNumber)
                            .frame(height:20)
                    } // Button
                } // ForEach
            } // List
            .onReceive(pub, perform: { _ in self.didFinishWIFISearchNotificationReceived()})
            .onAppear{
                if self.doSearchOnAppear {self.doSearchByWIFI()}
             }
            Button(action:
                    {
                        
                    },
                   label: {
                Image("print_qr_btn")
            })
                .disabled(selectedPrinter == nil)
                .alert(isPresented: $showAlert){
                    Alert(title: Text("Wrong input"), message: Text("Please fill out all the info"), dismissButton: .default(Text("Try again")))
                }
        } // VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)
    } // body
    func handleRowTap(deviceInfo:BRPtouchDeviceInfo)
    {
        selectedPrinter = deviceInfo
        // NOTE: refer to SDK user guide. BRLMPrinterClassifier is a utility class.
        // This method converts model name into A BRLMPrinterModel
        let sdkmodel:BRLMPrinterModel = BRLMPrinterClassifier.transferEnum(from: deviceInfo.strModelName)
        
        // Convert sdk model to one of our "supported" models.
        // If detected/selected printer is not one that our app supports, this will return nil.
        let selectedModel:SupportedModels? = SupportedModels.supportedModelFromBRLMPrinterModel(model:sdkmodel)
        
        if selectedModel != nil
        {
            // The binding var must be set so we can update the IPAddress TextField in WIFIChannelView
            // during user PrinterSetup, which also uses this same search result view.
            self.wifiIPAddress = deviceInfo.strIPAddress
            
            // This utility method assures we set these 2 things in the right order.
            self.brotherPrinter.setModelAndChannel(newModel: selectedModel!, newChannel: BRLMChannel(wifiIPAddress:deviceInfo.strIPAddress))
        }
    } //handleRowTap
    
    func doSearchByWIFI()
    {
        // Update the GUI in case we search again using the button
        self.infoText = "Searching, please wait..."
        self.discoveredPrinterList = []
        self.isSearching = true

        // WIFI search requires specifying the models you want to find.
        // Caller must setup this array, as sometimes we want to find all, other times we want to find only a specific model.
        // NOTE: The array works whether "Brother " is added to model name or not. But, for consistency, let's not add it.
        self.printerSearch.startSearchWiFiPrinter(printerNameArray: self.printersToSearch, searchTimeout: 5)
        
    } // doSearchByWIFI
    
    func didFinishWIFISearchNotificationReceived()
    {
        print("didFinishWIFISearch completed")
        
        self.infoText = "Search completed!"
        self.isSearching = false

        // Update discoveredPrinterList with search results, which will update the GUI
        // WARNING: Don't update the table if we're not visible, as it will cause a CRASH.
        // This can happen if user presses Back Button before search completes.
        // You should disable the back button during search to prevent this possibility.
        // Or, you should add a variable like "isVisible" that you set in .onAppear and .onDisappear and check it here.
        self.discoveredPrinterList = self.printerSearch.discoveredPrinterList
        
        // NOTE: We will update channel only when user selects the one they want to use. c.f. handleRowTap
        
     } // didFinishWIFISearchNotificationReceived
}

struct PrintQRModal_Previews: PreviewProvider {
    @State static var ipAddress = "12.34.56.789"
    static var previews: some View {
        PrintQRModal(showModal: .constant(true), printersToSearch: SupportedModels.getArrayOfAllSupportedWIFIModels(),
                     doSearchOnAppear: true,
                     wifiIPAddress: $ipAddress)
            .environmentObject(BrotherPrinter())
    }
}
