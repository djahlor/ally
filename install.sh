#!/bin/bash

# Ally — Installer (v3.1)
# Your AI that actually knows you.
# https://github.com/djahlor/ally

set -e

# ─────────────────────────────────────────
# Colors & helpers
# ─────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
NC='\033[0m'

ALLY_VERSION="3.1"
CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALLED_COUNT=0
SKIPPED_COUNT=0
DRY_RUN=false
VERBOSE=false
FORCE=false

# ─────────────────────────────────────────
# Taglines (inspired by OpenClaw)
# ─────────────────────────────────────────

TAGLINES=(
  "Your inbox has met its match."
  "Finally, an AI that remembers what you said mattered."
  "Triage at the speed of thought."
  "One config. Every channel. Your voice."
  "The system that gets better every time you correct it."
  "Your calendar just became a strategy document."
  "Because replying 'let me check my schedule' is so 2024."
  "Ship the reply. Close the loop. Move on."
  "Where your goals meet your inbox."
  "Less noise. More leverage."
  "The assistant your calendar demanded."
  "Your contacts file will never be stale again."
  "Modular by design. Personal by nature."
  "Every correction makes it smarter."
  "Built for people who run things."
)

pick_tagline() {
  local idx=$((RANDOM % ${#TAGLINES[@]}))
  echo "${TAGLINES[$idx]}"
}

# ─────────────────────────────────────────
# Output helpers
# ─────────────────────────────────────────

info()    { echo -e "  ${CYAN}info${NC}  $1"; }
ok()      { echo -e "  ${GREEN}done${NC}  $1"; INSTALLED_COUNT=$((INSTALLED_COUNT + 1)); }
skip()    { echo -e "  ${YELLOW}skip${NC}  $1 (already exists)"; SKIPPED_COUNT=$((SKIPPED_COUNT + 1)); }
warn()    { echo -e "  ${YELLOW}warn${NC}  $1"; }
fail()    { echo -e "  ${RED}fail${NC}  $1"; }
step()    { echo ""; echo -e "${BOLD}$1${NC}"; echo ""; }
note()    {
  local title="$1"
  local body="$2"
  echo ""
  echo -e "  ${DIM}┌─ ${title}${NC}"
  while IFS= read -r line; do
    echo -e "  ${DIM}│${NC}  $line"
  done <<< "$body"
  echo -e "  ${DIM}└─${NC}"
}
divider() { echo -e "${DIM}  ──────────────────────────────────────${NC}"; }

# ─────────────────────────────────────────
# Flags
# ─────────────────────────────────────────

show_help() {
  echo ""
  echo -e "${BOLD}Ally${NC} — installer v${ALLY_VERSION}"
  echo ""
  echo "Usage: ./install.sh [flags]"
  echo ""
  echo "Flags:"
  echo "  --dry-run     Show what would be installed without writing files"
  echo "  --force       Overwrite existing files (default: skip existing)"
  echo "  --verbose     Show detailed output for each file operation"
  echo "  --help, -h    Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./install.sh                    # Interactive setup"
  echo "  ./install.sh --dry-run          # Preview what gets installed"
  echo "  ./install.sh --force            # Reinstall, overwriting everything"
  echo ""
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --dry-run)  DRY_RUN=true ;;
    --force)    FORCE=true ;;
    --verbose)  VERBOSE=true ;;
    --help|-h)  show_help ;;
    *)          echo "Unknown flag: $arg"; show_help ;;
  esac
done

# ─────────────────────────────────────────
# Banner
# ─────────────────────────────────────────

TAGLINE=$(pick_tagline)

echo ""
echo -e "${BOLD}${CYAN}"
cat << 'BANNER'
     █████╗ ██╗     ██╗  ██╗   ██╗
    ██╔══██╗██║     ██║  ╚██╗ ██╔╝
    ███████║██║     ██║   ╚████╔╝
    ██╔══██║██║     ██║    ╚██╔╝
    ██║  ██║███████╗███████╗██║
    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝
BANNER
echo -e "${NC}"
echo -e "  ${BOLD}Ally${NC} v${ALLY_VERSION}  ${DIM}—${NC}  ${ITALIC}${TAGLINE}${NC}"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo -e "  ${YELLOW}DRY RUN${NC}: No files will be written."
  echo ""
fi

# ─────────────────────────────────────────
# Pre-flight checks
# ─────────────────────────────────────────

step "Pre-flight"

