# First Nix build target

Install `flake.nix` at the root of https://github.com/xanatoo/udanax-gold.

- `nix build`: compile `src/xpp/ccompatc.c` and `src/xpp/ccompatt.c` using a modern C compiler, run the C compatibility smoke test, and install a static library and executable.
- `nix run`: run the original `ccompatt` test program.
- `nix flake check`: run the same compiled smoke test.
- `nix develop`: enter a shell with GCC, Make, binutils and GDB.

This is deliberately NOT a build of Gold's whole backend. No original source files are modified, and the old X++ compiler/stubble/Make infrastructure is not invoked.

The flake hasn't been executed with Nix in the preparation environment (Nix and GitHub clone access are unavailable). Its C target was checked separately with GCC against an equivalent minimal compatibility header; full on-repository build remains to be verified.
