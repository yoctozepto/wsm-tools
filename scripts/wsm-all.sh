#!/bin/sh

for MIZAR_ARTICLE in *.miz
do
    accom "$MIZAR_ARTICLE"
    wsmparser "$MIZAR_ARTICLE"
done
