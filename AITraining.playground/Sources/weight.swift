import Foundation

public struct Weight: CustomStringConvertible{
    public var description: String{
        var des = "\n"
        des += " scoreDifferenceWeight: \(scoreDifferenceWeight)\n"
        des += " sideWeight: \(sideWeight)\n"
        des += " CWeight: \(CWeight)\n"
        des += " XWeight: \(XWeight)\n"
        des += " cornerWeight: \(cornerWeight)\n"
        return des
        
    }
    public var scoreDifferenceWeight: Int
    public var sideWeight: Int
    public var CWeight: Int
    public var XWeight: Int
    public var cornerWeight: Int
    public init(scoreDifferenceWeight: Int = 1,
        sideWeight: Int = 2,
        CWeight: Int = 5,
        XWeight: Int = 20,
        cornerWeight: Int = 50){
        self.scoreDifferenceWeight = scoreDifferenceWeight
        self.sideWeight = sideWeight
        self.CWeight = CWeight
        self.XWeight = XWeight
        self.cornerWeight = cornerWeight
    }
    public static func random() -> Weight{
//        let scoreDifferenceWeight = Array(1...5).randomElement()!
//        let sideWeight = Array(1...5).randomElement()!
//        let CWeight = Array(1...10).randomElement()!
//        let XWeight = Array(15...25).randomElement()!
//        let cornerWeight = Array(30...60).randomElement()!
        //let scoreDifferenceWeight = Array(1...60).randomElement()!
        let sideWeight = Array(1...60).randomElement()!
        let CWeight = Array(1...60).randomElement()!
        let XWeight = Array(1...60).randomElement()!
        let cornerWeight = Array(1...60).randomElement()!
        return Weight(
            scoreDifferenceWeight: 1,
            sideWeight: sideWeight,
            CWeight: CWeight,
            XWeight: XWeight,
            cornerWeight: cornerWeight)
       
    }
}
