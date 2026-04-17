# dotfiles

Personal configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Bootstrap a new machine

```bash
git clone <remote-url> ~/dotfiles
brew install stow   # macOS; use apt/dnf on Linux

# Symlink Claude Code user-scope config
cd ~/dotfiles
stow -t ~/.claude claude
```

## What's inside

| Package | Target | Contents |
|---------|--------|----------|
| `claude/` | `~/.claude/` | CLAUDE.md, settings.json, rules/, agents/, skills/ |

## Layout

```
dotfiles/
├── .gitignore          # excludes Claude Code runtime state
├── README.md
└── claude/
    └── .claude/
        ├── CLAUDE.md           # personal coding principles (all projects)
        ├── settings.json       # baseline permissions, hooks, model
        ├── rules/
        │   ├── 00-communication.md   # language mirror, conciseness
        │   ├── 10-git-workflow.md    # commit conventions, safety rules
        │   └── 20-model-selection.md # haiku/sonnet/opus routing
        ├── agents/
        │   ├── explorer.md           # haiku, read-only exploration
        │   ├── planner.md            # sonnet, plan-mode
        │   ├── code-reviewer.md      # sonnet, bug + security check
        │   ├── security-reviewer.md  # opus, deep security audit
        │   └── researcher.md         # haiku, web research
        └── skills/
            ├── commit-msg/           # generate commit message from staged diff
            ├── explain/              # explain a block of code
            └── ticket-kickoff/       # create per-ticket scratchpad
```

## Adding new machines

On a second machine where `~/.claude/` already has runtime state:
```bash
# Symlink only specific items to avoid conflicts with existing dirs
ln -s ~/dotfiles/claude/.claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/dotfiles/claude/.claude/settings.json ~/.claude/settings.json
ln -s ~/dotfiles/claude/.claude/rules ~/.claude/rules
for f in explorer planner code-reviewer security-reviewer researcher; do
  ln -s ~/dotfiles/claude/.claude/agents/$f.md ~/.claude/agents/$f.md
done
for skill in commit-msg explain ticket-kickoff; do
  ln -s ~/dotfiles/claude/.claude/skills/$skill ~/.claude/skills/$skill
done
```

## What is NOT in this repo

- Runtime state: `projects/`, `sessions/`, `cache/`, `todos/`, `telemetry/`, `history.jsonl`, etc.
- Employer-specific config: lives in `~/work/<employer>/.claude/` (separate, not synced here).
- Secrets of any kind.
- Machine-local overrides: `settings.local.json`, `CLAUDE.local.md`.
