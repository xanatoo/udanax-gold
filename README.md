# Udanax Gold

Source code of **Udanax Gold**, the second of the two Xanadu hypertext
systems released as open source by Udanax.com (formerly the Xanadu Operating
Company). Its companion, Udanax Green, is a separate project.

The files come from the original distribution at
<https://udanax.xanadu.com/gold/download/index.html>. They are kept here
as originally released, so the tree contains build leftovers (object files,
editor backups, `a.out`) and platform-specific variants.

## Layout

| Directory   | Contents |
|-------------|----------|
| `src/`      | The Udanax Gold back end (`server`, `disk`, `comm`, `urdi`, `xpp`, `xlatexpp`, `stubble`, `platform`, ...) in the X++ dialect of C++, with per-platform directories such as `gnulinux`, `gnusun` and `sun`. |
| `formic/`   | Formic, the tooling used to process X++ (including a parser). |
| `smalltalk/`| A bundled copy of GNU Smalltalk 1.1.1, used by the original build tooling. |
| `winfe/`    | A Windows front end (C++, MFC style) from 1993. |
| `hack/`     | Small C test programs. |

## CVS metadata

Some directories contain `CVS/` subdirectories (`Entries`, `Repository`, ...).
These are CVS working-copy metadata, not a repository. They record each file's
revision and checkout date (the original repository path was `/xuenv/CVS/prod/...`).
The revision history itself (`*,v` files) is not included, so no earlier
history could be imported into git. The `CVS/` directories are kept as-is.

## License

Udanax Gold is released under the MIT/X11 license, see [LICENSE](LICENSE).
The text is the one published by Udanax.com at
<https://udanax.xanadu.com/license.html>, which says it applies to both Udanax Green and Udanax Gold.

The bundled `smalltalk/` directory is GNU Smalltalk by Steve Byrne and is
licensed under the GNU General Public License (version 1), see
`smalltalk/COPYING`. It is not covered by the Udanax license.
