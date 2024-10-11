//
//  PrinterDetailView.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 23.09.2024.
//

import SwiftUI
import Charts

struct PrinterDetailView: View {
    
    var printer: Printer
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("\(printer.modelName)".replacingOccurrences(of: "/P", with: "").replacingOccurrences(of: "OctetString:", with: ""))
                                .font(.system(size: 40, weight: .bold))
                                .padding(.leading, -10)
                                
                            Spacer()
                        }
                        Text("\(printer.ipAdress)")
                            .font(.system(size: 25, weight: .semibold))
                        
                        Divider()
                        
                        Text("Allgemein")
                            .font(.system(size: 21, weight: .semibold))
                        Text("Status: \(NSLocalizedString(printer.printerStatus.replacingOccurrences(of: "OctetString:", with: ""), comment: ""))")
                            .font(.system(size: 16))

                        Text("S/N: \(printer.serialNumber.replacingOccurrences(of: "OctetString:", with: ""))")
                            .font(.system(size: 16))
                        Text("Standort: \(printer.location)".replacingOccurrences(of: "OctetString:", with: ""))
                            .padding(.bottom, 5)
                            .font(.system(size: 16))
                        
                        Text("System")
                            .font(.system(size: 21, weight: .semibold))
                        Text("Läuft seit: \(printer.systemUptime)")
                            .font(.system(size: 16))
                        
                        Text("Firmwareversion: \(printer.mainControllerFirmwareversion.replacingOccurrences(of: "OctetString: Canon iR-ADV C255", with: ""))")
                            .font(.system(size: 16))
                            
                            
                        
                        Button("Sync") {
                             // Wenn die Daten noch nicht geladen wurden
                                    Task {
                                        printer.loadPrinterData()
                                    }
                                
                        }
                        Spacer()
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    // VStack
                    Spacer()
                }
                // VStack
               
            }
            .padding()
            // Group
        }
        

        //.background(Color.blue)
        //.clipShape(.rect(cornerRadius: 10, style: .circular))
    }
}

#Preview {
    PrinterDetailView(printer: Printer(ipAdress: "192.168.100.207", authPassword: "12345678", privPassword: "12345678", username: "Jamie", community: "private"))
}
