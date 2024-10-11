import Foundation
import SwiftSnmpKit

//var cloudKitModel = CloudKitModel()


// Typen die als SNMP-Antwort zurückkommen können. Das Enum ist public, da die Typen des Enums für die Funktion gebraucht werden, welche ja public ist.
public enum ResponseType {
    case stringType(String)
    case asnValueType(AsnValue)
    case oidType(SnmpOid)
    case int(Int)
}




//public let shared: SnmpSender? = try? SnmpSender()
//let snmpSender = SnmpSender.shared

// "Result" unterscheidet zwischen "Success" und "Failure". Zudem muss nicht nur die Function public sein, sondern auch das enum.
public func sendARequest(ip: String, command: SnmpPduType, community: String, oid: String, authPassword: String, privPassword: String, username: String) async -> ResponseType {
    
    let host: String = ip
    let command: SnmpPduType = .getRequest
    let community: String
    let oid: String = oid
    let username: String = username
    let authType: SnmpV3Authentication = .sha1
    let authPassword: String = authPassword
    let privPassword: String = privPassword
    
    
    
    guard let snmpSender = SnmpSender.shared else {
        fatalError("Snmp Sender not inialized")
    }
    
    
    let result = await snmpSender.send(host: host, userName: username, pduType: command, oid: oid, authenticationType: authType, authPassword: authPassword, privPassword: privPassword)
        
        // Error-Handling (result beinhaltet bereits das andere "Result<>", was die Funktion benötigt. Es hat also bereit Success (SnmpVariableBinding und any Error).
        switch result {
        case .success(let variableBinding):
            print("SNMP-Request succeeded: \(variableBinding)")
            return .asnValueType(variableBinding.value)
        case .failure(let error):
            print("SNMP-Request failed: \(error.localizedDescription)")
            return .stringType("Der SNMP-Sendevorgang hat nicht funktioniert.")
        }
        
        
    
        
    
    
    
    
}
    






