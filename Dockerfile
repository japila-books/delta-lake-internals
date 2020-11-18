FROM squidfunk/mkdocs-material:6.1.5
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install \
  mkdocs-git-revision-date-plugin \
  mkdocs-awesome-pages-plugin \
  mkdocs-macros-plugin
