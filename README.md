Source of the package that installs [Keypirinha](http://keypirinha.com) via
[Chocolatey](https://chocolatey.org/packages/keypirinha)


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


### Versioning

Keypirinha's version and the version string of the resulting Chocolatey package
are different values.

The `build/VERSION` file contains the target version of Keypirinha, as opposed
to the version of the Chocolatey package itself, which can be found in
`build/keypirinha.nuspec` (tag `<version>`).

As [recommended](https://chocolatey.org/docs/create-packages#package-fix-version-notation)
in Chocolatey's documentation, if the Chocolatey package needs to be fixed and
re-released, the final version string of the package should be of the form
`x.y.z.YYYYMMDD` where `x.y.z` is the version sting of Keypirinha and `YYYYMMDD`

**CAUTION:** if Keypirinha version is of the form `x.y`, it must be suffixed
with a `.0` to maintain consistency with previous and following Keypirinha
version numbers.


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
