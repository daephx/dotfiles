# Dotfiles

This repository utilizes [Dotbot](https://github.com/anishathalye/dotbot), see repository for more information.

## Table of Contents
<!-- TOC GFM -->

- [Dependencies](#dependencies)
- [Installation](#installation)
    - [For installing a predefined profile:](#for-installing-a-predefined-profile)
    - [For installing single configurations:](#for-installing-single-configurations)
- [Contents](#contents)
    - [Profiles](#profiles)
    - [Configs](#configs)
- [License](#license)

<!-- /TOC -->

## Dependencies
- git

## Installation

```bash
~$ git clone --recursive https://github.com/daephx/dotfiles.git ~/.dotfiles
~$ cd ~/.dotfiles
```

### For installing a predefined profile:

```bash
~/.dotfiles ./install-profile <profile> [<configs...>]
```
See [meta/profiles/](./meta/profiles) for available profiles


### For installing single configurations:

```bash
~/.dotfiles ./install-standalone <configs...>
```
See [meta/configs/](./meta/configs) for available configurations

_*Note:*_ Any configuration can be run as sudo by adding `-sudo` to the end of it when invoking the install script.
*DO NOT* run the script as a sudoer.

## Contents

### Profiles
<pre>
meta/profiles
├── <a href="./meta/profiles/ubuntu" title="ubuntu">exampleOS1</a>
└── <a href="./meta/profiles/macos" title="macos">exampleOS2</a>
</pre>

### Configs
<pre>
meta
├── <a href="./meta/base.yaml" title="base.yaml">base.yaml</a>
└── configs
    ├── <a href="./meta/configs/zsh.install.yaml" title="zsh.install.yaml">zsh.install.yaml</a>
    └── <a href="./meta/configs/zsh.conf.yaml" title="zsh.conf.yaml">zsh.conf.yaml</a>
</pre>

## License
This software is hereby released under an MIT License. That means you can do whatever you want with conditions only requiring preservation of copyright and license notices.
See [LICENSE](./LICENSE) for details.
