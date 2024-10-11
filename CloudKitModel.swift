//
//  CloudKitModel.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 24.08.2024.
//
#if DISABLE_File
import Foundation
import CloudKit
import SwiftUI
import SwiftSnmpKit

// Mit dem Protokoll Hashable wird gemacht, dass es in Set, Dictionaries (mit Schlüssel/Wert) verwendet verweden kann. Zudem kann es sehr gut vergleicht werden, da es einen Hash-Wert besitzt.
// Wie die Struktur in "printers".
struct PrinterModel: Hashable {
    let name: String
    let record: CKRecord
}


class CloudKitModel: ObservableObject {
    
    
    
    @Published var isSignedIntoIcloudAccount: Bool = false
    @Published var error: String?
    @Published var permissionStatus: Bool = false
    @Published var givenName: String = ""
    @Published var recordID: CKRecord.ID?
    static var errorHistory: [String] = []
    @Published var printers: [PrinterModel] = []
    
    @Published var allAddedPrinters: [Printer] = []
    
    
    init() {
        checkIcloudStatus()
        //requestUserPermission()
        fetchiCloudRecordID()
        fetchItems(recordType: "PrinterArray")
    }
    
    
    
    //   func requestUserPermission() {
        //      CKContainer.default().requestApplicationPermission(//[.userDiscoverability]) { returnedStatus, returnedError in //DispatchQueue.main.async {
            //      if returnedStatus == .granted {
                //          self.permissionStatus = true
                //      }
            //  }
            //
            // }
    //}
    
