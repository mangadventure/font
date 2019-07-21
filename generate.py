#!/usr/bin/env python3

from pathlib import Path
from re import search

from sass import compile as sassc

path = Path(__file__).resolve().parent
pattern = r"^[.]mi-([\w-]+):before.*'\\([0-9a-f]+)'"
css = open(path / 'css' / 'mangadventure-codes.css', 'r')
scss = open(path / 'src' / '_codes.scss', 'w')
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

sassc(dirname=(path / 'src', path / 'dist'), output_style='compressed')
