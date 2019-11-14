# The Internals of Delta Lake Online Book

The project contains the sources of [The Internals of Delta Lake](FIXME) online book.

The aim of the project is to learn the following:

* [Delta Lake](https://delta.io/) as it comes from my gurus from the Spark SQL / Structured Streaming crew at [Databricks](https://databricks.com/) (Michael, TD, Burak, zsxwing, and many others)

* [Antora](https://antora.org/)

## Writing Environment

I'm on macOS Catalina and use Docker to [run the Antora image](https://docs.antora.org/antora/2.2/antora-container/#run-the-antora-image).

```
$ docker run -u $UID --privileged -v `pwd`:/antora --rm -t antora/antora antora-playbook.yml

// alternatively and recommended
$ docker run --entrypoint ash --privileged -v `pwd`:/antora --rm -it antora/antora

// Inside the container
/antora # antora version
2.2.0

/antora # antora site.yml

// On your local computer (outside the container)
$ open .out/local/index.html
```

I use [Atom Editor](https://atom.io/) for editing the files.

## Not Sphinx?! Why?

Read [Giving up on Read the Docs, reStructuredText and Sphinx](https://medium.com/@jaceklaskowski/giving-up-on-read-the-docs-restructuredtext-and-sphinx-674961804641).
