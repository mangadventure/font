#!/usr/bin/env python

from os.path import abspath, dirname, join
from sass import compile as sassc
from re import search

path = dirname(abspath(__file__))
pattern = r"^[.]mi-([\w-]+):before.*'\\([0-9a-f]+)'"
css = open(join(path, 'css', 'mangadventure-codes.css'), 'r')
scss = open(join(path, 'src', '_codes.scss'), 'w')
font_range = None

css.readline()  # Skip blank line
scss.write('$codes: (\n')

for line in css:
    matches = search(pattern, line).groups()
    scss.write("  '%s': '%s',\n" % matches)
    font_range = matches[1]

scss.write(");\n\n$range: 'u+f101-%s';\n\n" % font_range)

css.close()
scss.close()

sassc(
    dirname=(join(path, 'src'), join(path, 'dist')),
    output_style='compressed'
)

