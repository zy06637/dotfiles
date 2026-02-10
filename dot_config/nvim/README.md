# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Colemak Keymap Layout

This config remaps navigation to the Colemak home row:

```
      u (上)
   n     i (右)
      e (下)
```

### Key Mappings

#### Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `u/e/n/i` | `k/j/h/l` | Basic movement |
| `U/E` | `5k/5j` | Fast vertical movement |
| `N` | `^` | First non-blank character |
| `I` | `$` | End of line |
| `h` | `e` | Word end |
| `W/B` | `5w/5b` | Fast word movement |
| `<C-U>/<C-E>` | `5<C-y>/5<C-e>` | Scroll viewport |

#### Mode Switching

| Key | Action |
|-----|--------|
| `l` | Undo |
| `k` | Insert mode |
| `K` | Insert at line start |

#### Save / Quit

| Key | Action |
|-----|--------|
| `S` | Save |
| `Q` | Quit |
| `<Leader>w` | Save |
| `<Leader>q` | Quit |
| `<Leader>x` | Save and quit |

#### Search

| Key | Action |
|-----|--------|
| `=` | Next search result (centered) |
| `-` | Previous search result (centered) |
| `<Leader>/` | Clear search highlight |

#### Register Management

Bare `d/c/x` use the black hole register. Prefix with `<Leader>` to save to register.

| Key | Action |
|-----|--------|
| `d/c/x` | Delete/change/char-delete (black hole) |
| `<Leader>d/c` | Delete/change (saves to register) |
| `<Leader>y` | Yank to system clipboard |
| `<Leader>p` | Paste from system clipboard |

#### Line Moving

| Key | Mode | Action |
|-----|------|--------|
| `<A-e>` | n/i/v | Move line(s) down |
| `<A-u>` | n/i/v | Move line(s) up |

#### Buffer Navigation

| Key | Action |
|-----|--------|
| `<Leader>bn` | Next buffer |
| `<Leader>bp` | Previous buffer |

#### Utilities

| Key | Action |
|-----|--------|
| `gV` | Select last pasted/modified text |
| `<Leader>tw` | Toggle word wrap |
