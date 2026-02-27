# MCP Server Setup

MCP (Model Context Protocol) servers give Claude access to external services
like Gmail, Google Calendar, Slack, and more. This guide uses the actual
packages and configurations that have been tested and verified to work
with Claude Code.

All MCP servers are configured in `~/.claude.json` (the global Claude Code config).

---

## Prerequisites

### Google Cloud OAuth Credentials (Required for Gmail + Calendar)

Gmail and Google Calendar both need OAuth credentials from a Google Cloud project.

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use an existing one)
3. Enable the **Gmail API** and **Google Calendar API**
4. Go to **Credentials** > **Create Credentials** > **OAuth Client ID**
5. Application type: **Desktop app**
6. Download the JSON file
7. Save it to `~/.gmail-mcp/gcp-oauth.keys.json`

```bash
mkdir -p ~/.gmail-mcp
# Move your downloaded credentials file:
mv ~/Downloads/client_secret_*.json ~/.gmail-mcp/gcp-oauth.keys.json
```

This single OAuth credentials file is shared by both Gmail and Google Calendar servers.

---

## Required Servers

### Gmail

**Package:** `@gongrzhe/server-gmail-autoauth-mcp`

This package handles OAuth authentication automatically. On first run,
it opens a browser for you to authorize access, then stores the credentials
for future sessions.

**Single account setup:**

Add to `~/.claude.json` under `"mcpServers"`:

```json
"gmail": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@gongrzhe/server-gmail-autoauth-mcp"],
  "env": {
    "GMAIL_OAUTH_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/gcp-oauth.keys.json",
    "GMAIL_CREDENTIALS_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/credentials.json"
  }
}
```

**Multiple accounts:**

Create separate credential files for each account. On first OAuth flow,
sign in with the correct Google account for each:

```json
"gmail-work": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@gongrzhe/server-gmail-autoauth-mcp"],
  "env": {
    "GMAIL_OAUTH_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/gcp-oauth.keys.json",
    "GMAIL_CREDENTIALS_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/work/credentials.json"
  }
},
"gmail-personal": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@gongrzhe/server-gmail-autoauth-mcp"],
  "env": {
    "GMAIL_OAUTH_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/gcp-oauth.keys.json",
    "GMAIL_CREDENTIALS_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/personal/credentials.json"
  }
}
```

```bash
# Create credential directories:
mkdir -p ~/.gmail-mcp/work
mkdir -p ~/.gmail-mcp/personal
```

**First run:** Claude Code will trigger the OAuth flow. Sign in with the
correct Google account when the browser opens. Credentials are cached after that.

**Verify:**
```
> Search my email for messages from today
```

---

### Google Calendar

**Package:** `@cocal/google-calendar-mcp`

Uses the same Google Cloud OAuth credentials as Gmail.

```json
"google-calendar": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@cocal/google-calendar-mcp"],
  "env": {
    "GOOGLE_OAUTH_CREDENTIALS": "/Users/YOUR_USERNAME/.gmail-mcp/gcp-oauth.keys.json"
  }
}
```

**First run:** Will open a browser for OAuth authorization (same as Gmail).

**Verify:**
```
> What's on my calendar today?
> Am I free next Tuesday at 2pm?
```

---

## Recommended Servers

### Slack

**Package:** `@roywu01/slack-mcp-server`

Requires a Slack Bot Token and Team ID.

**Getting your Slack Bot Token:**

1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Create a new app (or use an existing one)
3. Go to **OAuth & Permissions**
4. Add these bot token scopes: `channels:history`, `channels:read`, `im:history`, `im:read`, `search:read`, `chat:write`, `users:read`, `users.profile:read`
5. Install the app to your workspace
6. Copy the **Bot User OAuth Token** (starts with `xoxb-`)

**Getting your Slack Team ID:**

Open Slack in a browser. The URL will be `https://app.slack.com/client/T024XXXXX/...`. The `T024XXXXX` part is your Team ID.

