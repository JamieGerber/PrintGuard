//
//  printCountBlackChart.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 22.09.2024.
//
#if FILE_Disabled
import SwiftUI
import Charts
import SwiftData

struct printCountBlackChart: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var allPrinters: [Printer]
    
    var sort: [(Date, Int)] = []
    
    
    
    
    var body: some View {
        ForEach(allPrinters) { printer in
            ForEach(printer.printCountsOfLast30Logons.sorted(by: { $0.key < $1.key } ), id: \.key) { key, value in
                
                Text("\(key)")
                
            }
        }
            
        
    }
}

#Preview {
    printCountBlackChart()
}
#endif
