//
//  PrintQRModal.swift
//  SparkJoy
//
//  Created by Max on 5/26/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct PrintQRModal: View {
    @EnvironmentObject var brotherPrinter:BrotherPrinter
    @EnvironmentObject var appSettings:AppSettings
    @Binding var showModal: Bool
    var uid: String
    var printersToSearch:[String]
    var doSearchOnAppear:Bool // caller decides this. For now, from PrinterSearchTopView->true, from WIFIChannelView->false.
    @Binding var wifiIPAddress:String
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name(SearchWIFIPrinters.wifiSearchNotificationName))
    @State var discoveredPrinterList:[BRPtouchDeviceInfo] = [] // list of devices returned by search
    @State var selectedPrinter:BRPtouchDeviceInfo? = nil // used to check row and update printer model
    @State var infoText:String = ""
    @State var isSearching:Bool = false
    @State private var showAlert = false;
    @State private var showPrintErrorAlert:Bool = false
    @State private var printErrorAlertMessage:String? = nil
    @State private var printingInProgress:Bool = false
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
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
                        handlePrintQR(uid: uid)
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
    
    func handlePrintQR(uid:String){
        print("Printing")
        printImage(uid:uid)
    } //handlePrintQR
    
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
    
    // Referenced from https://jeevatamil.medium.com/create-qr-codes-with-swiftui-e3606a103bc2
    func getCG(text: String) -> CGImage {
        let data = Data(text.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return cgimg
            }
        }
        
        return CGImage.self as! CGImage
    } // getQRCodeDate
    
    func printImage(uid:String) -> Void {
        print("printImage")
        
        //*** For QL/PT models, it's possible to detect the currently installed label rather than require user to select from a list.
        // So, let's demonstrate that here and REPLACE labelSize in PrintSettings.
        // Do this BEFORE we setup GUI to handle the print job.
        if self.brotherPrinter.model.isQLModel || self.brotherPrinter.model.isPTModel
        {
            // If this fails, it has already set error string to be displayed in GUI.
            // No reason to continue with printing.
            if !self.detectQLorPTLabel() {return}
        }

        //*** update GUI on main thread (i.e. init our @State vars)
        // DISABLE button presses that activate printing while printing is in progress
        self.printingInProgress = true
        // Init for no error (NOTE: showPrintErrorAlert should already be false so don't need to set it and redraw the GUI)
        self.printErrorAlertMessage = nil
        
        // Since we force unwrap below, assure printSettings is not nil
        // If it is, show error on main thread
        if self.brotherPrinter.printSettings == nil
        {
            self.printErrorAlertMessage = "printImage ERROR: printSettings is nil"
            self.showPrintErrorAlert = true
            return
        }

        //*** do printing in a background thread
        let queue = DispatchQueue(label: "printImage")
        
        queue.async {
            let cgImage = getCG(text: uid)
            let imagePrinter = ImagePrintHandler()
            self.printErrorAlertMessage = imagePrinter.printCGImage(cgimage: cgImage,channel: self.brotherPrinter.channel,
                                                                    printSettings: self.brotherPrinter.printSettings!)
            
            
            // update GUI on main thread
            DispatchQueue.main.async {
                // re-enable print buttons
                self.printingInProgress = false
 
                // if error, enable the alert
                if self.printErrorAlertMessage != nil {
                    self.showPrintErrorAlert = true
                }
            }
            
        } // queue.async
        
        
    } // printImage
    
    // Return code:
    // * true indicates label was detected successfully. The "labelSize" has been replaced in PrintSettings.
    // * false indicates it wasn't. The printErrorAlertMessage and showPrintErrorAlert have already been set.
    func detectQLorPTLabel() -> Bool {
        
        //*** Detect the currently installed label for QL or PT printer models, using v3 SDK API.

        // NOTE: If you wish to detect the currently installed paper, iOS SDK actually DOES have an API that is similar to the one
        // from Android. It is listed in the "BRPtouchPrinter.h" file (i.e. v3 API), but for whatever reason it is NOT documented
        // in the Manual (SDK TODO). API is called "getLabelInfoStatus". I will demonstrate how to use that API here.
        //
        // NOTE: It's ok to "co-mingle" v3 and v4 APIs in same app, since v4 doesn't have 100% same functionality yet.
        // But, you will need to use the BRPtouchPrinter object to use this getLabelInfoStatus function.
        // getLabelInfoStatus() requires doing start/endCommunication.
        //
        // NOTE: If you want to do this at print-time instead, this will likely be problematic if you have already
        // successfully done "openChannel" using v4 APIs.
        // So, you probably will need to do this BEFORE calling "openChannel".
        // As an ALTERNATIVE approach which uses v4 APIs only, after "openChannel" you can call "getPrinterStatus" and then parse the
        // StatusResponse by referring to the Raster Command Reference Guide (for your model) available online.
        // Apparently, if you have the Red/Black label, this will be indicated in one of the "undocumented" bytes.

        var errorString:String? = nil
        
        let printer = BRPtouchPrinter()
        printer.setPrinterName("Brother \(self.brotherPrinter.model.modelName)")
       
        //*** Convert v4 SDK channel to v3 SDK method of setting these
        let channelType =  self.brotherPrinter.channel.channelType
        let channelInfo = self.brotherPrinter.channel.channelInfo
        
        if channelType == .wiFi
        {
            printer.setInterface(.WLAN)
            printer.setIPAddress(channelInfo)
        }
        else if channelType == .bluetoothMFi
        {
            printer.setInterface(.BLUETOOTH)
            printer.setupForBluetoothDevice(withSerialNumber: channelInfo)

        }
        else if channelType == .bluetoothLowEnergy
        {
            printer.setInterface(.BLE)
            printer.setBLEAdvertiseLocalName(channelInfo)
        }
        else
        {
            errorString = "detectQLorPTLabel: Invalid channelType"
        }
        
        //*** getLabelInfo from printer and convert v3 SDK enum to v4 SDK enum
        if errorString == nil && printer.startCommunication() == true
        {
            let labelInfo:BRPtouchLabelInfoStatus? = printer.getLabelInfoStatus()
            
            if labelInfo != nil && self.brotherPrinter.printSettings != nil {
                
                //*** Update labelSize in printSettings
                if self.brotherPrinter.model.isQLModel {
                    let settings = self.brotherPrinter.printSettings as! BRLMQLPrintSettings
                    let v4label = SupportedModels.v4QLLabelSizeFromV3LabelIdType(v3labelID: labelInfo!.labelID)
                    if v4label != nil {
                        settings.labelSize = v4label!
                     }
                    else {
                        errorString = "detectQLorPTLabel: UNSUPPORTED label detected."
                    }
                } // QL
                else {
                    let settings = self.brotherPrinter.printSettings as! BRLMPTPrintSettings
                    let v4label = SupportedModels.v4PTLabelSizeFromV3LabelIdType(v3labelID: labelInfo!.labelID)
                    if v4label != nil {
                        settings.labelSize = v4label!
                    }
                    else {
                        errorString = "detectQLorPTLabel: UNSUPPORTED label detected."
                    }
                } // PT
            } // if labelInfo retrived OK
            else {
                errorString = "detectQLorPTLabel: ERROR getting labelInfo"
            }
            
            printer.endCommunication()
            
        } // if startCommunication
        else
        {
            errorString = "detectQLorPTLabel: startCommunication FAILED."
        }

        if errorString != nil
        {
            print("\(errorString!)")
            
            self.printErrorAlertMessage = errorString
            self.showPrintErrorAlert = true
            
            return false
        }
        else {
            print("detectQLorPTLabel: Label detected SUCCESSFULLY!")
            
            return true
        }
        
    } //detectQLorPTLabel
}


struct PrintQRModal_Previews: PreviewProvider {
    @State static var ipAddress = "12.34.56.789"
    static var previews: some View {
        PrintQRModal(showModal: .constant(true),uid: "", printersToSearch: SupportedModels.getArrayOfAllSupportedWIFIModels(),
                     doSearchOnAppear: true,
                     wifiIPAddress: $ipAddress)
            .environmentObject(BrotherPrinter())
            .environmentObject(AppSettings())
    }
}