    func fetchiCloudRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] (returnedRecordID, returnedError) in
            if let id = returnedRecordID {
                self?.discoverIcloudUser(id: id)
            }
        }
        
    }

    
    private func discoverIcloudUser(id: CKRecord.ID)  {
        CKContainer.default().fetchUserRecordID { (record, error) in
            CKContainer.default().fetchShareParticipant(withUserRecordID: id) { (userID, error) in DispatchQueue.main.async {
                if let name = userID?.userIdentity.nameComponents?.givenName {
                    self.givenName = name
                } else {
                    CloudKitModel.errorHistory.append("Name not available.")
                }
                
                
                if let error = error {
                    self.error = error.localizedDescription
                    CloudKitModel.errorHistory.append(error.localizedDescription)
                }
            }
                
            }
        }
    }
    
    
    private func checkIcloudStatus() {
        // Verwendet [weak self], um einen starken Referenzzyklus zu verhindern, falls die View deinitialisiert wird, bevor die iCloud-Statusüberprüfung abgeschlossen ist.
        // Die Aufgabe wird dann im Haupt-Thread ausgeführt (mit DispatchQueue.main.async), da UI-Änderungen sicher auf dem Haupt-Thread erfolgen müssen.
        // Der Haupt-Thread wird asynchron verwendet, um sicherzustellen, dass die Aufgabe ausgeführt wird, sonbald der Haupt-Thread nicht mehr beschäftigt ist.
        CKContainer.default().accountStatus { [weak self] accountStatus, error in DispatchQueue.main.async {
            
            if let error = error {
                self?.error = error.localizedDescription
                CloudKitModel.errorHistory.append(error.localizedDescription)
            }
            
            
            switch accountStatus {
            case .available:
                self?.isSignedIntoIcloudAccount = true
                CloudKitModel.errorHistory.append("Signed-In")
            case .couldNotDetermine:
                self?.error = NSLocalizedString("iCloudAccountNotDetermined", comment: "")
            case .noAccount:
                self?.error = NSLocalizedString("iCloudAccountNotFound", comment: "")
            case .restricted:
                self?.error = NSLocalizedString("iCloudAccountRestricted", comment: "")
            case .temporarilyUnavailable:
                self?.error = NSLocalizedString("iCloudAccountTemporarilyUnavailable", comment: "")
            default:
                self?.error = NSLocalizedString("iCloudAccountUnkown", comment: "")
            }
        }
            
            
            
        }
    }
    
    //"String"/"rawValue" bedeutet, der Name des "case"
    
    
    public func newItem(printerData: Data, recordName: String, recordType: String) {
        let newPrinter = CKRecord(recordType: "PrinterArray")
        newPrinter[recordName] = printerData
        saveItem(record: newPrinter)
    }
    
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().privateCloudDatabase.save(record) { returnedRecord, returnedError in
            
            print("Record: \(returnedRecord)")
            print("Error: \(returnedError)")
            self.fetchItems(recordType: "PrinterArray")
        }
    }
    
    
    
    func fetchItems(recordType: String) {
        
        // Filter
        let predicate = NSPredicate(value: true) // gibt alle Datensätze zurück, die mit dem angegebenen RecordType übereinstimmen
        // Abfrage-Struktur
        let query = CKQuery(recordType: recordType, predicate: predicate)
        // Damit ein Record bzw. ein Feld darint sortiert werden kann, muss man es in der CloudKit-Weboberfläche "sortable" machen. Wenn "ascending = false" in Kombination mit sortieren nach Datum, dann wird das als letztes hinzugefügte Item zuoberst angezeigt. In diesem Fall wird die Query sortiert. Man kann aber auch mit ".sort" das Array mit den gefetchten Items am Ende sortieren.
        //query.sortDescriptors = [NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>)]
        // Abfrage
        let queryOperation = CKQueryOperation(query: query)
        //queryOperation.resultsLimit = Int / Maximal ist aber immer 100 (sonst Cursor verwenden)
        
        var returnedItems: [Data] = []
        
        
        // Wird jedes Mal ausgeführt, wenn ein Record erfolgreich gefunden wurde
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in DispatchQueue.main.async {
            
            print("recordMatchedBlock aufgerufen")
            
            switch returnedResult {
            case .success(let record):
                guard let name = record["ArrayOfAddedPrinters"] as? String else { return } // Schaut, ob der aktuelle Record den Schlüssel "PrinterData" hat und castet ihn gegegebenfalls in einen String um.
                returnedItems.append(name.data(using: .utf8)!)
            case .failure(let error):
                print("RETURNED ERROR: \(error)")
            }
            
            
            let dataArray: [Data] = returnedItems  // Hier sollte dein Array von Data-Objekten sein
            

            // Das Array von Data in das ursprüngliche Array von Printer-Objekten umwandeln
            do {
                let decoder = JSONDecoder()
                var printerArray: [Printer] = []
                
                for data in dataArray {
                    let printers = try decoder.decode([Printer].self, from: data)
                    printerArray.append(contentsOf: printers)
                }
                
                self.allAddedPrinters = printerArray
                
                // Jetzt hast du ein Array von Printer-Objekten

                
            } catch {
                print("Fehler beim Dekodieren: \(error)")
            }
        }
        }
        
        // Wird ausgeführt, wenn die gesamte Abfrage fertig ist.
        // Ein Cursor wird verwendet, wenn es zu viele abgerufene Daten gibt. Dann werden z. B. nur mal 50 Objekte "angezeigt". Die anderen Objekte befinden sich dann auf den anderen "Seiten" oder "Seite". Deswegen ist der Cursor auch optional. Er dient dazu, die Ressourcen des Geräts zu schonen.
        queryOperation.queryResultBlock = { [weak self] returnedResult in DispatchQueue.main.async {
            print("RETURNED RESULTBLOCK: \(returnedResult)")
            
            // muss auf dem Main-Thread erfolgen, da es die UI beeinflusst.
            
            
            
        }
        }
        
        
        addOperation(operation: queryOperation) // bezieht sich auf "let queryOperation". Die Completionshandler (queryOperation) im "Exil" (siehe gerade eines oben), bereiten die "queryOperation" nur vor. "addOperation" führt sie danach wirklich aus.
        
    }
    
    
    func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    
    
    func updateItem(printer: PrinterModel) {
        let record = printer.record
        record["PrinterArray"] = printer.name // hat Schlüssel/Wert wegen Protokoll "Hashable".
        saveItem(record: record)
    }
}
//Klassen-Ende








struct ErrorViewer: View {
    @ObservedObject var cloudKitModel = CloudKitModel()
    var printer02 = Printer(ipAdress: "192.168.100.207", authPassword: "12345678", privPassword: "12345678", username: "Jamie")
    //ohne Neuinit.: @ObservedObject var cloudKitModel = CloudKitModel()
    
    
    @State var text: String = ""
    @State var moin: ResponseType
    
    
    
    
    
    
    var body: some View {
        
        List {
            ForEach(cloudKitModel.printers, id: \.self) { printer in
                Text(printer.name)
            }
        }
        
        if cloudKitModel.isSignedIntoIcloudAccount {
            Text(NSLocalizedString("iCloudConnected", comment: ""))
            Text("PermissionStatus: \(cloudKitModel.permissionStatus.description.uppercased())")
            Text("Error-Histroy: \(CloudKitModel.errorHistory)")
            Text("Name: \(cloudKitModel.givenName)")
            Text("Wert: \(moin)")
        } else {
            Text(cloudKitModel.error ?? "Error")
        }
        Button("Send SNMP-Request") {
            // Task ist eine Umgebung, in der asynchrone Aufgaben ausgeführt werden können
            Task {
                //moin = try await printer02.getLocation()
            }
        }
        

        
        
        TextField("Schreibe...", text: $text)
        
        
    }
}

#endif