# OS detection
OS="unknown"
case "$(uname -s)" in
  Darwin*) OS="macOS" ;;
  Linux*)  OS="Linux" ;;
  MINGW*|MSYS*|CYGWIN*) OS="Windows" ;;
esac
info "Platform: ${BOLD}${OS}${NC} ($(uname -m))"

# Claude Code check
if command -v claude &> /dev/null; then
  CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
  ok "Claude Code: ${DIM}${CLAUDE_VERSION}${NC}"
else
  warn "Claude Code CLI not found"
  note "Install Claude Code" "Get it from: https://docs.anthropic.com/en/docs/claude-code\nAlly requires Claude Code to function."
  echo ""
  read -p "  Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "  ${DIM}Come back when you've got Claude Code installed.${NC}"
    echo ""
    exit 1
  fi
fi

# Existing installation detection
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo ""
  warn "Existing Ally installation detected at ~/.claude/"
  echo ""

  if [ "$FORCE" = true ]; then
    info "Force mode: will overwrite existing files"
  else
    echo -e "  ${BOLD}What would you like to do?${NC}"
    echo ""
    echo "  1) Update: install new files, keep existing ones"
    echo "  2) Reinstall: overwrite everything (backs up current config)"
    echo "  3) Cancel"
    echo ""
    read -p "  Choice [1]: " INSTALL_MODE
    INSTALL_MODE=${INSTALL_MODE:-1}

    case "$INSTALL_MODE" in
      1) info "Update mode: new files only, existing files preserved" ;;
      2)
        FORCE=true
        BACKUP_DIR="$CLAUDE_DIR/.backup-$(date +%Y%m%d-%H%M%S)"
        if [ "$DRY_RUN" = false ]; then
          mkdir -p "$BACKUP_DIR"
          # Back up key files
          for f in CLAUDE.md voice/style.md goals.yaml my-tasks.yaml decisions.yaml; do
            if [ -f "$CLAUDE_DIR/$f" ]; then
              mkdir -p "$BACKUP_DIR/$(dirname "$f")"
              cp "$CLAUDE_DIR/$f" "$BACKUP_DIR/$f"
            fi
          done
          ok "Backed up current config to ${DIM}${BACKUP_DIR}${NC}"
        else
          info "Would back up current config"
        fi
        ;;
      *)
        echo ""
        echo -e "  ${DIM}No changes made.${NC}"
        echo ""
        exit 0
        ;;
    esac
  fi
fi

# ─────────────────────────────────────────
# Step 1: About you
# ─────────────────────────────────────────

step "About you"
echo -e "  ${DIM}These details personalize your CLAUDE.md config.${NC}"
echo ""

read -p "  Full name: " USER_NAME
read -p "  First name (for email sign-offs): " FIRST_NAME
read -p "  Role/title: " USER_ROLE
read -p "  Company: " USER_COMPANY
read -p "  Work email: " WORK_EMAIL
read -p "  Personal email: " PERSONAL_EMAIL
read -p "  Company website (e.g., example.com): " COMPANY_URL

# ─────────────────────────────────────────
# Step 2: Constraints
# ─────────────────────────────────────────

step "Your constraints"
echo -e "  ${DIM}These protect your time. Leave blank to skip.${NC}"
echo ""

read -p "  Earliest meeting time (e.g., 9:00 AM): " EARLIEST_MEETING
read -p "  Home by (e.g., 6:00 PM): " DINNER_TIME

# ─────────────────────────────────────────
# Step 3: Defaults
# ─────────────────────────────────────────

step "Defaults"

read -p "  Currency (USD/EUR/GBP/CAD) [USD]: " CURRENCY
CURRENCY=${CURRENCY:-USD}
read -p "  Timezone (e.g., America/New_York) [America/New_York]: " TIMEZONE
TIMEZONE=${TIMEZONE:-America/New_York}
read -p "  Date format (YYYY-MM-DD / DD-MM-YYYY) [YYYY-MM-DD]: " DATE_FORMAT
DATE_FORMAT=${DATE_FORMAT:-YYYY-MM-DD}

# ─────────────────────────────────────────
# Step 4: Team (optional)
# ─────────────────────────────────────────

step "Team (optional)"

note "Shared folder" "If your team syncs a Google Drive folder, Ally can connect to it.\nThis enables shared goals, tasks, decisions, and async messaging.\nLeave blank if you work solo."
echo ""
read -p "  Shared folder path: " SHARED_FOLDER_PATH

# ─────────────────────────────────────────
# Install
# ─────────────────────────────────────────

