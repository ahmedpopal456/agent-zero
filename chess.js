// Chess piece Unicode symbols
const PIECES = {
    white: {
        king: '♔',
        queen: '♕',
        rook: '♖',
        bishop: '♗',
        knight: '♘',
        pawn: '♙'
    },
    black: {
        king: '♚',
        queen: '♛',
        rook: '♜',
        bishop: '♝',
        knight: '♞',
        pawn: '♟'
    }
};

// Game state
let board = [];
let currentPlayer = 'white';
let selectedSquare = null;
let validMoves = [];

// Initialize the board with starting positions
function initializeBoard() {
    board = [
        ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜'],
        ['♟', '♟', '♟', '♟', '♟', '♟', '♟', '♟'],
        ['', '', '', '', '', '', '', ''],
        ['', '', '', '', '', '', '', ''],
        ['', '', '', '', '', '', '', ''],
        ['', '', '', '', '', '', '', ''],
        ['♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙'],
        ['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖']
    ];
    currentPlayer = 'white';
    selectedSquare = null;
    validMoves = [];
}

// Get piece color
function getPieceColor(piece) {
    if (!piece) return null;
    if (Object.values(PIECES.white).includes(piece)) return 'white';
    if (Object.values(PIECES.black).includes(piece)) return 'black';
    return null;
}

// Get piece type
function getPieceType(piece) {
    for (let color in PIECES) {
        for (let type in PIECES[color]) {
            if (PIECES[color][type] === piece) return type;
        }
    }
    return null;
}

// Calculate valid moves for a piece
function getValidMoves(row, col) {
    const piece = board[row][col];
    const pieceType = getPieceType(piece);
    const pieceColor = getPieceColor(piece);
    const moves = [];

    if (!piece || pieceColor !== currentPlayer) return moves;

    switch (pieceType) {
        case 'pawn':
            const direction = pieceColor === 'white' ? -1 : 1;
            const startRow = pieceColor === 'white' ? 6 : 1;
            
            // Forward move
            if (isValidPosition(row + direction, col) && !board[row + direction][col]) {
                moves.push([row + direction, col]);
                
                // Double move from starting position
                if (row === startRow && !board[row + 2 * direction][col]) {
                    moves.push([row + 2 * direction, col]);
                }
            }
            
            // Diagonal captures
            [-1, 1].forEach(offset => {
                if (isValidPosition(row + direction, col + offset)) {
                    const target = board[row + direction][col + offset];
                    if (target && getPieceColor(target) !== pieceColor) {
                        moves.push([row + direction, col + offset]);
                    }
                }
            });
            break;

        case 'rook':
            addLinearMoves(moves, row, col, [[-1, 0], [1, 0], [0, -1], [0, 1]], pieceColor);
            break;

        case 'bishop':
            addLinearMoves(moves, row, col, [[-1, -1], [-1, 1], [1, -1], [1, 1]], pieceColor);
            break;

        case 'queen':
            addLinearMoves(moves, row, col, [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]], pieceColor);
            break;

        case 'knight':
            const knightMoves = [
                [-2, -1], [-2, 1], [-1, -2], [-1, 2],
                [1, -2], [1, 2], [2, -1], [2, 1]
            ];
            knightMoves.forEach(([dr, dc]) => {
                const newRow = row + dr;
                const newCol = col + dc;
                if (isValidPosition(newRow, newCol)) {
                    const target = board[newRow][newCol];
                    if (!target || getPieceColor(target) !== pieceColor) {
                        moves.push([newRow, newCol]);
                    }
                }
            });
            break;

        case 'king':
            const kingMoves = [
                [-1, -1], [-1, 0], [-1, 1],
                [0, -1], [0, 1],
                [1, -1], [1, 0], [1, 1]
            ];
            kingMoves.forEach(([dr, dc]) => {
                const newRow = row + dr;
                const newCol = col + dc;
                if (isValidPosition(newRow, newCol)) {
                    const target = board[newRow][newCol];
                    if (!target || getPieceColor(target) !== pieceColor) {
                        moves.push([newRow, newCol]);
                    }
                }
            });
            break;
    }

    return moves;
}

