import SwiftUI
import Charts

struct StatisticsView: View {
    
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
    
    
    
    
    var printer: Printer
    
    var body: some View {
        let arrayForChartBlackTonerLevel = [convertStringToInt(printer.tonerLevelBlack), (100 - convertStringToInt(printer.tonerLevelBlack))]
        
        let arrayForChartMagentaTonerLevel = [convertStringToInt(printer.tonerLevelMagenta), (100 - convertStringToInt(printer.tonerLevelMagenta))]
        
        let arrayForChartYellowTonerLevel = [convertStringToInt(printer.tonerLevelYellow), (100 - convertStringToInt(printer.tonerLevelYellow))]
        
        let arrayForChartCyanTonerLevel = [convertStringToInt(printer.tonerLevelCyan), (100 - convertStringToInt(printer.tonerLevelCyan))]
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 25) {
                Spacer()
                VStack {
                    Text("\(printer.printCountColor.replacingOccurrences(of: "Counter32:", with: ""))")
                        .font(.system(size: 34))
                        .padding(.top, 15)
                        .padding(.bottom, 50)
                        .padding(.trailing, 3)
                    Text("Zähler total")
                        .font(.title)
                        .padding(.top, -50)
                        .padding(.leading, 3)
                        .padding(.trailing, 3)
                }
                .frame(width: 125, height: 125)
                .foregroundColor(.black)
                .background(Color(red: 34/255, green: 147/255, blue: 199/255))
                .cornerRadius(15)
                .shadow(radius: 10)
                
                VStack(alignment: .center) {
                    Text("\(printer.printsSinceLastBootUp.replacingOccurrences(of: "Counter32:", with: "").replacingOccurrences(of: " ", with: ""))")
                        .font((convertStringToInt(printer.printsSinceLastBootUp
                               .replacingOccurrences(of: "Counter32:", with: "")
                               .replacingOccurrences(of: " ", with: "")) < 100)
                               ? .system(size: 70) : .system(size: 80))

                        .padding(.top, 8)
                        
                    Text("Zähler seit letztem Start")
                        .font(.system(size: 15))
                        .font(.title)
                        
                        .padding(.top, -50)
                }
                .frame(width: 125, height: 125)
                .foregroundColor(.black)
                .background(Color(red: 204/255, green: 56/255, blue: 56/255))
                .cornerRadius(15)
                .shadow(radius: 10)
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, 14)
            .padding(.bottom, 30)
            
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                if convertStringToInt(printer.tonerLevelBlack) < 25 {
                    Chart(arrayForChartBlackTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelBlack) ? Color.black : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(color: .red, radius: 20)
                    .chartLegend(.hidden)
                } else {
                    Chart(arrayForChartBlackTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelBlack) ? Color.black : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(radius: 20)
                    .chartLegend(.hidden)
                }
                
                if convertStringToInt(printer.tonerLevelMagenta) < 25 {
                    Chart(arrayForChartMagentaTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelMagenta) ? Color.pink : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(color: .red, radius: 20)
                    .chartLegend(.hidden)
                } else {
                    Chart(arrayForChartMagentaTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelMagenta) ? Color.pink : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(radius: 20)
                    .chartLegend(.hidden)
                }
                
                if convertStringToInt(printer.tonerLevelYellow) < 25 {
                    Chart(arrayForChartYellowTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelYellow) ? Color.yellow : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(color: .red, radius: 20)
                    .chartLegend(.hidden)
                } else {
                    Chart(arrayForChartYellowTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelYellow) ? Color.yellow : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(radius: 20)
                    .chartLegend(.hidden)
                }
                
                if convertStringToInt(printer.tonerLevelCyan) < 25 {
                    Chart(arrayForChartCyanTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelCyan) ? Color.cyan : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(color: .red, radius: 20)
                    .chartLegend(.hidden)
                } else {
                    Chart(arrayForChartCyanTonerLevel, id: \.self) { number in
                        SectorMark(angle: .value("Anteil", number), angularInset: 2)
                            .cornerRadius(4)
                            .foregroundStyle(number == convertStringToInt(printer.tonerLevelCyan) ? Color.cyan : Color.gray.opacity(0.0))
                    }
                    .frame(width: 125, height: 125)
                    .shadow(radius: 20)
                    .chartLegend(.hidden)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, 14)
        .padding(.trailing, 14)
    }
}

#Preview {
    StatisticsView(printer: Printer(ipAdress: "192.168.100.207", authPassword: "12345678", privPassword: "12345678", username: "Jamie", community: "private"))
}
