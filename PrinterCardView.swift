//
//  PrinterCardView.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 21.09.2024.
//

import SwiftUI
import SwiftData
import Charts

struct PrinterCardView: View {
    
    var printer: Printer
    
    func convertStringToInt(_ string: String) -> Int {
        let normalString = string
        let range = normalString.range(of: "\\d+", options: .regularExpression)
        let numberString = String(normalString[range!])
        if let onlyNumber = Int(numberString) {
            return onlyNumber
        } else {
            print("String-Convert-Error")
            return 0
        }
    }
    
    
    func creatArrayOfIntsForChart(number: Int) -> [Int] {
        var arrayOfInts: [Int] = []
        
        let realNumberSubtractedFrom100: Int = 100 - number
        
        arrayOfInts = [number, realNumberSubtractedFrom100]
        
        var id = UUID()
        
        return arrayOfInts
    }
    
    
    
    
    
    var body: some View {
        

        
        
        
        
        
        VStack {
            ScrollView {
                
                    
                    //var tonerLevelBlack = printer.tonerLevelBlack
                    VStack(alignment: .leading) {
                        Group {
                            VStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("\(printer.modelName.replacingOccurrences(of: "OctetString:", with: ""))")
                                            .font(.largeTitle)
                                        Spacer()
                                    }
                                    Text("\(printer.ipAdress)")
                                        .font(.title2)
                                    Text("Status: \(NSLocalizedString(printer.printerStatus.replacingOccurrences(of: "OctetString:", with: ""), comment: ""))")

                                    Text("S/N: \(printer.serialNumber.replacingOccurrences(of: "OctetString:", with: ""))")
                                    Text("Standort: \(printer.location.replacingOccurrences(of: "OctetString:", with: ""))")
                                        .padding(.bottom, 5)
                                    
                                    Button("Sync") {
                                         // Wenn die Daten noch nicht geladen wurden
                                                Task {
                                                    printer.loadPrinterData()
                                                }
                                            
                                    }
                                    
                                    
                                    
                                }
                                
                                let arrayForChartBlackTonerLevel: [Int] = [convertStringToInt(printer.tonerLevelBlack), (100 - convertStringToInt(printer.tonerLevelBlack))]
                                
                                let arrayForChartMagentaTonerLevel: [Int] = [convertStringToInt(printer.tonerLevelMagenta), (100 - convertStringToInt(printer.tonerLevelMagenta))]
                                
                                let arrayForChartYellowTonerLevel: [Int] = [convertStringToInt(printer.tonerLevelYellow), (100 - convertStringToInt(printer.tonerLevelYellow))]
                                
                                let arrayForChartCyanTonerLevel: [Int] = [convertStringToInt(printer.tonerLevelCyan), (100 - convertStringToInt(printer.tonerLevelCyan))]
                                
                                
                                
                                HStack {
                                    Chart(arrayForChartBlackTonerLevel, id: \.self) { number in
                                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                                            .cornerRadius(4)
                                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelBlack) ? Color.black : Color.gray.opacity(0.0))
                                            
                                    }
                                    .chartLegend(.hidden)
                                    
                                    
                                    Chart(arrayForChartMagentaTonerLevel, id: \.self) { number in
                                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                                            .cornerRadius(4)
                                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelMagenta) ? Color.pink : Color.gray.opacity(0.0))
                                    }
                                    .chartLegend(.hidden)
                                    
                                    Chart(arrayForChartYellowTonerLevel, id: \.self) { number in
                                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                                            .cornerRadius(4)
                                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelYellow) ? Color.yellow : Color.gray.opacity(0.0))
                                    }
                                    .chartLegend(.hidden)
                                    
                                    Chart(arrayForChartCyanTonerLevel, id: \.self) { number in
                                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                                            .cornerRadius(4)
                                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelCyan) ? Color.cyan : Color.gray.opacity(0.0))
                                    }
                                    .chartLegend(.hidden)
                                }
                            }
                        }
                        .padding()
                    }
                    

                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 10, style: .circular))
                    
                    
                    
                        
                        //Text("\(convertStringToInt(printer.tonerLevelBlack))")
                        
                    

                    
                    
                }
                // ForEach-Ende
            }
        .frame(minWidth: 330 ,maxWidth: 350, maxHeight: 500)
        .padding(14)
        
        }
        
    }
    

#Preview {
    PrinterCardView(printer: Printer(ipAdress: "192.168.100.207", authPassword: "12345678", privPassword: "12345678", username: "Jamie", community: "private"))
}
