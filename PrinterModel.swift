//
//  PrinterModel.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 31.08.2024.
//

import Foundation
import SwiftSnmpKit
import SwiftUI
import SwiftData
import Charts


// Falls CloudKit verwendet werden soll, muss "Printer" "Codable" sein
@Model
public class Printer: Identifiable {
    
    func convertStringToInt(_ string: String) -> Int {
            let normalString = string
            let range = normalString.range(of: "\\d+", options: .regularExpression)
            if let range = range {
                let numberString = String(normalString[range])
                if let onlyNumber = Int(numberString) {
                    return onlyNumber
                } else {
                    print("String-Convert-Error")
                    return 0
                }
            } else {
                return 1
            }

            
    }
    
    
    public var id = UUID()
    @Attribute var ipAdress: String
    @Attribute var authPassword: String
    @Attribute var privPassword: String
    @Attribute var username: String
    
    
    @Attribute var modelName: String = "Lädt..."
    @Attribute var serialNumber: String = "Lädt..."
    @Attribute var location: String = "Lädt..."
    @Attribute var printCountColor: String = "0"
    @Attribute var printsSinceLastBootUp: String = "0"
    @Attribute var tonerLevelBlack: String = "0"
    @Attribute var tonerLevelMagenta: String = "0"
    @Attribute var tonerLevelYellow: String = "0"
    @Attribute var tonerLevelCyan: String = "0"
    @Attribute var printerStatus: String = "Nicht erreichbar"
    @Attribute var systemUptime: String = "Lädt..."
    @Attribute var mainControllerFirmwareversion: String = "Lädt..."
    @Attribute var community: String
    
    @Attribute var printCountsOfLast30Logons: [Int: Date] = [:]

    init(ipAdress: String, authPassword: String, privPassword: String, username: String, community: String) {
        self.ipAdress = ipAdress
        self.authPassword = authPassword
        self.privPassword = privPassword
        self.username = username
        self.community = community
        
    
        //loadPrinterData()
        
        
        
        
    }
    
    func loadPrinterData() { DispatchQueue.main.async { [self] in
        Task {
            do {
                modelName = try await self.getModelName()
                serialNumber = try await self.getSerialNumber()
                location = try await self.getLocation()
                printCountColor = try await self.getPrintCountColor()
                printsSinceLastBootUp = try await self.getPrintsSinceLastBootUp()
                tonerLevelBlack = try await self.getTonerlevelBlack()
                tonerLevelMagenta = try await self.getTonerlevelMagenta()
                tonerLevelYellow = try await self.getTonerlevelYellow()
                tonerLevelCyan = try await self.getTonerlevelCyan()
                printerStatus = try await self.getPrinterStatus()
                systemUptime = try await self.getSystemUptime()
                mainControllerFirmwareversion = try await self.getMainControllerFirmwareVersion()
            } catch {
                print("Fehler beim Abrufen der Druckerdaten: \(error)")
            }
            }
        }
    }
    
    func getSystemUptime() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.25.1.1.0", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
            let newString = str.split(separator: ":").last?.trimmingCharacters(in: .symbols) ?? "Not available"
            print("\(newString)")
            return newString
            case .int(let number):
            print("\(345675)")
                return "\(number)"
            case .asnValueType(let asnValue):
            let newString = "\(asnValue)".trimmingCharacters(in: .letters)
            let newString02 = newString.split(separator: " ").last?.trimmingCharacters(in: .symbols) ?? "Not available"
            