```json
"slack": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@roywu01/slack-mcp-server"],
  "env": {
    "SLACK_BOT_TOKEN": "xoxb-your-bot-token-here",
    "SLACK_TEAM_ID": "T024XXXXX"
  }
}
```

**Verify:**
```
> Show me my recent Slack DMs
> Search Slack for messages about "product launch"
```

---

### Google Workspace (Drive, Docs, Sheets)

**Package:** `@dguido/google-workspace-mcp`

Provides access to Google Drive, Docs, and Sheets. Uses the same Google Cloud
project as Gmail/Calendar but needs its own OAuth client credentials.

```json
"google-workspace": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@dguido/google-workspace-mcp"],
  "env": {
    "GOOGLE_CLIENT_ID": "your-client-id.apps.googleusercontent.com",
    "GOOGLE_CLIENT_SECRET": "GOCSPX-your-client-secret",
    "GOOGLE_WORKSPACE_MCP_PROFILE": "default",
    "GOOGLE_WORKSPACE_SERVICES": "drive,docs,sheets"
  }
}
```

**Multiple accounts:** Use different `GOOGLE_WORKSPACE_MCP_PROFILE` values
for each account (e.g., "work", "personal"). Each profile stores its own
OAuth tokens separately.

**Verify:**
```
> Search my Google Drive for "quarterly report"
> List files in my Drive root folder
```

---

## Optional Servers

### Discord

**Package:** `mcp-discord`

Requires a Discord Bot Token.

**Getting your Discord Bot Token:**

