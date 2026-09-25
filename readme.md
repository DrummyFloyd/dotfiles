# DrummyFloyd Dotfiles

- managed by [chezmoi](https://github.com/twpayne/chezmoi)
- Bitwarden password manager [rbw](https://github.com/doy/rbw)
- Thanks to [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles) about `rootmoi` workaround, which allow to managed non `$HOME` files with `chezmoi`.

This dotfiles repository configure personnal and work environment:

- Arch Linux
- Ubuntu (+ WSL Ubuntu)
- soft Windows configuration trhu' WSL

## WARNING

This dotfiles are custommized, this is shared for informational purposes only. Use at your own risk.

## Install

On a fresh machine:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply DrummyFloyd
```

Or from a local clone: `./install.sh`.

## Arch packages

`home/.chezmoidata/arch/pacman.yaml` is curated by hand, `chezmoi apply` installs what is missing.

Run `pkg-drift` to compare it with the system:

- installed explicitly but not declared: add it to `pacman.yaml`, or uninstall it
- declared but not installed: install it, or drop it from `pacman.yaml`

Packages kept on purpose on a single machine go in `~/.config/pkg-drift/ignore` (one per line, not managed by chezmoi).
