# Skills BONSAI

A curation repository of skills

## Acknowledgement

* [skill-check-skill](https://github.com/nyanko3141592/skill-check-skill) by [電電猫猫](https://github.com/nyanko3141592)
  * MIT License

## Maintenance

This repository includes a script to check if 3rd-party skills are up-to-date with their upstream repositories.

### How it works

The script reads `.claude-plugin/marketplace.json` and checks plugins that have the `x-installed-sha` field defined. It compares the locally tracked commit SHA (`x-installed-sha`) with the latest commit on the upstream repository (derived from `author.url`).

### Usage

**Local Check:**

Prerequisites: `jq` and `gh` (GitHub CLI) must be installed.

```bash
./scripts/check_updates.sh
```

**GitHub Actions:**

The check runs automatically every Monday via a GitHub Action workflow defined in `.github/workflows/check_updates.yml`. You can also trigger it manually from the "Actions" tab.

### Adding a new tracked skill

To track a new skill, ensure the `author.url` points to the GitHub repository and add tracking fields to its entry in `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-skill",
  "author": {
      "name": "author-name",
      "url": "https://github.com/owner/repo"
  },
  ...
  "x-installed-sha": "CURRENT_SHA_HASH",
  "x-installed-date": "YYYY-MM-DDTHH:MM:SSZ"
}
```