1. Go to [discord.com/developers/applications](https://discord.com/developers/applications)
2. Create a new application
3. Go to **Bot** > **Reset Token** > Copy the token
4. Enable **Message Content Intent** under **Privileged Gateway Intents**
5. Invite the bot to your server via **OAuth2** > **URL Generator** (select `bot` scope with `Read Messages` permissions)

```json
"discord": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "mcp-discord"],
  "env": {
    "DISCORD_TOKEN": "your-discord-bot-token"
  }
}
```

**Verify:**
```
> Get info about my Discord server
> Read recent messages in #general
```

---

### Granola (Meeting Notes)

**Package:** `granola-mcp-server` (Python, installed via pip/uv)

Granola records and summarizes meetings. The MCP server lets Claude
search and retrieve those notes.

```bash
# Install with uv (recommended):
uv tool install granola-mcp-server

# Or with pip:
pip install granola-mcp-server
```

```json
"granola": {
  "type": "stdio",
  "command": "/path/to/your/.venv/bin/granola-mcp-server",
  "args": [],
  "env": {}
}
```

The exact path depends on your Python/venv setup. Find it with:
```bash
which granola-mcp-server
```

**Verify:**
```
> Search my meeting notes for "roadmap"
```

---

### Notion

**Type:** HTTP (cloud-hosted by Notion)

Notion provides a hosted MCP server. No local installation needed.

```json
"notion": {
  "type": "http",
  "url": "https://mcp.notion.com/mcp"
}
```

On first use, Claude Code will prompt you to authorize access to your
Notion workspace in the browser.

**Multiple workspaces:** Add separate entries with different names
(e.g., "notion-work", "notion-personal"). Each will have its own
authorization.

**Verify:**
```
> Search my Notion for "meeting notes"
```

---

### Exa (Web Search)

**Type:** HTTP (cloud-hosted by Exa)

AI-powered web search. Useful for research tasks.

```json
"exa": {
  "type": "http",
  "url": "https://mcp.exa.ai/mcp"
}
```

On first use, you'll need to authorize via browser.

**Verify:**
```
> Search the web for recent news about AI agents
```

---

### Beeper (WhatsApp via Beeper Bridge)

**Type:** HTTP (local server)

Beeper provides a bridge to WhatsApp and other messaging platforms.
Requires Beeper to be running locally.

```json
"beeper": {
  "type": "http",
  "url": "http://localhost:23373/v0/mcp"
}
```

**Note:** Beeper must be running for this to work. The local server
runs on port 23373 by default.

**Verify:**
```
> Show my recent WhatsApp messages
```

---

## Performance: Context Window Optimization

MCP tools can consume a large portion of your context window (92-107k tokens
out of 200k). To eliminate this overhead:

**Add to your `~/.zshrc`:**

```bash
export ENABLE_EXPERIMENTAL_MCP_CLI=true
```

This routes all MCP calls through a lightweight CLI wrapper. Zero context
cost for all MCP servers. Tools still work the same way, they just don't
load their schemas into memory upfront.

**Known limitations:**
- Restart Claude Code after setting the env var (new session required)
- Slight extra latency per tool call (schema fetched on demand)
- Occasionally stale session ID (restart session if it happens)

**Result:** MCP tool overhead drops from ~100k tokens to ~0 tokens,
leaving ~90%+ of your context window available for actual work.

---

## Full Example Config

Here's what a complete `~/.claude.json` MCP section looks like with the
core servers configured:

```json
{
  "mcpServers": {
    "gmail": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@gongrzhe/server-gmail-autoauth-mcp"],
      "env": {
        "GMAIL_OAUTH_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/gcp-oauth.keys.json",
        "GMAIL_CREDENTIALS_PATH": "/Users/YOUR_USERNAME/.gmail-mcp/credentials.json"
      }
    },
    "google-calendar": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@cocal/google-calendar-mcp"],
      "env": {
        "GOOGLE_OAUTH_CREDENTIALS": "/Users/YOUR_USERNAME/.gmail-mcp/gcp-oauth.keys.json"
      }
    },
    "slack": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@roywu01/slack-mcp-server"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-bot-token",
        "SLACK_TEAM_ID": "T024XXXXX"
      }
    },
    "google-workspace": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@dguido/google-workspace-mcp"],
      "env": {
        "GOOGLE_CLIENT_ID": "your-client-id.apps.googleusercontent.com",
        "GOOGLE_CLIENT_SECRET": "GOCSPX-your-secret",
        "GOOGLE_WORKSPACE_MCP_PROFILE": "default",
        "GOOGLE_WORKSPACE_SERVICES": "drive,docs,sheets"
      }
    },
    "notion": {
      "type": "http",
      "url": "https://mcp.notion.com/mcp"
    },
    "exa": {
      "type": "http",
      "url": "https://mcp.exa.ai/mcp"
    }
  }
}
```

---

## Troubleshooting

### "OAuth flow not opening"

Make sure the OAuth credentials JSON file exists at the path specified:
```bash
ls ~/.gmail-mcp/gcp-oauth.keys.json
```

If it's missing, re-download from Google Cloud Console.

### "Permission denied" on Gmail

Your Google Cloud project may need the Gmail API enabled:
1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. APIs & Services > Library
3. Search for "Gmail API" and enable it

### "Rate limited"

MCP servers may rate-limit requests. If you see rate limit errors:
- Reduce automation frequency in `schedules.yaml`
- Batch related queries when possible

### Google Workspace "get_status" errors

If any Google Workspace tool returns an error, call the `get_status` tool
first for diagnostics before debugging manually.

### Slack bot can't see messages

Make sure the bot has the correct OAuth scopes and is invited to the
channels you want it to read. In Slack: right-click channel >
**Add apps** > select your bot.

### General: "MCP server failed to start"

```bash
# Check if the package is accessible:
npx -y @gongrzhe/server-gmail-autoauth-mcp --help

# Check if Node.js is installed:
node --version  # Need v18+

# Check Claude Code's MCP status:
# In a Claude Code session, try using a tool and check the error message
```

---

## What to Connect First

1. **Gmail + Google Calendar** (biggest productivity win, same OAuth setup)
2. **Slack** (if your team uses Slack)
3. **Google Workspace** (for Drive/Docs/Sheets access)
4. **Everything else** (add based on your workflow)

The system degrades gracefully. If a server isn't connected, Claude
simply skips that channel during triage.