                if let newInt = Int(newString02) {
                    if newInt >= 3600000 {
                        let hours = newInt / 360000
                        return "\(hours)h"
                    } else {
                        let minutes = newInt / 6000
                        return "\(minutes)min"
                    }
                } else {
                    return "Not available"
                }
                
            
                  // Hier musst du evtl. den `AsnValue` zu einem String formatieren
            case .oidType(let oid):
            print("\(444)")
                return "\(oid)"  // Auch hier kannst du das `SnmpOid` Objekt entsprechend darstellen
        }
    }
    // Durch throws kann die Funktion Fehler weitergeben (also als return-Wert haben)
    func getModelName() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.1.1.0", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                let newString = str.replacingOccurrences(of: "OctetString:", with: "")
            return newString.replacingOccurrences(of: "/P", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"
            case .oidType(let oid):
                return "\(oid)"
        }
    }
    
    func getPrinterStatus() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.43.16.5.1.2.1.1", authPassword: authPassword, privPassword: privPassword, username: username)
    
    
        // hier wird auf dem response geswitched, damit ich dann im Contentview einen String habe, welchen ich in der ForEach-Schleife verwenden kann.
        switch response {
            case .stringType(let str):
            return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
            return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"  // Hier musst du evtl. den `AsnValue` zu einem String formatieren
            case .oidType(let oid):
                return "\(oid)"  // Auch hier kannst du das `SnmpOid` Objekt entsprechend darstellen
        }
        
    }
    
    func getSerialNumber() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.43.5.1.1.17.1", authPassword: authPassword, privPassword: privPassword, username: username)
        
        
        switch response {
            case .stringType(let str):
                return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"  // Hier musst du evtl. den `AsnValue` zu einem String formatieren
            case .oidType(let oid):
                return "\(oid)"  // Auch hier kannst du das `SnmpOid` Objekt entsprechend darstellen
        }
    }
    
    func getLocation() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.1.6.0", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"  // Hier musst du evtl. den `AsnValue` zu einem String formatieren
            case .oidType(let oid):
                return "\(oid)"  // Auch hier kannst du das `SnmpOid` Objekt entsprechend darstellen
        }
    }
    
    
    func getPrintsSinceLastBootUp() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.43.10.2.1.5.1.1", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                self.printCountsOfLast30Logons[convertStringToInt(str)] = Date()
                print("\(str)")
                return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"  // Hier musst du evtl. den `AsnValue` zu einem String formatieren
            case .oidType(let oid):
                return "\(oid)"  // Auch hier kannst du das `SnmpOid` Objekt entsprechend darstellen
        }
        
        
    }
    
    func getTonerlevelBlack() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: ".1.3.6.1.2.1.43.11.1.1.9.1.1", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"
            case .oidType(let oid):
                return "\(oid)"
        }
    }
    
    func getTonerlevelMagenta() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: ".1.3.6.1.2.1.43.11.1.1.9.1.4", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"
            case .oidType(let oid):
                return "\(oid)"
        }
    }
    
    func getTonerlevelYellow() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: ".1.3.6.1.2.1.43.11.1.1.9.1.3", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"
            case .oidType(let oid):
                return "\(oid)"
        }
    }
    
    func getTonerlevelCyan() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: ".1.3.6.1.2.1.43.11.1.1.9.1.2", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                return str.replacingOccurrences(of: "OctetString:", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"
            case .oidType(let oid):
                return "\(oid)"
        }
    }

    
    func getMainControllerFirmwareVersion() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.25.3.2.1.3.1", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                print("\(str)")
                return str.replacingOccurrences(of: "OctetString: Canon iR-ADV C255", with: "")
            case .int(let number):
                return "\(number)"
            case .asnValueType(let asnValue):
                return "\(asnValue)"
            case .oidType(let oid):
                return "\(oid)"
        }
        
        
    }
    

    
    func getPrintCountColor() async throws -> String {
        let response = await sendARequest(ip: ipAdress, command: .getRequest, community: community, oid: "1.3.6.1.2.1.43.10.2.1.4.1.1", authPassword: authPassword, privPassword: privPassword, username: username)
        
        switch response {
            case .stringType(let str):
                print("LOO: \(str)")
                return str.replacingOccurrences(of: "Counter32:", with: "")
            case .int(let number):
                print("int: \(number)")
                return "\(number)"
        case .asnValueType(let asnValue):
            if let intValue = Int(asnValue.description.replacingOccurrences(of: "Counter32:", with: "")) {
                print("asnValue (Counter32): \(intValue)")
                return "\(intValue)"
            } else {
                print("asnValue: \(asnValue.description)")
                return asnValue.description
            }


            case .oidType(let oid):
                let testvsn = "\(oid)"
                print("oid: \(testvsn)")
            
                return String(testvsn)  
        }
        
        
    }
    
    
    
    
    
    
}


struct testView: View {
    
    
    
    var body: some View {
        
        Text("")
    }
}
