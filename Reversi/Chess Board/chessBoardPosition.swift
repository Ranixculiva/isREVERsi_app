//
//  chessBoardPosition.swift
//  Reversi
//
//  Created by john gospai on 2018/11/16.
//  Copyright © 2018 john gospai. All rights reserved.
//

import Foundation
struct chessBoardPos: Hashable {
    var row: Int
    var col: Int
    static func == (lhs: chessBoardPos, rhs: chessBoardPos) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }
    init(_ pos: (row: Int, col: Int)){
        row = pos.row
        col = pos.col
    }
    init(row: Int, col: Int){
        self.row = row
        self.col = col
    }
}
