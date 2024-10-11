//
//  AddPrinterView.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 19.09.2024.
//

import SwiftUI
import SwiftSnmpKit
import SwiftData

struct AddPrinterView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    //@EnvironmentObject var cloudKitModel: CloudKitModel
    
    @Binding var showSheet: Bool
    
    @State var ipAdress: String
    @State var userName: String
    //@State var authType: SnmpV3Authentication
    @State var authPassword: String
    @State var privPassword: String
    @State var community: String
    
    
    
    
    var body: some View {
        
        Form {
            Section(header: Text("AddPrinter").font(.largeTitle)) {
                TextField("ipAdress", text: $ipAdress)
                TextField("username", text: $userName)
                TextField("publicPassword", text: $authPassword)
                TextField("privatePassword", text: $privPassword)
                TextField("Community", text: $community)
                
                //Picker(selection: $authType, label: //Text("Verschlüsselung")) {
                //    Text("SHA256").tag(1)
                //    Text("SHA1").tag(2)
                //    Text("Keine").tag(3)
                //}
                
            }
        }
        .padding()
        .frame(width: 550, height: 300)
        
        
        
        
        HStack {
            // Sieht so aus, weil sonst NSLocalizedString nicht funktioniert.
            Button(action: {
                showSheet = false
            }) {
                Text(NSLocalizedString("Close", comment: ""))
            }
            .padding(.bottom, 20)
            
            
            
            Button(action: {
                if ipAdress != "", authPassword != "", privPassword != "", userName != "" {
                    
                    let newPrinter: Printer = Printer(ipAdress: ipAdress, authPassword: authPassword, privPassword: privPassword, username: userName, community: community)
                    
                    ipAdress = ""
                    userName = ""
                    authPassword = ""
                    privPassword = ""
                    community = ""
                    
                    
                    // Fügt dem Array "allAddedPrinters" der Klasse "cloudKitModel" einen neuen Drucker (Printer-Instanz) hinzu.
                    modelContext.insert(newPrinter)
                    
                    
                    
                    
                    
                    // Setzt die Werte wieder auf einen leeren String, sodass in den TextFields nichts mehr steht
                    //ipAdress = ""
                    //authPassword = ""
                    //privPassword = ""
                    //userName = ""
                    
                        
                    
                    
                }
            }) {
                Text(NSLocalizedString("Hinzufügen", comment: ""))
            }
            .padding(.bottom, 20)
                
        }

    }
}

#Preview {
    @Previewable @State var showSheet = true
        
    AddPrinterView(showSheet: $showSheet, ipAdress: "", userName: "", authPassword: "", privPassword: "", community: "")
}
