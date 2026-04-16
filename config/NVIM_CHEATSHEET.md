# Vim + LazyVim Cheatsheet

Practical overview of the most useful Vim motions, operators, and LazyVim shortcuts for this config.

- `<leader>` = `<space>`
- `<localleader>` = `\`
- Press `<space>` and pause to open `which-key` and discover available mappings

## Learn These First

If you only memorize a small set, start here:

- Move: `h`, `j`, `k`, `l`, `w`, `b`, `e`, `0`, `^`, `$`, `gg`, `G`
- Edit: `i`, `a`, `o`, `dd`, `yy`, `p`, `u`, `<C-r>`
- Change fast: `ciw`, `diw`, `cw`, `dw`, `.`
- Search: `/`, `?`, `n`, `N`, `*`, `#`
- Select: `v`, `V`, `<C-v>`
- Discover LazyVim: `<leader><space>`, `<leader>/`, `<leader>e`, `<leader>cf`, `gd`, `gr`, `<leader>ca`

## Core Motions

### Basic movement

| Keys | Meaning |
| --- | --- |
| `h` `j` `k` `l` | left, down, up, right |
| `w` | next word start |
| `b` | previous word start |
| `e` | end of word |
| `0` | start of line |
| `^` | first non-blank character |
| `$` | end of line |
| `gg` | top of file |
| `G` | bottom of file |
| `%` | matching `()`, `{}`, `[]` |

### Precision movement on a line

| Keys | Meaning |
| --- | --- |
| `f<char>` | jump to character |
| `t<char>` | jump just before character |
| `F<char>` | jump backward to character |
| `T<char>` | jump backward just after character |
| `;` | repeat last `f`/`t` |
| `,` | repeat last `f`/`t` in reverse |

### Search movement

| Keys | Meaning |
| --- | --- |
| `/text` | search forward |
| `?text` | search backward |
| `n` | next match |
| `N` | previous match |
| `*` | search word under cursor forward |
| `#` | search word under cursor backward |

Note: in LazyVim, `j` and `k` are improved to move by wrapped screen lines when no count is given.

## Operators You Use Constantly

Operators become powerful when combined with motions or text objects.

| Key | Meaning |
| --- | --- |
| `d` | delete |
| `c` | change |
| `y` | yank / copy |
| `>` | indent right |
| `<` | indent left |

### High-value combos

| Keys | Meaning |
| --- | --- |
| `dd` | delete line |
| `cc` | change line |
| `yy` | yank line |
| `dw` | delete word forward |
| `cw` | change word forward |
| `diw` | delete inner word |
| `ciw` | change inner word |
| `dap` | delete around paragraph |
| `cip` | change inner paragraph |
| `di"` / `ci"` | inside double quotes |
| `di'` / `ci'` | inside single quotes |
| `da(` / `ci(` | around / inside parentheses |
| `da[` / `ci[` | around / inside brackets |
| `da{` / `ci{` | around / inside braces |

## Visual Mode

| Keys | Meaning |
| --- | --- |
| `v` | character-wise selection |
| `V` | line-wise selection |
| `<C-v>` | block-wise selection |
| `>` / `<` | indent and keep selection |
| `y` | yank selection |
| `d` | delete selection |
| `c` | change selection |

## Editing Basics

| Keys | Meaning |
| --- | --- |
| `i` | insert before cursor |
| `a` | insert after cursor |
| `o` | new line below |
| `O` | new line above |
| `p` / `P` | paste after / before |
| `u` | undo |
| `<C-r>` | redo |
| `.` | repeat last change |

`.` is one of the most useful Vim commands. If you do `ciw` once, you can move to the next word and press `.` to repeat the same edit pattern.

## Useful Text Objects

Text objects work especially well with `d`, `c`, `y`, and visual mode.

| Keys | Meaning |
| --- | --- |
| `iw` / `aw` | inner / around word |
| `ip` / `ap` | inner / around paragraph |
| `i"` / `a"` | inside / around double quotes |
| `i'` / `a'` | inside / around single quotes |
| `i(` / `a(` | inside / around parentheses |
| `i[` / `a[` | inside / around brackets |
| `i{` / `a{` | inside / around braces |

## Search, Jump, and Repeat Workflow

Common efficient pattern:

1. Search with `/` or jump with `f<char>`.
2. Apply an edit like `ciw`, `dw`, or `.`.
3. Use `n` or `;` to move to the next target.
4. Repeat with `.`.

This is one of the fastest ways to edit many similar things in Vim.

## LazyVim Discovery

LazyVim uses `which-key`, so the fastest way to learn is:

