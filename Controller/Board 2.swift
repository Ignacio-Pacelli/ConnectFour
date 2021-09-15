//
//  Board.swift
//  ConnectFour
//
//  Created by Nacho Pacelli on 9/9/21.
//

import UIKit

class Board: NSObject {

    enum ChipColor: Int {
        case none = 0
        case color1
        case color2
    }
    
    var placedChips = [[UIView]]()
    var board: Board!
    
    static var width = 7
    static var height = 6
    
    
    var slots = [ChipColor]()

    override init() {
        for _ in 0 ..< Board.width * Board.height {
            slots.append(.none)
        }

        super.init()
    }
    
    func chip(inColumn column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }

    func set(chip: ChipColor, in column: Int, row: Int) {
        slots[row + column * Board.height] = chip
    }
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< Board.height {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }

        return nil
    }
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    func add(chip: ChipColor, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }
    
    
}
