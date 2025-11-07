# Azure Architecture Specialist Agent
*Enhanced Azure Infrastructure & Documentation Specialist with MCP Integration*

## Overview
This agent provides specialized Azure infrastructure support for architecture design, technical deliverables, and automated documentation management. Enhanced with Model Context Protocol (MCP) servers for advanced capabilities including Atlassian integration for meeting transcription processing, Jira issue management, and Confluence architectural diagram synchronization.

## Benefits for Technical Deliverables
- **Meeting Transcript Processing** - Automatically parse meeting notes and create/update Jira issues with actionable items
- **Architecture Documentation** - Generate and synchronize design docs and diagrams in Confluence using file-based tagging
- **Azure Resource Discovery** - Analyze existing resources using Azure MCP and connector for migration planning
- **Tag-Based Resource Management** - Find and manage Azure resources using specific tags and metadata
- **Confluence Diagram Automation** - Update architectural diagrams based on file names and page labels
- **Cost Analysis** - Client-ready reports for Azure architecture decisions
- **Cost Monitoring** - Provides information about the cost of resources by tag
- **Jira Integration** - Automated issue creation and updates from meeting outcomes
- **Azure Knowledge** - Latest Azure service guidance with Azure MCP integration

## Enhanced Capabilities with MCP

### Atlassian MCP Integration
- **Meeting Transcript Processing**: Automatically extract action items and create Jira issues
- **Confluence Automation**: Update architectural diagrams based on file changes and labels
- **Issue Management**: Create, update, and track architecture-related Jira issues
- **Page Discovery**: Automatically find and update multiple Confluence pages
- **Version Tracking**: Maintain change history and automation audit trails

### Azure MCP Integration
- **Resource Discovery**: Always find and analyze Azure specific resources using MCP
- **Cost Analysis**: Generate cost optimization reports and recommendations
- **Architecture Validation**: Ensure resources align with Well-Architected Framework
- **Security Assessment**: Identify security configuration improvements
- **Compliance Reporting**: Generate compliance and governance reports

## Prerequisites
- Azure CLI configured with appropriate subscriptions
- Agent framework CLI installed (Claude Desktop, OpenAI, etc.)
- Python with uvx for MCP servers
- Access to Atlassian instance (Confluence and Jira)
- OAuth authentication for Atlassian MCP
- Internet access for MCP server connections
- Local architecture documentation repository structure