step "Installing"

# Helper: install a single file with placeholder replacement
install_file() {
  local src="$1"
  local dest="$2"
  local label="${3:-$(basename "$dest")}"

  if [ ! -f "$src" ]; then
    if [ "$VERBOSE" = true ]; then
      fail "$label (source missing: $src)"
    fi
    return
  fi

  if [ "$FORCE" = true ] || [ ! -f "$dest" ]; then
    if [ "$DRY_RUN" = true ]; then
      info "Would install: $label"
      return
    fi

    cp "$src" "$dest"

    # Replace all placeholders
    sed -i.bak "s/{{YOUR_NAME}}/$USER_NAME/g" "$dest"
    sed -i.bak "s/{{YOUR_FIRST_NAME}}/$FIRST_NAME/g" "$dest"
    sed -i.bak "s/{{YOUR_ROLE}}/$USER_ROLE/g" "$dest"
    sed -i.bak "s/{{YOUR_COMPANY}}/$USER_COMPANY/g" "$dest"
    sed -i.bak "s/{{WORK_EMAIL}}/$WORK_EMAIL/g" "$dest"
    sed -i.bak "s/{{PERSONAL_EMAIL}}/$PERSONAL_EMAIL/g" "$dest"
    sed -i.bak "s|{{COMPANY_URL}}|$COMPANY_URL|g" "$dest"
    sed -i.bak "s/{{CURRENCY}}/$CURRENCY/g" "$dest"
    sed -i.bak "s|{{TIMEZONE}}|$TIMEZONE|g" "$dest"
    sed -i.bak "s/{{DATE_FORMAT}}/$DATE_FORMAT/g" "$dest"

    if [ -n "$EARLIEST_MEETING" ]; then
      sed -i.bak "s/{{EARLIEST_MEETING_TIME}}/$EARLIEST_MEETING/g" "$dest"
    fi
    if [ -n "$DINNER_TIME" ]; then
      sed -i.bak "s/{{DINNER_TIME}}/$DINNER_TIME/g" "$dest"
    fi

    rm -f "$dest.bak"
    ok "$label"
  else
    skip "$label"
  fi
}

# Create directories
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$CLAUDE_DIR"/{commands,agents,contacts,voice,systems,cache,outputs,logs/actions}
  info "Directories ready"
else
  info "Would create directories: commands, agents, contacts, voice, systems, cache, outputs, logs"
fi

divider

# Core config
info "Core config"
install_file "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" "CLAUDE.md"

# Domain modules
info "Domain modules"
install_file "$SCRIPT_DIR/voice/style.md" "$CLAUDE_DIR/voice/style.md" "voice/style.md"
install_file "$SCRIPT_DIR/systems/triage.md" "$CLAUDE_DIR/systems/triage.md" "systems/triage.md"
install_file "$SCRIPT_DIR/systems/responsibilities.md" "$CLAUDE_DIR/systems/responsibilities.md" "systems/responsibilities.md"
install_file "$SCRIPT_DIR/systems/mcp-routing.md" "$CLAUDE_DIR/systems/mcp-routing.md" "systems/mcp-routing.md"
install_file "$SCRIPT_DIR/systems/confidentiality.md" "$CLAUDE_DIR/systems/confidentiality.md" "systems/confidentiality.md"

divider

# Data files
info "Data files ${DIM}(never overwrites existing)${NC}"
install_file "$SCRIPT_DIR/my-tasks.yaml" "$CLAUDE_DIR/my-tasks.yaml" "my-tasks.yaml"
install_file "$SCRIPT_DIR/schedules.yaml" "$CLAUDE_DIR/schedules.yaml" "schedules.yaml"
install_file "$SCRIPT_DIR/decisions.yaml" "$CLAUDE_DIR/decisions.yaml" "decisions.yaml"
install_file "$SCRIPT_DIR/goals.yaml" "$CLAUDE_DIR/goals.yaml" "goals.yaml"
install_file "$SCRIPT_DIR/triage-stats.yaml" "$CLAUDE_DIR/triage-stats.yaml" "triage-stats.yaml"
install_file "$SCRIPT_DIR/triage-learnings.yaml" "$CLAUDE_DIR/triage-learnings.yaml" "triage-learnings.yaml"

divider

# Commands
CMD_COUNT=0
for cmd in "$SCRIPT_DIR/commands/"*.md; do
  if [ -f "$cmd" ]; then
    CMD_COUNT=$((CMD_COUNT + 1))
  fi
