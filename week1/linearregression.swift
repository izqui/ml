import Foundation
import XCPlayground

// Rect function
func h(tetha0: Double, _ tetha1: Double)(_ x: Double) -> Double {
    
    return tetha0 + tetha1*x
}

// Cost function
func j(dataset: [(x: Double, y: Double)])(_ tetha0: Double, _ tetha1: Double) -> Double { 
    
    return 1.0/(2.0*Double(dataset.count))*dataset.map { pow(h(tetha0, tetha1)($0.x) - $0.y, 2) }.reduce(Double.init()) { $0 + $1 }
}

func gradientDescent(dataset: [(x: Double, y: Double)]) -> (Double, Double) {
    
    let alpha: Double = 0.05
    var o0: Double = 0
    var o1: Double = 0
    
    while true {
        
        let newo0 = o0 - alpha * (1.0/Double(dataset.count)) * dataset.map { h(o0, o1)($0.x) - $0.y }.reduce(Double.init()) { $0 + $1 }
        let newo1 = o1 - alpha * (1.0/Double(dataset.count)) * dataset.map { (h(o0, o1)($0.x) - $0.y)*Double($0.x) }.reduce(Double.init()) { $0 + $1 }
        
        guard distance(o0, newo0) > 0.000001 || distance(o1, newo1) > 0.000001 else { break }
        o0 = newo0
        o1 = newo1
    }
    
    return (o0, o1)
    
}

func distance(left: Double, _ right: Double) -> Double {

    return max(left-right, right-left)
}

func represent(name: String, f: Double -> Double) {
    for i in 0..<10 {

        f(Double(i))
    }
}

represent("h", f: h(gradientDescent([(x:1, y:1), (x:2, y:10)])))
