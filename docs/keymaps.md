# Keymaps

This is a reference of the default keymaps nvix sets. All use `<space>`
as leader unless changed via `nvix.leader`.

---

## General (common/mappings.nix)

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` | n, i, v | Save file |
| `<leader>qq` | n | Quit all |
| `<leader>qw` | n | Close window |
| `<leader><leader>` | n | Clear search highlight |
| `<Esc>` | n | Clear search highlight |
| `<leader>A` | n | Select all |
| `<leader>\|` | n | Vertical split |
| `<leader>-` | n | Horizontal split |
| `<A-j>` | n, v, i | Move line down |
| `<A-k>` | n, v, i | Move line up |
| `<A-+>` | n | Increment number |
| `<A-->` | n | Decrement number |
| `jk` | i | Exit insert mode |
| `<C-a-h/j/k/l>` | n | Resize window (smart-splits) |
| `<C-h/j/k/l>` | n | Move cursor (smart-splits) |
| `<C-\>` | n | Previous cursor (smart-splits) |
| `?` | n | Flash search |
| `<leader>vt` | n | Select treesitter node |
| `<leader>ut` | n | Toggle trim |
| `<leader>uC` | n | Toggle stay-centered |
| `<leader>ft` | n | Set filetype |
| `<leader>id` | n | Insert date at cursor |
| `<leader>dd` | n | Toggle diff on all windows |
| `<leader>cn/cp/cq` | n | Quickfix next/prev/close |
| `n` / `N` | n | Search next/prev (centered) |

### Black-hole register

`x`, `X`, `c`, `C` use black-hole register (`"_`) so they don't yank.
Visual `p` pastes without overwriting clipboard.

## Buffers (buffer.nix)

| Key | Mode | Action |
|-----|------|--------|
| `<S-h>` / `<S-l>` | n | Previous/next buffer |
| `<leader>bb` | n | Harpoon UI |
| `<leader>b.` | n | Add file to harpoon |
| `<leader>bp` | n | Buffer line pick |
| `<leader>bP` | n | Pin buffer |
| `<leader>bc` | n | Close other buffers |
| `<leader>bd` | n | Sort by directory |
| `<leader>be` | n | Sort by extension |
| `<leader>bH/L` | n | Close left/right buffers |
| `<A-S-h/l>` | n | Move buffer left/right |
| `<leader>qc` | n | Close buffer |
| `<leader><tab>n` | n | New tab |
| `<leader><tab>j/k` | n | Next/prev tab |
| `<leader><tab>q` | n | Close tab |

## Explorer & Picker (snacks)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | n | Toggle explorer |
| `<leader>ff` | n | Find files |
| `<leader>fF` | n | Smart find |
| `<leader>fr` | n | Recent files |
| `<leader>fp` | n | Projects |
| `<leader>f/` | n | Grep |
| `<leader>f?` | n | Grep (fixed strings) |
| `<leader>sg` | n | Grep (search) |
| `<leader>sw` | n, x | Grep word/selection |
| `<leader>sb` | n | Buffer lines |
| `<leader>sh` | n | Help pages |
| `<leader>sk` | n | Keymaps |
| `<leader>ss` | n | LSP symbols |
| `<leader>sS` | n | Workspace symbols |
| `<leader>sd` | n | Diagnostics |
| `<leader>su` | n | Undo history |
| `<leader>s,` | n | Buffers |
| `<leader>s:` | n | Command history |
| `<leader>..` | n | Toggle scratch buffer |
| `<leader>.s` | n | Select scratch buffer |
| `<leader>.r` | n | Rename file (LSP-aware) |
| `<leader>un` | n | Dismiss notifications |

## Git (git.nix)

