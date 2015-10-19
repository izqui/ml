import Foundation
import XCPlayground

extension Array {
    
    func mapSum(f: Element -> Double) -> Double {
        
        return self.map(f).reduce(Double()) { $1 + $0 }
    }
}

func h(tetha: [Double])(_ x: [Double]) -> Double {
    
    return Array(zip(tetha, x)).mapSum { $0*$1 }
}

// Dataset is organized: x0, x1, x2, ..., xn, y
func j(dataset: [[Double]])(tetha: [Double]) -> Double {
    
    let thesum: [Double] -> Double = {
        sample in
        
        let features = sample.count - 1
        let xs: [Double] = Array(sample[0..<features])
        let y: Double = sample[features]
        
        return pow(h(tetha)(xs) - y, 2)
    }
    
    // return 1.0/(2.0*Double(dataset.count)) * dataset.mapSum { pow(h(tetha)(Array($0[0..<$0.count-1])) - $0[$0.count-1], 2) }
    return 1.0/(2.0*Double(dataset.count)) * dataset.mapSum(thesum) // Compiler can't take it inline :(
}

func distanceDouble(left: Double, _ right: Double) -> Double {
    
    return max(left-right, right-left)
}

func gradientDescent(alpha: Double)(_ dataset: [[Double]]) -> [Double] {
    
    let features = dataset[0].count - 1
    
    var o = [Double](count: features+1, repeatedValue: 0)
    
    let thesum: ([Double], Int) -> ([Double] -> Double) = {
        (tetha, i) in
        return {
            sample in
            
            let features = sample.count - 1
            let xs: [Double] = Array(sample[0..<features])
            let y: Double = sample[features]
            
            return (h(tetha)(xs) - y)*sample[i]
        }
    }
    
    while true {
        
        let newo = Array(zip(o, Array(0...features))).map {
            tetha, i in
            return tetha - alpha * (1.0/Double(dataset.count)) * dataset.mapSum(thesum(o, i))
        }
        
        let remaining = Array(zip(o, newo)).map(distanceDouble).filter { $0 > 0.00001}
        guard remaining.count > 0 else { break }
        o = newo
    }
    
    return o
    
}

gradientDescent(0.05)([[1, 0, 0], [1, 2, 7]])

