//
//  BarChart.swift
//  PrintGuard
//
//  Created by Jamie Gerber on 17.09.2024.
//

import SwiftUI
import Charts

//var tests: [Int] = [4, 5, 3, 4, 2, 3, 4, 1, 9, 7]



struct test: Identifiable, Hashable {
    var id = UUID()
    var dateString: String
    
    // wichtig ist hier der "return"
    var date: Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        return dateformatter.date(from: dateString) ?? Date()
    }
    
    
    
    var count: Int
}

var all: [test] = [test(dateString: "12.11.2024", count: 2), test(dateString: "13.11.2024", count: 2), test(dateString: "14.11.2024", count: 2), test(dateString: "15.11.2024", count: 2), test(dateString: "16.11.2024", count: 1), test(dateString: "16.11.2024", count: 5), test(dateString: "17.11.2024", count: 3), test(dateString: "18.11.2024", count: 5), test(dateString: "19.11.2024", count: 7), test(dateString: "19.11.2024", count: 7)]


struct BarChart: View {
    var body: some View {
        Chart {
            
            ForEach(all) { test in
                BarMark(
                    x: .value("Test01", test.date, unit: .day),
                    y:.value("Test02", test.count)
                )
            }
                
            }
        .frame(width: 500, height: 250)
        }
    }


#Preview {
    BarChart()
}
