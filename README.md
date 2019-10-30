# The Internals of Delta Lake Online Book

The project contains the sources of The Internals of Delta Lake online book in [reStructuredText Primer](http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html).

The aim of the project are to learn the following:

* [Delta Lake](https://delta.io/) as it comes from my gurus from the Spark SQL / Structured Streaming crew at [Databricks](https://databricks.com/) (Michael, TD, Burak, zsxwing, and many others)

* [Read the Docs](https://readthedocs.org/) for online documentation with support for GitHub and multiple versions

* [reStructuredText](http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html) - the default plaintext markup language used by Sphinx and the preferred format for technical documentation at Read the Docs

## Writing Environment

I'm on macOS Catalina and followed [Installing Sphinx on macOS](https://www.sphinx-doc.org/en/master/usage/installation.html#macos) with brew packager.

```
// Installs into /usr/local/opt/sphinx-doc/bin
$ brew install sphinx-doc

$ type sphinx-quickstart
sphinx-quickstart not found

$ /usr/local/opt/sphinx-doc/bin/sphinx-quickstart --version
sphinx-quickstart 2.2.1

$ make html

$ open _build/html/index.html
```

I use [Atom Editor](https://atom.io/) with [language-restructuredtext](https://atom.io/packages/language-restructuredtext) plugin for editing rst files.

## Docker (TODO)

I wish I could use [Docker](https://www.docker.com/) with the [python](https://hub.docker.com/_/python/) official image as the writing environment.

```
$ docker pull python

$ docker run \
   -it \
   --rm \
   --name sphinx \
   -v "$PWD":/docs \
   -w /docs \
   -e USER_ID=$UID \
   python \
   /bin/bash
```