done
if [ "$CMD_COUNT" -gt 0 ]; then
  info "Commands (${CMD_COUNT} found)"
  for cmd in "$SCRIPT_DIR/commands/"*.md; do
    if [ -f "$cmd" ]; then
      filename=$(basename "$cmd")
      install_file "$cmd" "$CLAUDE_DIR/commands/$filename" "commands/$filename"
    fi
  done
fi

# Agents
AGENT_COUNT=0
for agent in "$SCRIPT_DIR/agents/"*.md; do
  if [ -f "$agent" ]; then
    AGENT_COUNT=$((AGENT_COUNT + 1))
  fi
done
if [ "$AGENT_COUNT" -gt 0 ]; then
  info "Agents (${AGENT_COUNT} found)"
  for agent in "$SCRIPT_DIR/agents/"*.md; do
    if [ -f "$agent" ]; then
      filename=$(basename "$agent")
      install_file "$agent" "$CLAUDE_DIR/agents/$filename" "agents/$filename"
    fi
  done
fi

# Contacts
if [ -d "$SCRIPT_DIR/contacts" ]; then
  CONTACT_COUNT=0
  for contact in "$SCRIPT_DIR/contacts/"*.md "$SCRIPT_DIR/contacts/"*/*.md; do
    if [ -f "$contact" ]; then
      CONTACT_COUNT=$((CONTACT_COUNT + 1))
    fi
  done
  if [ "$CONTACT_COUNT" -gt 0 ]; then
    info "Contacts (${CONTACT_COUNT} found)"
    for contact in "$SCRIPT_DIR/contacts/"*.md "$SCRIPT_DIR/contacts/"*/*.md; do
      if [ -f "$contact" ]; then
        rel_path="${contact#$SCRIPT_DIR/contacts/}"
        if [ "$DRY_RUN" = false ]; then
          mkdir -p "$CLAUDE_DIR/contacts/$(dirname "$rel_path")"
        fi
        install_file "$contact" "$CLAUDE_DIR/contacts/$rel_path" "contacts/$rel_path"
      fi
    done
  fi
fi

# ─────────────────────────────────────────
# Team shared folder (optional)
# ─────────────────────────────────────────

if [ -n "$SHARED_FOLDER_PATH" ]; then
  divider
  info "Team shared folder"

  SHARED_FOLDER_PATH="${SHARED_FOLDER_PATH/#\~/$HOME}"
  FIRST_NAME_LOWER=$(echo "$FIRST_NAME" | tr '[:upper:]' '[:lower:]')

  if [ "$DRY_RUN" = true ]; then
    info "Would create: systems/team-os.md"
    info "Would add @import to CLAUDE.md"
  else
    cat > "$CLAUDE_DIR/systems/team-os.md" << TEAMEOF
# Team Shared Folder

**Location:** $SHARED_FOLDER_PATH

This folder is synced via Google Drive to all team members.

## At Session Start

After reading CLAUDE.md, also read from the shared folder:

