//
//  ChessProtocols.swift
//  ChessEngine
//
//  Created by Philips Jose on 08/04/26.
//

import Foundation

public protocol ChessServiceDelegate: AnyObject {
    
    // Reads: "Chess service did update board with FEN"
    func chessService(_ service: ChessService, didUpdateBoard fen: String, error: ChessError?)
    
    // Reads: "Chess service did find best move"
    func chessService(_ service: ChessService, didFindBestMove move: String, error: ChessError?)
    
    // Reads: "Chess service did end game with winner"
    func chessService(_ service: ChessService, didGameOver winner: String?, error: ChessError?)
}

public extension ChessServiceDelegate {
    
    // Reads: "Chess service did start running"
    func chessService(_ service: ChessService, didStart running: Bool, error: ChessError?) {}
}
