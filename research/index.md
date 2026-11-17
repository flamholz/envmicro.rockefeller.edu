---
title: Research
nav:
  order: 1
  tooltip: Publications by topic
---

# {% include icon.html icon="fa-solid fa-microscope" %}Research

Recent papers by broad topic.
See [Google Scholar](https://scholar.google.com/citations?user=A7RolPoAAAAJ&hl=en) for a complete list.

{%
  include button.html
  type="google-scholar"
  text="Full list on Google Scholar"
  link="A7RolPoAAAAJ"
%}

{% include search-box.html %}

{% include search-info.html %}

{% include section.html %}

## Microbial metabolism, physiology & communities

{% include list.html data="citations" component="citation" filter="tags && tags.include?('metabolism')" %}

{% include section.html %}

## Microbial CO₂ fixation & rubisco

{% include list.html data="citations" component="citation" filter="tags && tags.include?('co2-fixation')" %}

{% include section.html %}

## Environmental analysis

{% include list.html data="citations" component="citation" filter="tags && tags.include?('environment')" %}
