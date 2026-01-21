# MoonBit Agent Skill

This repository contains an [Agent Skill](https://agentskills.io/home) that teaches AI coding agents the MoonBit programming language and its toolchain.

## Integrate the Skill into your agent

Different AI assistants require different configuration methods. Below are guides for popular coding assistants:

### Codex CLI

```shell
mkdir -p ~/.codex/skills/
git clone https://github.com/f4ah6o/moonbit-agent-guide ~/.codex/skills/moonbit
```

Documentation: https://developers.openai.com/codex/skills

### Claude Code

#### For Claude Code Plugin (Recommended - Fork Version)

```shell
/plugin marketplace add f4ah6o/moonbit-agent-guide
```

Re-install if needed:
```shell
/plugin marketplace remove moonbit-agent-guide
/plugin marketplace add f4ah6o/moonbit-agent-guide
```

#### For Agent Skills System (Upstream)

```shell
mkdir -p ~/.claude/skills/
git clone https://github.com/f4ah6o/moonbit-agent-guide ~/.claude/skills/moonbit
```

Documentation: https://code.claude.com/docs/en/skills

### GitHub Copilot for VS Code

```shell
# enable moonbit skill for current repository
mkdir -p ./.github/skills/
git clone https://github.com/f4ah6o/moonbit-agent-guide ./.github/skills/moonbit
```

Note: Agent Skills support in VS Code is currently in preview and available only in [VS Code Insiders](https://code.visualstudio.com/insiders/). Enable the `chat.useAgentSkills` setting to use Agent Skills. See [Use Agent Skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills) for details.

### Cursor & Cursor CLI

> Agent Skills are available only in the Cursor nightly release channel.

Documentation: https://cursor.com/cn/docs/context/skills

### Gemini CLI

It seems that Gemini CLI will support agent skills in next release: https://github.com/google-gemini/gemini-cli/issues/15327
