#!/bin/sh

for WSM_ARTICLE in *.wsm
do
    if ! wsm-parser "${WSM_ARTICLE%.wsm}.dct" "$WSM_ARTICLE"; then
        echo "Problems with $WSM_ARTICLE"
    fi
done
