//
//  ContentView.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 24.08.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var allPrinters: [Printer]
    
    //@EnvironmentObject var cloudKitModel: CloudKitModel
    
    //@State var allAddedPrinters: [Printer] = cloudKitModel.allAddedPrinters
    
        
    @State var showAddPrinterViewSheet: Bool = false
    
    @State var selectedPrinter: Printer?
    
    
    var body: some View {
            
                
                    
        HStack(alignment: .top) {
            if let selectedPrinter = selectedPrinter {
                PrinterDetailView(printer: selectedPrinter)
                
            }
            
            
            
            
            
            if let selectedPrinter = selectedPrinter {
                StatisticsView(printer: selectedPrinter)
                Spacer()
            } else {
                ContentUnavailableView {
                    Label("Kein Drucker ausgewählt.", systemImage: "printer")
                    Button(NSLocalizedString("AddPrinter", comment: "")) {
                        showAddPrinterViewSheet.toggle()
                    }
                    .sheet(isPresented: $showAddPrinterViewSheet) {
                        AddPrinterView(showSheet: $showAddPrinterViewSheet, ipAdress: "", userName: "", authPassword: "", privPassword: "", community: "")
                    }
                } description: {
                    Text("Wähle oben in der Leiste einen Drucker aus.")
                }
                .padding(.top, 0)
            }
            
        }
        .navigationSplitViewStyle(.prominentDetail)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Menu("Drucker wählen") {
                    ForEach(allPrinters) { printer in
                        Button {
                            selectedPrinter = printer
                        } label: {
                            Text("\(printer.modelName.replacingOccurrences(of: "OctetString:", with: ""))")
                        }
                    }
                    
                    
                }
                
                
                Button(NSLocalizedString("AddPrinter", comment: "")) {
                    showAddPrinterViewSheet.toggle()
                }
                .sheet(isPresented: $showAddPrinterViewSheet) {
                    AddPrinterView(showSheet: $showAddPrinterViewSheet, ipAdress: "", userName: "", authPassword: "", privPassword: "", community: "")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showAddPrinterViewSheet.toggle()
                    }) {
                        Image(systemName: "plus") // Symbol für den Button
                    }
                    .sheet(isPresented: $showAddPrinterViewSheet) {
                        AddPrinterView(showSheet: $showAddPrinterViewSheet, ipAdress: "", userName: "", authPassword: "", privPassword: "", community: "")
                    }
                }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                        if let printerToDelete = selectedPrinter {
                            modelContext.delete(printerToDelete) // Drucker löschen
                            do {
                                try modelContext.save() // Änderungen im Kontext speichern
                                selectedPrinter = nil // Auswahl nach dem Löschen aufheben
                            } catch {
                                print("Fehler beim Löschen: \(error)")
                            }
                        }
                    }) {
                        Image(systemName: "trash") // Symbol für den Löschbutton
                    }
                }
        }
            
            
        
            
        
        
    }
        
}
    

            // Group-Ende
    
        
    
    

#Preview {
    ContentView()
        .frame(width: 800, height:  500)
}

