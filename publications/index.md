---
title: Publications
redirect_from: /research/
nav:
  order: 4
  tooltip: Recent papers, commentary and more
---

# {% include icon.html icon="fa-solid fa-microscope" %}Publications

{%
  include button.html
  type="google-scholar"
  text="Full list on Google Scholar"
  link="A7RolPoAAAAJ"
%}

{% include search-box.html %}

{% include search-info.html %}

{% include section.html %}

## Recent papers

{% include list.html data="citations" component="citation" style="rich" hide_years=true filter="tags && tags.include?('recent')" %}

{% include section.html %}

## Commentary and framing

{% include list.html data="citations" component="citation" style="rich" hide_years=true filter="tags && tags.include?('commentary')" %}

{% include section.html %}

## Other contributions

{% include list.html data="citations" component="citation" style="rich" hide_years=true filter="tags && tags.include?('other')" %}
