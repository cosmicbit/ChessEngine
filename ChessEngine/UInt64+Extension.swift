//
//  UInt64+Extension.swift
//  ChessEngine
//
//  Created by Philips Jose on 08/04/26.
//

extension UInt64 {
    // Get bit at index (0-63)
    func getBit(at index: Int) -> Bool {
        return (self & (1 << index)) != 0
    }
    
    // Set bit at index to 1
    mutating func setBit(at index: Int) {
        self |= (1 << index)
    }
    
    // Clear bit at index to 0
    mutating func clearBit(at index: Int) {
        self &= ~(1 << index)
    }
    
    // Count population (number of pieces)
    var popCount: Int {
        return self.nonzeroBitCount
    }
}