1. \`TEAM.md\` for team roster, conventions, write rules
2. \`goals.yaml\` for company OKRs
3. \`tasks/$FIRST_NAME_LOWER.yaml\` for assigned company tasks
4. \`decisions.yaml\` (last 10 entries) for recent decisions
5. \`inbox/$FIRST_NAME_LOWER/new/\` for unread messages

## Two-Layer Architecture

You have TWO sets of tasks, goals, and decisions. Always check both.

| Data | Personal (\`~/.claude/\`) | Shared (\`$SHARED_FOLDER_PATH/\`) |
|------|------------------------|--------------------------------|
| **Tasks** | \`my-tasks.yaml\` (personal) | \`tasks/$FIRST_NAME_LOWER.yaml\` (company) |
| **Goals** | \`goals.yaml\` (personal) | \`goals.yaml\` (company OKRs) |
| **Decisions** | \`decisions.yaml\` (personal) | \`decisions.yaml\` (company) |

## Inbox System

**Reading:** Check \`inbox/$FIRST_NAME_LOWER/new/\` for unread messages. Move to \`archive/\` after reading.

**Sending:** Create markdown in \`inbox/[name]/new/\`:
- Filename: \`YYYY-MM-DD-HHMM-from-$FIRST_NAME_LOWER.md\`

## Write Rules

- Always include \`last_modified\` and \`last_modified_by\` fields
- Follow conventions in TEAM.md
- Re-read shared files before writing if session > 30 min
TEAMEOF

    ok "systems/team-os.md"

    if ! grep -q "systems/team-os.md" "$CLAUDE_DIR/CLAUDE.md"; then
      sed -i.bak "s|@systems/confidentiality.md|@systems/confidentiality.md\n@systems/team-os.md|" "$CLAUDE_DIR/CLAUDE.md"
      rm -f "$CLAUDE_DIR/CLAUDE.md.bak"
      ok "Added @import to CLAUDE.md"
    fi
  fi
fi

# ─────────────────────────────────────────
# Summary
# ─────────────────────────────────────────

echo ""
echo ""

if [ "$DRY_RUN" = true ]; then
  echo -e "  ${BOLD}${YELLOW}Dry run complete.${NC} No files were written."
  echo -e "  Run without ${DIM}--dry-run${NC} to install."
  echo ""
  exit 0
fi

echo -e "  ${GREEN}${BOLD}Setup complete.${NC}  ${DIM}${INSTALLED_COUNT} installed, ${SKIPPED_COUNT} skipped${NC}"
echo ""

# Architecture tree
echo -e "  ${BOLD}What's in ~/.claude/:${NC}"
echo ""
echo -e "  ${DIM}~/.claude/${NC}"
echo -e "  ${DIM}├──${NC} ${BOLD}CLAUDE.md${NC}              ${DIM}Core config (imports everything below)${NC}"
echo -e "  ${DIM}├──${NC} voice/"
echo -e "  ${DIM}│   └──${NC} style.md           ${DIM}Your writing voice + examples${NC}"
echo -e "  ${DIM}├──${NC} systems/"
echo -e "  ${DIM}│   ├──${NC} triage.md          ${DIM}Inbox triage rules${NC}"
echo -e "  ${DIM}│   ├──${NC} responsibilities.md ${DIM}Always-on behaviors${NC}"
echo -e "  ${DIM}│   ├──${NC} mcp-routing.md     ${DIM}MCP server routing${NC}"
echo -e "  ${DIM}│   ├──${NC} confidentiality.md ${DIM}Sensitive topic rules${NC}"
if [ -n "$SHARED_FOLDER_PATH" ]; then
echo -e "  ${DIM}│   └──${NC} team-os.md         ${DIM}Team shared folder${NC}"
fi
echo -e "  ${DIM}├──${NC} commands/              ${DIM}/gm, /triage, /my-tasks, ...${NC}"
echo -e "  ${DIM}├──${NC} agents/                ${DIM}Parallel sub-agents${NC}"
echo -e "  ${DIM}├──${NC} contacts/              ${DIM}Personal CRM${NC}"
echo -e "  ${DIM}├──${NC} goals.yaml             ${DIM}Your objectives${NC}"
echo -e "  ${DIM}├──${NC} my-tasks.yaml          ${DIM}Task tracking${NC}"
echo -e "  ${DIM}└──${NC} decisions.yaml         ${DIM}Decision log${NC}"
echo ""

divider
echo ""

# Next steps as a clear action list
echo -e "  ${BOLD}Now make it yours:${NC}"
echo ""
echo -e "  ${CYAN}1${NC}  ${BOLD}Teach it your voice${NC}        ~/.claude/voice/style.md"
echo -e "     ${DIM}Paste 3+ real emails you've sent. This is the #1 quality lever.${NC}"
echo ""
echo -e "  ${CYAN}2${NC}  ${BOLD}Connect your channels${NC}      ${DIM}minimum: Gmail + Google Calendar${NC}"
echo -e "     ${DIM}Run:${NC} claude ${DIM}and ask it to help you set up MCP servers${NC}"
echo ""
echo -e "  ${CYAN}3${NC}  ${BOLD}Set your goals${NC}             ~/.claude/goals.yaml"
echo -e "     ${DIM}This is how Ally knows what to prioritize.${NC}"
echo ""
echo -e "  ${CYAN}4${NC}  ${BOLD}Try it${NC}"
echo -e "     $ ${BOLD}claude${NC}"
echo -e "     > ${GREEN}/gm${NC}            ${DIM}Morning briefing${NC}"
echo -e "     > ${GREEN}/triage${NC}         ${DIM}Inbox triage${NC}"
echo -e "     > ${GREEN}/my-tasks${NC} list  ${DIM}See your tasks${NC}"
echo ""

divider
echo ""
echo -e "  ${DIM}The more you use it, the better it gets.${NC}"
echo -e "  ${DIM}Every correction teaches it something new.${NC}"
echo ""
