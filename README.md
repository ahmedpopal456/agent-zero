# Agent Zero

Azure Architecture Specialist Agent with MCP Integration

## Overview

This repository contains configuration and documentation for an Azure Architecture Specialist Agent enhanced with Model Context Protocol (MCP) servers for advanced capabilities including:

## Chess App

A simple, interactive chess application built with HTML, CSS, and JavaScript.

### Features
- Full chess board with standard piece layout
- Turn-based gameplay (White vs Black)
- Visual feedback for selected pieces and valid moves
- Move validation for all piece types (pawns, rooks, knights, bishops, queens, kings)
- New Game button to reset the board
- Responsive design with beautiful gradient background

### How to Play

1. **Open the Chess App**:
   ```bash
   # Navigate to the repository directory
   cd /path/to/agent-zero
   
   # Start a local web server
   python3 -m http.server 8080
   
   # Open your browser and go to:
   # http://localhost:8080/chess.html
   ```

2. **Gameplay**:
   - Click on a piece to select it (pieces are highlighted in yellow)
   - Valid moves are shown in green with circular indicators
   - Click on a valid move to move the piece
   - The turn indicator shows whose turn it is
   - Click "New Game" to reset the board at any time

### Files
- `chess.html` - Main HTML structure
- `chess.css` - Styling and visual design
- `chess.js` - Game logic and move validation

## Getting Started

See `AGENTS.md` for complete setup instructions and configuration details.

## Repository Structure

```
├── .github/                    # GitHub templates and workflows
├── docs/                       # Documentation and architecture diagrams
│   └── architecture/          # Architecture diagrams
├── resources/                  # Meeting transcripts and resources
├── chess.html                  # Chess app HTML
├── chess.css                   # Chess app styling
├── chess.js                    # Chess app logic
└── AGENTS.md                  # Complete agent configuration and setup
```