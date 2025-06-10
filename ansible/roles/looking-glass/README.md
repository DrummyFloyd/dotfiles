# LookingGlass Ansible Role

This Ansible role clones, builds, and installs LookingGlass with its DKMS modules for Ubuntu and Arch Linux systems.

## Requirements

- Ansible 2.9+
- Ubuntu/Debian or Arch Linux
- Root/sudo access for package installation and DKMS operations
- Internet connection for git clone

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Repository URL
lg_repo_url: "https://github.com/gnif/LookingGlass.git"

# Git tag/version to checkout (empty for latest)
lg_version: ""

# Make options (useful for Wayland support)
lg_make_options: "-DENABLE_LIBDECOR=ON"

# Additional cmake options
lg_cmake_options: ""
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: servers
  become: yes
  roles:
    - role: lookingglass
      vars:
        lg_version: "B6"
        lg_make_options: "-DENABLE_LIBDECOR=ON -j4"
```

## Usage Examples

### Basic installation (latest version)

```yaml
- hosts: gaming_rigs
  become: yes
  roles:
    - lookingglass
```

### Install specific version with custom options

```yaml
- hosts: workstations
  become: yes
  roles:
    - role: lookingglass
      vars:
        lg_version: "B6"
        lg_make_options: "-DENABLE_LIBDECOR=ON -j$(nproc)"
```

### For Wayland/Hyprland setup

```yaml
- hosts: wayland_desktops
  become: yes
  roles:
    - role: lookingglass
      vars:
        lg_make_options: "-DENABLE_LIBDECOR=ON"
```

## Notes

- Repository is cloned to `/tmp/LookingGlass`
- The role installs linux-headers and dkms packages with `--nodeps` option as requested
- DKMS module installation requires root privileges
- Supports Ubuntu/Debian and Arch Linux distributions
- Build artifacts are left in `/tmp/LookingGlass` for debugging purposes
