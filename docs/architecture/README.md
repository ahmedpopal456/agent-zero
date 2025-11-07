# Azure Architecture Diagrams

This directory contains architecture diagrams for the Azure Architecture Specialist Agent project.

## Diagram Files

- `azure_architecture_diagram_001.jpg` - Main Azure architecture overview
- `azure_data_flow_diagram_001.jpg` - Data flow and processing architecture

## Confluence Integration

These diagrams are automatically synchronized with Confluence pages using the MCP integration. The diagram files are matched to Confluence pages using labels:

- `azure_architecture_diagram_001.jpg` → `AZURE-ARCHITECTURE-DIAGRAM-ID-001`
- `azure_data_flow_diagram_001.jpg` → `AZURE-DATA-FLOW-DIAGRAM-ID-001`

## Usage

The Azure Architecture Specialist Agent automatically:
1. Monitors changes to diagram files in this directory
2. Searches for corresponding Confluence pages using MCP
3. Updates pages with new diagram references
4. Maintains version history and change tracking