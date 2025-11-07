# Agent Zero

Azure Architecture Specialist Agent with MCP Integration

## Overview

This repository contains configuration and documentation for an Azure Architecture Specialist Agent enhanced with Model Context Protocol (MCP) servers for advanced capabilities including:

- **Meeting Transcript Processing** - Automatically parse meeting notes and create/update Jira issues
- **Architecture Documentation** - Generate and synchronize design docs and diagrams in Confluence
- **Azure Resource Discovery** - Analyze existing resources using Azure MCP and connector
- **Tag-Based Resource Management** - Find and manage Azure resources using specific tags
- **Cost Analysis** - Client-ready reports for Azure architecture decisions

## Features

- Atlassian MCP integration for Jira issue management and Confluence automation
- Azure MCP server setup for resource discovery and cost monitoring
- GitHub integration standards and PR templates
- Meeting transcript processing capabilities
- Architecture diagrams and documentation structure

## Getting Started

See `AGENTS.md` for complete setup instructions and configuration details.

## Repository Structure

```
├── .github/                    # GitHub templates and workflows
├── docs/                       # Documentation and architecture diagrams
│   └── architecture/          # Architecture diagrams
├── resources/                  # Meeting transcripts and resources
└── AGENTS.md                  # Complete agent configuration and setup
```