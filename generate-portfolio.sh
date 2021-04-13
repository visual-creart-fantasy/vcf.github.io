#!/bin/bash
cat >data/fr/portfolio.yml <<EOF
portfolio:
  enable: true
  title: À la une
  portfolio_item:
EOF

for c in 3d photos drawings; do
  bdir="static/images/${c}"
  for f in $(ls -1tr ${bdir}/*.jpg|tail -n3); do
    n=$(basename $f .jpg)
    p="images/${c}/${n}"
    convert $f -resize 800x $f
    test -f ${bdir}/${n}.webp || convert $f ${bdir}/${n}.webp
    ct=$(tr '[:lower:]' '[:upper:]' <<< ${c:0:1})${c:1}
    blog_n=$(tr '[:upper:]' '[:lower:]' <<< $n)
    cat >>data/fr/portfolio.yml <<EOF
    - name: "Ouvrir"
      image: "${p}.jpg"
      image_webp: "${p}.webp"
      categories: ["${ct}"]
      content: ""
      link: "./blog/${blog_n}"
EOF
  done
  for f in $(ls -1 ${bdir}/*.webp); do
    n=$(basename "$f" .webp)
    p="images/${c}/${n}"
    bdir="content/blog"
    if [[ ! -f "${bdir}/${n}.md" ]]; then
      cat > "${bdir}/${n}.md" << EOF
---
title: ""
date: $(stat -c %y ${f})
author: Artist
image_webp: "${p}.webp"
image: ${p}.jpg
description: ""
---
EOF
    fi
  done
done