// Add linear moves (for rook, bishop, queen)
function addLinearMoves(moves, row, col, directions, pieceColor) {
    directions.forEach(([dr, dc]) => {
        let newRow = row + dr;
        let newCol = col + dc;
        
        while (isValidPosition(newRow, newCol)) {
            const target = board[newRow][newCol];
            if (!target) {
                moves.push([newRow, newCol]);
            } else {
                if (getPieceColor(target) !== pieceColor) {
                    moves.push([newRow, newCol]);
                }
                break;
            }
            newRow += dr;
            newCol += dc;
        }
    });
}

// Check if position is valid
function isValidPosition(row, col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
}

// Render the chessboard
function renderBoard() {
    const chessboard = document.getElementById('chessboard');
    chessboard.innerHTML = '';

    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            const square = document.createElement('div');
            square.className = 'square';
            square.className += (row + col) % 2 === 0 ? ' light' : ' dark';
            square.textContent = board[row][col];
            square.dataset.row = row;
            square.dataset.col = col;

            // Highlight selected square
            if (selectedSquare && selectedSquare.row === row && selectedSquare.col === col) {
                square.classList.add('selected');
            }

            // Highlight valid moves
            if (validMoves.some(([r, c]) => r === row && c === col)) {
                square.classList.add('valid-move');
            }

            square.addEventListener('click', () => handleSquareClick(row, col));
            chessboard.appendChild(square);
        }
    }

    // Update turn indicator
    document.getElementById('current-turn').textContent = 
        currentPlayer.charAt(0).toUpperCase() + currentPlayer.slice(1) + "'s Turn";
}

// Handle square click
function handleSquareClick(row, col) {
    const piece = board[row][col];
    const pieceColor = getPieceColor(piece);

    // If a square is selected and this is a valid move
    if (selectedSquare && validMoves.some(([r, c]) => r === row && c === col)) {
        // Move the piece
        board[row][col] = board[selectedSquare.row][selectedSquare.col];
        board[selectedSquare.row][selectedSquare.col] = '';
        
        // Switch player
        currentPlayer = currentPlayer === 'white' ? 'black' : 'white';
        selectedSquare = null;
        validMoves = [];
        
        renderBoard();
        checkGameStatus();
    }
    // If clicking on own piece, select it
    else if (pieceColor === currentPlayer) {
        selectedSquare = { row, col };
        validMoves = getValidMoves(row, col);
        renderBoard();
    }
    // If clicking elsewhere, deselect
    else {
        selectedSquare = null;
        validMoves = [];
        renderBoard();
    }
}

// Check game status (simplified - doesn't check for checkmate)
function checkGameStatus() {
    const message = document.getElementById('message');
    
    // Check if either king is missing (captured)
    let whiteKingExists = false;
    let blackKingExists = false;
    
    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            if (board[row][col] === PIECES.white.king) whiteKingExists = true;
            if (board[row][col] === PIECES.black.king) blackKingExists = true;
        }
    }
    
    if (!whiteKingExists) {
        message.textContent = 'Checkmate! Black wins!';
        message.className = 'message checkmate';
    } else if (!blackKingExists) {
        message.textContent = 'Checkmate! White wins!';
        message.className = 'message checkmate';
    } else {
        message.textContent = '';
        message.className = 'message';
    }
}

// Reset the game
function resetGame() {
    initializeBoard();
    renderBoard();
    document.getElementById('message').textContent = '';
    document.getElementById('message').className = 'message';
}

// Initialize the game
document.addEventListener('DOMContentLoaded', () => {
    initializeBoard();
    renderBoard();
    
    document.getElementById('reset-btn').addEventListener('click', resetGame);
});
