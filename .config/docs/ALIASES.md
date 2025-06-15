# Dotfiles - Alias Reference

This document provides a comprehensive reference for all aliases included in the dotfiles, both ZSH shell aliases and Git aliases.

- [ZSH Aliases](#zsh-aliases)
- [Git Aliases](#git-aliases)
- [Back to README](../README.md)

## ZSH Aliases

These aliases are defined in `.config/zsh/aliases.zsh` and loaded automatically when your shell starts.

### Modern CLI Tool Aliases

#### eza (Modern ls)
| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Basic file listing with icons |
| `ll` | `eza -l --icons --git` | Long listing with git status |
| `la` | `eza -la --icons --git` | Show all files (including hidden) |
| `lt` | `eza -T --icons` | Tree view of directory structure |
| `lg` | `eza --git-ignore` | List files respecting .gitignore |

#### bat (Modern cat)
| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat --style=plain` | Display file with syntax highlighting |
| `catp` | `bat --plain` | Display file without line numbers or decorations |
| `bathelp` | `bat --plain --language=help` | Display help pages with syntax highlighting |

#### fd (Modern find)
| Alias | Command | Description |
|-------|---------|-------------|
| `find` | `fd` | Find files with simpler syntax |

#### ripgrep (Modern grep)
| Alias | Command | Description |
|-------|---------|-------------|
| `grep` | `rg` | Search file contents with faster, better output |

#### Neovim
| Alias | Command | Description |
|-------|---------|-------------|
| `vim` | `nvim` | Use Neovim instead of Vim |
| `vi` | `nvim` | Use Neovim instead of Vi |

### Navigation Aliases
| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `clear` | Clear terminal screen |
| `h` | `history` | Show command history |
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `cd..` | `cd ..` | Fix for common typo |

### File Operation Aliases
| Alias | Command | Description |
|-------|---------|-------------|
| `mkdir` | `mkdir -p` | Create parent directories automatically |
| `cp` | `cp -i` | Prompt before overwriting with copy |
| `mv` | `mv -i` | Prompt before overwriting with move |
| `ln` | `ln -i` | Prompt before overwriting with link |

### System Aliases
| Alias | Command | Description |
|-------|---------|-------------|
| `df` | `df -h` | Show disk usage with human-readable sizes |
| `du` | `du -h` | Show file/directory sizes with human-readable sizes |
| `free` | `free -m` | Show memory usage in megabytes |

### Git Shortcut Aliases
| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Short for git command |
| `gs` | `git status` | Check git status |
| `gl` | `git log` | View git commit history |

### Terminal UI Tools
| Alias | Command | Description |
|-------|---------|-------------|
| `lg` | `lazygit` | Terminal UI for git operations |
| `ld` | `lazydocker` | Terminal UI for docker management |
| `top` | `btop` | Better interactive process viewer |

### JSON Handling
| Alias | Command | Description |
|-------|---------|-------------|
| `jqp` | `jq '.'` | Pretty-print JSON |
| `jqs` | `jq -r 'keys'` | Show JSON keys |
| `jqv` | `jq -r '.[] \| .'` | Show JSON values |

### HTTP Client
| Alias | Command | Description |
|-------|---------|-------------|
| `GET` | `http GET` | HTTP GET request |
| `POST` | `http POST` | HTTP POST request |
| `HEAD` | `http HEAD` | HTTP HEAD request |
| `httpj` | `http --json` | HTTP with JSON content-type |

### Diff Tool
| Alias | Command | Description |
|-------|---------|-------------|
| `diff` | `difft` | Use difftastic for better diffs |

### Task Runner
| Alias | Command | Description |
|-------|---------|-------------|
| `j` | `just` | Run just command |
| `jl` | `just --list` | List available just recipes |

### FZF Utilities
| Alias | Command | Description |
|-------|---------|-------------|
| `fcd` | `cd $(find . -type d \| fzf)` | Interactive cd to directory |
| `fopen` | `xdg-open $(find . -type f \| fzf)` | Open file with default app |
| `ff` | `find . -type f \| fzf` | Find files interactively |
| `fd` | `find . -type d \| fzf` | Find directories interactively |

## Git Aliases

These aliases are defined in `.gitconfig` and are used with the `git` command.

### Status & Information Commands
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `s` | `status -s` | Short status output | `git s` |
| `st` | `status` | Full status details | `git st` |
| `stat` | `status` | Alternative for status | `git stat` |

### Branching Operations
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `co` | `checkout` | Switch branches | `git co main` |
| `cb` | `checkout -b` | Create and checkout new branch | `git cb feature/new-login` |
| `b` | `branch` | List local branches | `git b` |
| `branches` | `branch -a` | List all branches (local and remote) | `git branches` |

### Commit Operations
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `cm` | `commit -m` | Commit with message | `git cm "Add login button"` |
| `ca` | `commit --amend` | Amend previous commit | `git ca` |
| `amend` | `commit --amend --no-edit` | Add to previous commit without changing message | `git amend` |

### Staging Operations
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `aa` | `add -A` | Stage all changes | `git aa` |
| `ap` | `add -p` | Stage changes interactively | `git ap` |

### Log & History Viewing
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `lg` | `log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit` | Pretty graph log | `git lg` |
| `ll` | `log --oneline` | Compact log format | `git ll` |
| `history` | `log --follow -p --` | File history with changes | `git history path/to/file.js` |
| `last` | `log -1 HEAD` | Show last commit | `git last` |

### Diff Operations
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `d` | `diff` | Show unstaged changes | `git d` |
| `ds` | `diff --staged` | Show staged changes | `git ds` |

### Remote Operations
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `fet` | `fetch` | Fetch changes from remote | `git fet` |
| `f` | `fetch` | Short alias for fetch | `git f` |
| `up` | `!git pull --rebase --prune $@` | Pull, rebase & prune | `git up` |

### Reset & Cleanup Operations
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `unstage` | `reset HEAD --` | Remove from staging area | `git unstage file.txt` |
| `discard` | `checkout --` | Discard local changes | `git discard file.txt` |
| `uncommit` | `reset --soft HEAD~1` | Undo last commit | `git uncommit` |

### Stash Operations
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `save` | `stash push` | Save changes to stash | `git save` |
| `pop` | `stash pop` | Apply and remove latest stash | `git pop` |
| `list-stash` | `stash list` | List all stashed changes | `git list-stash` |

### File Management & Information
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `ls` | `ls-files` | List tracked files | `git ls` |
| `config-list` | `config --list` | Show all git config | `git config-list` |
| `find` | `grep -n` | Search files with line numbers | `git find "function search"` |

### Repository Overview
| Alias | Command | Description | Example |
|-------|---------|-------------|---------|
| `overview` | `!git log --stat --since='2 weeks' --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit` | Recent activity summary | `git overview` |
| `aliases` | `!git config --get-regexp '^alias\\.' \| sed 's/alias\\.\\([^ ]*\\) \\(.*\\)/\\1\\t=> \\2/' \| sort` | List all git aliases | `git aliases` |
