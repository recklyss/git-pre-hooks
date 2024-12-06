# git-pre-hooks
A folder that stores useful git pre hooks like pre-push or pre-commit

## Available Hooks

### pre-push-rebase
Automatically rebases your current branch with the base branch (e.g., develop) before pushing. This helps maintain a clean git history and prevents merge conflicts.

Features:
- Checks for unstashed changes before proceeding
- Updates the base branch with latest changes
- Performs automatic rebase
- Handles errors gracefully

## Installation

1. Clone this repository
2. Run the installation script:
   ```bash
   ./install-hooks.sh
   ```
3. Follow the interactive prompts to:
   - Select which hook to install
   - Configure hook-specific settings (e.g., base branch name for pre-push-rebase)

## Requirements
- Git repository
- Bash shell
