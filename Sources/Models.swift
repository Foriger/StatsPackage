import Foundation

class NMetrics: Codable {
    static let current = NMetrics()
    
    var metricsArr: [Double] = [Double]()
}

class FullMetrics: Codable {
    static let current = FullMetrics()
    
    var min: Double
    var max: Double
    var avg: Double
    
    init() {
        self.min = Double.infinity
        self.max = 0.0
        self.avg = 0.0
    }
}
