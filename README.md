<div align="center">

# Doom Emacs Config

 [Description](#Description) • [Usage](#Usage)

 </div>

This is a basic config of a 100% newbie for Doom Emacs.
I started using emacs only in spring 2026, don't expect anything serious from this config.
If you're not familiar with Doom Emacs,  [check repo here](https://github.com/doomemacs/doomemacs).

## Description

This config tends to provide basic setup for various areas of development, might be useful for students.

For syntax check I prefer **eglot** over **lsp-mode** for optimization reasons. The same goes for **corfu** instead of **company**.

I've enabled support for these languages, consider disabling them in `init.el` in case you don't need them, and install listed language servers for each of them:
- C/C++ (clangd)
- bash (bash-language-server)
- java (Eclipse JDT Language Server)
- python (pyright)
- html/css
- system verilog (verible-verilog-lint)

This config prefers **treemacs** over **neotree** for tree view of the project.
I also chose **vterm** over **term**, consider installing cmake and libtool so it can compile.

## Usage

I've created this repo so I wouldn't lose my config. However, if you decide to downloading it for some reason, after updating your emacs config, don't forget to run:

``` shell
doom sync
```

and restart doom Emacs.
