
import ArgumentParser
import NIO
import NIOHTTP1
import Foundation
import RadoSmallServer

@main
struct StatsPackage: ParsableCommand {
    
    mutating func run() throws {
        
        let pingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            print("ping timer")
            
            let request = URLRequest(url: URL(string: "http://localhost:17443/ping")!)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: DelegateHandler4(), delegateQueue: nil)
            session.dataTask(with: request) { _, _ , _ in }.resume()
        }
        
        let reportTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            print("report timer")
            
            let nMetrics = NMetrics.current.metricsArr.sorted()
            let metricsForSave = FullMetrics()
            
            if !nMetrics.isEmpty {
                metricsForSave.max = nMetrics[nMetrics.count - 1]
                metricsForSave.min = nMetrics[0]
                metricsForSave.avg = nMetrics.reduce(0, +) / Double(nMetrics.count)
                
                do {
                    let jsonData = try JSONEncoder().encode(metricsForSave)
                    
                    do {
                        let date = Date()
                        let components = Calendar.current.dateComponents([.day, .hour], from: date)
                        let newFormatter = ISO8601DateFormatter()
                        let dateString = newFormatter.string(from: date)
                        
                        let fileManager = FileManager.default
                        try fileManager.createDirectory(
                            at: URL(fileURLWithPath:"/Users/radoslavpenev/Development/exampleReports/\(components.day ?? 0)/\(components.hour ?? 0)"), withIntermediateDirectories: true)
                        
                        let url = URL(fileURLWithPath: "/Users/radoslavpenev/Development/exampleReports/\(components.day ?? 0)/\(components.hour ??  0)/\(dateString).json")
                        try jsonData.write(to: url)
                        
                    } catch {
                        print(error)
                    }
                    
                } catch  {
                    print(error)
                }
            }
        }
        
        RunLoop.current.add(pingTimer, forMode: .default)
        RunLoop.current.add(reportTimer, forMode: .default)
        RunLoop.current.run()
        
        try RadoSmallServer(path: "/stats", method: .GET, type: .json, port: 18443) {
            let fullMetrics = try? JSONEncoder().encode(FullMetrics.current)
            return fullMetrics!
        }.start()
    }
}