- Press `<space>` and wait
- Explore grouped menus like `f` for file/search, `g` for git, `c` for code, `u` for toggles
- Use `<leader>sk` to search keymaps
- Use `<leader>?` to show buffer-local keymaps

## Most Useful LazyVim Shortcuts

These are the default mappings that are relevant for this config.

### Files and search

| Keys | Meaning |
| --- | --- |
| `<leader><space>` | find files in project root |
| `<leader>ff` | find files in project root |
| `<leader>fF` | find files in current working directory |
| `<leader>/` | grep in project root |
| `<leader>sg` | grep in project root |
| `<leader>sG` | grep in current working directory |
| `<leader>sw` | search current word / visual selection in project root |
| `<leader>fr` | recent files |
| `<leader>fc` | find config file |
| `<leader>e` | file explorer rooted at project |
| `<leader>E` | file explorer rooted at cwd |
| `<leader>,` | open buffer picker |
| `<leader>:` | command history |
| `<leader>sk` | search keymaps |
| `<leader>sh` | help pages |

### Buffers, windows, tabs

| Keys | Meaning |
| --- | --- |
| `<S-h>` / `<S-l>` | previous / next buffer |
| `[b` / `]b` | previous / next buffer |
| `<leader>bb` | switch to other buffer |
| `<leader>bd` | delete buffer |
| `<leader>bo` | delete other buffers |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | move between windows |
| `<leader>-` | split window below |
| `<leader>|` | split window right |
| `<leader>wd` | close window |
| `<leader><tab><tab>` | new tab |
| `<leader><tab>d` | close tab |
| `<leader><tab>[` / `<leader><tab>]` | previous / next tab |

### Code and LSP

| Keys | Meaning |
| --- | --- |
| `gd` | go to definition |
| `gr` | references |
| `gI` | go to implementation |
| `gy` | type definition |
| `gD` | declaration |
| `K` | hover documentation |
| `gK` | signature help |
| `<leader>ca` | code action |
| `<leader>cr` | rename symbol |
| `<leader>cf` | format file or selection |
| `<leader>cd` | line diagnostics |
| `[d` / `]d` | previous / next diagnostic |
| `[e` / `]e` | previous / next error |
| `[w` / `]w` | previous / next warning |
| `<leader>ss` | document symbols |
| `<leader>sS` | workspace symbols |

### Git

| Keys | Meaning |
| --- | --- |
| `<leader>gs` | git status |
| `<leader>gl` | git log for project |
| `<leader>gL` | git log for cwd |
| `<leader>gb` | git blame line |
| `<leader>gf` | file history |
| `<leader>gB` | open git browse URL |
| `<leader>gY` | copy git browse URL |
| `<leader>gg` | lazygit for project root if `lazygit` is installed |

### Diagnostics, lists, and troubleshooting

| Keys | Meaning |
| --- | --- |
| `<leader>sd` | diagnostics picker |
| `<leader>sD` | buffer diagnostics picker |
| `<leader>sq` | quickfix list |
| `<leader>sl` | location list |
| `<leader>xq` | toggle quickfix list |
| `<leader>xl` | toggle location list |
| `[q` / `]q` | previous / next quickfix item |
| `<leader>xx` | diagnostics trouble view |
| `<leader>xX` | buffer diagnostics trouble view |

### Terminal and utility

| Keys | Meaning |
| --- | --- |
| `<leader>ft` | terminal in project root |
| `<leader>fT` | terminal in current working directory |
| `<C-/>` | focus terminal in project root |
| `<C-s>` | save file |
| `<esc>` | escape and clear search highlight |
| `<leader>qq` | quit all |
| `<leader>l` | open Lazy plugin manager |

### Useful toggles

| Keys | Meaning |
| --- | --- |
| `<leader>uf` | toggle auto format globally |
| `<leader>uF` | toggle auto format for current buffer |
| `<leader>uw` | toggle line wrap |
| `<leader>us` | toggle spelling |
| `<leader>ud` | toggle diagnostics |
| `<leader>uL` | toggle relative numbers |
| `<leader>ul` | toggle line numbers |
| `<leader>uh` | toggle inlay hints |
| `<leader>uz` | zen mode |

## Good Habits

- Prefer motions plus operators over selecting with the mouse
- Learn text objects like `ciw`, `ci"`, `ci(`, `dap`
- Use `.` aggressively to repeat edits
- Use `<space>` and `which-key` instead of memorizing everything at once
- Start with a small set and build up from real daily usage

## Notes For This Config

- This cheatsheet reflects the active default LazyVim keymaps in `config/nvim`
- `config/nvim/lua/config/keymaps.lua` is currently empty, so there are no extra local overrides documented here
- `config/nvim/lua/plugins/example.lua` contains example mappings, but it is disabled and not active
