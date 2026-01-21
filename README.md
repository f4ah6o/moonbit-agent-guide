# MoonBit Agent Skill

This repository makes it easier to auto-update by turning [moonbitlang/moonbit-agent-guide](https://github.com/moonbitlang/moonbit-agent-guide) into a Claude Code plugin. It incorporates upstream changes from time to time, but this is not automatic.

## Integrate the Skill into your agent

Different AI assistants require different configuration methods. Below are guides for popular coding assistants:

### Codex CLI

It's just a prompt, not a command, so being casual is fine.

```codex
$skill-installer install/update https://github.com/f4ah6o/moonbit-agent-guide
```

### Claude Code

In Claude Code, after `/plugin`, go to the Marketplaces tab > Add Marketplace and copy and paste "https://github.com/f4ah6o/moonbit-agent-guide.git".

After that, you can also set it to Auto Update from the list.

### antigravity

Just `cp` it from either of the above to `.agent/skills`.
