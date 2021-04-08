#!/bin/bash
cat >data/fr/portfolio.yml <<EOF
portfolio:
  enable: true
  title: Nos Créations
  portfolio_item:
EOF

for c in 3d photos drawings; do
  bdir="static/images/${c}"
  for f in $(ls -1tr ${bdir}/*.jpg|tail -n3); do
    n=$(basename $f .jpg)
    p="images/${c}/${n}"
    convert $f ${bdir}/${c}${n}.webp
    ct=$(tr '[:lower:]' '[:upper:]' <<< ${c:0:1})${c:1}
    cat >>data/fr/portfolio.yml <<EOF
    - name: "${n}"
      image: "${p}.jpg"
      image_webp: "${p}.webp"
      categories: ["${ct}"]
      content: ""
      link: "#"
EOF
  done
  for f in $(ls -1tr ${bdir}/*.webp); do
    n=$(basename "$f" .webp)
    p="images/${c}/${n}"
    bdir="content/blog"
    if [[ ! -f "${bdir}/${n}.md" ]]; then
      echo "Have to create $n"
      cat > "${bdir}/${n}.md" << EOF
---
title: "${n}"
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
