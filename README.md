# MoonBit Agent Skill

This repository contains an [Agent Skill](https://agentskills.io/home) that teaches AI coding agents the MoonBit programming language and its toolchain.

## Integrate the Skill into your agent

<<<<<<< HEAD
### Claude Code

```
/plugin marketplace add f4ah6o/moonbit-agent-guide
```

re-install
```
/plugin marketplace remove moonbit-agent-guide
/plugin marketplace add f4ah6o/moonbit-agent-guide
```

### Codex

```
$skill-installer install https://github.com/f4ah6o/moonbit-agent-guide
```

see https://github.com/openai/skills

### AGENTS.md

Many AI code agents now have adopted the [`AGENTS.md`](https://agents.md)
convention for providing guidance for agents. For such agents, you may:

- Copy `Agents.mbt.md` into your project directory as `AGENTS.md`
- Append the content of `Agents.mbt.md` to your existing `AGENTS.md` file.

### Claude Code

[Claude Code](https://www.anthropic.com/claude-code) supports `CLAUDE.md` file.
Since `CLAUDE.md` supports `@path/to/import` syntax, we suggest copying
`Agents.mbt.md` into your project directory and mention it in `CLAUDE.md`. For
example, suppose you copied `Agents.mbt.md` to your project directory as
`moonbit.mbt.md`, then you can add the following line to your `CLAUDE.md` file:

```markdown
# MoonBit Language Reference
- @moonbit.mbt.md
```

See [Memory Management](https://docs.claude.com/en/docs/claude-code/memory)
on detailed configuration.
=======
Different AI assistants require different configuration methods. Below are guides for popular coding assistants:
>>>>>>> upstream/main

### Codex CLI

```shell
mkdir -p ~/.codex/skills/
git clone https://github.com/moonbitlang/moonbit-agent-guide ~/.codex/skills/moonbit
```

Documentation: https://developers.openai.com/codex/skills

### Claude Code

```shell
mkdir -p ~/.claude/skills/
git clone https://github.com/moonbitlang/moonbit-agent-guide ~/.claude/skills/moonbit
```

Documentation: https://code.claude.com/docs/en/skills

### GitHub Copilot for VS Code

```shell
# enable moonbit skill for current repository
mkdir -p ./.github/skills/
git clone https://github.com/moonbitlang/moonbit-agent-guide ./.github/skills/moonbit
```

Note: Agent Skills support in VS Code is currently in preview and available only in [VS Code Insiders](https://code.visualstudio.com/insiders/). Enable the `chat.useAgentSkills` setting to use Agent Skills. See [Use Agent Skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills) for details.

### Cursor & Cursor CLI

> Agent Skills are available only in the Cursor nightly release channel.

Documentation: https://cursor.com/cn/docs/context/skills

### Gemini CLI

It seems that Gemini CLI will support agent skills in next release: https://github.com/google-gemini/gemini-cli/issues/15327
