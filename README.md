Source of the package that installs [Keypirinha](http://keypirinha.com) via
[Chocolatey](https://chocolatey.org)


### Directory Structure

The `src` directory contains the templates of the source files used to generate
the full content of the `build` directory. The files in the `src` directory are
not ready to be used by Chocolatey tools. This is where every modification
should be done.

The `build` directory is generated automatically by Keypirinha's internal build
process from the files and templates (`*.in`) found in the `src` directory.

For each new release of Keypirinha, `build` is **fully overwritten** then
commited in the `master` branch. The resulting commit is tagged with the
according version number of Keypirinha (dotted format, prefixed with a "v"; e.g.
"v1.0.1").


### File Encoding

File encoding and formatting is specified in `.editorconfig` as follows:

* Files must be encoded in UTF-8 without BOM, except `.ps1` files that must be
  encoded in UTF-8 **with** BOM (required by PowerShell)
* Windows newlines (CRLF)


### Build

To generate the `.nupkg` file:

```
cd build
choco pack
```

Test install:

```
choco install -dvy -s . keypirinha
```

Notes:

* The `--force` flag may be used to force reinstall the package
* `install` may be replaced by `upgrade`
