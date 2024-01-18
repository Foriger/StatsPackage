import Foundation

class DelegateHandler4: NSObject, URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        collectNMetrics(metrics)
        collectFullMetrics(metrics)
    }
    
    private func collectFullMetrics(_ metrics: URLSessionTaskMetrics) {
        let metricsForSave = FullMetrics.current
        
        if metrics.taskInterval.duration < metricsForSave.min {
            metricsForSave.min = metrics.taskInterval.duration
        }
        
        if metrics.taskInterval.duration > metricsForSave.max {
            metricsForSave.max = metrics.taskInterval.duration
        }
        
        metricsForSave.avg = (metricsForSave.max + metricsForSave.min) / 2.0
    }
    
    
    private func collectNMetrics(_ metrics: URLSessionTaskMetrics){
        let currentMetrics = NMetrics.current
        
        if currentMetrics.metricsArr.count == 5 {
            currentMetrics.metricsArr.remove(at: 0)
        }
        currentMetrics.metricsArr.append(metrics.taskInterval.duration)
        
    }
}