| Key | Mode | Action |
|-----|------|--------|
| `]h` / `[h` | n | Next/prev hunk |
| `]H` / `[H` | n | Last/first hunk |
| `<leader>gs` | n, v | Stage buffer/hunk |
| `<leader>gr` | n, v | Reset buffer/hunk |
| `<leader>gu` | n | Undo stage hunk |
| `<leader>gp` | n, v | Preview hunk inline |
| `<leader>gP` | n | Preview hunk (popup) |
| `<leader>gdd` | n | Diffview open |
| `<leader>gdh` | n | Diffview file history |
| `<leader>gk` | n | Blame line (full) |
| `<leader>gK` | n | Blame file |
| `<leader>gb` | n | Toggle line blame |
| `<leader>gw` | n | Toggle word diff |
| `<leader>gB` | n | Git browse |
| `<leader>gg` | n | Lazygit |
| `<leader>gl` | n | Lazygit log (cwd) |
| `<leader>gf` | n | Lazygit current file history |
| `ih` | o, x | Select hunk (text object) |

## LSP (lsp/mappings.nix)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Goto definition |
| `gt` | n | Goto type definition |
| `gr` | n | References (trouble) |
| `gI` | n | Goto implementation |
| `K` | n | Hover doc (or peek fold) |
| `gpd` | n | Peek definition |
| `gpt` | n | Peek type definition |
| `<leader>la` | n | Code action |
| `<leader>lr` | n | Rename (project) |
| `<leader>lo` | n | Outline |
| `<leader>lw` | n | Workspace diagnostics |
| `<leader>l.` | n | Line diagnostics |
| `<leader>lf` | n, x, v | Format file |
| `<leader>li` | n | LSP info |
| `<leader>ls` | n | Start LSP |
| `<leader>lq` | n | Stop LSP |
| `<leader>lR` | n | Restart LSP |
| `<leader>lD` | n | Definitions list |
| `<leader>lL` | n | Toggle diagnostics |
| `<leader>ll` | n | Toggle virtual text |
| `[e` / `]e` | n | Prev/next diagnostic |
| `zR` | n | Open all folds |
| `zM` | n | Close all folds |
| `zK` | n | Peek folded lines |

## AI (ai/copilot.nix)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ac` | n | Toggle Copilot |
| `<C-space>` | i | Accept suggestion (Copilot or blink-cmp) |
| `<leader>aCc` | n | ChatGPT |
| `<leader>aCe` | n, v | Edit with instruction |
| `<leader>aCg` | n, v | Grammar correction |
| `<leader>aCt` | n, v | Translate |
| `<leader>aCd` | n, v | Add docstring |
| `<leader>aCa` | n, v | Add tests |
| `<leader>aCo` | n, v | Optimize code |
| `<leader>aCf` | n, v | Fix bugs |
| `<leader>aCx` | n, v | Explain code |

## Session (autosession.nix)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>q.` | n | Restore last session |
| `<leader>ql` | n | List sessions |
| `<leader>qd` | n | Delete session |
| `<leader>qs` | n | Save session |
| `<leader>qD` | n | Purge orphaned sessions |

## UI toggles (snacks)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ud` | n | Toggle diagnostics |
| `<leader>ul` | n | Toggle line numbers |
| `<leader>uh` | n | Toggle inlay hints |
| `<leader>uT` | n | Toggle treesitter |
| `<leader>us` | n | Toggle spelling |
| `<leader>uw` | n | Toggle wrap |
| `<leader>uL` | n | Toggle relative numbers |
| `<leader>uc` | n | Toggle conceal level |
| `<leader>ub` | n | Toggle dark background |

## Markdown (lang/md.nix)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>pg` | n | Glow (terminal) preview |
| `<leader>pb` | n | Browser preview + copy URL |
| `<leader>pp` | n | Print to PDF (pandoc) |
| `<leader>os` | n | Obsidian quick switch |
| `<leader>o/` | n | Obsidian search |
| `<leader>ot` | n | Obsidian tag search |
| `<leader>ol` | n | Obsidian buffer links |
| `<leader>or` | n | Obsidian backlinks |
| `<leader>o<CR>` | n | Make note from word under cursor |
