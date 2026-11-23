---
title: Team
nav:
  order: 1
  tooltip: People in the lab
---

# {% include icon.html icon="fa-solid fa-users" %}Team

Interested in joining us? See [Contact]({{ "/contact/" | relative_url }}).

{% include section.html %}

{% include list.html data="members" component="portrait" filter="role == 'principal-investigator' && group != 'alum'" %}

{% include list.html data="members" component="portrait" filter="role == 'postdoc' && group != 'alum'" %}
{% include list.html data="members" component="portrait" filter="role == 'phd' && group != 'alum'" %}
{% include list.html data="members" component="portrait" filter="role == 'staff' && group != 'alum'" %}
{% include list.html data="members" component="portrait" filter="role == 'volunteer' && group != 'alum'" %}

{% include section.html %}

## Friends of the lab

{% include list.html data="members" component="portrait" filter="role == 'friend' && group != 'alum'" %}

{% include section.html %}

## Collaborators

- [Akshit Goyal](https://www.icts.res.in/people/akshit-goyal), TATA Bangalore
- [Josh Goldford](https://www.dayhofflabs.com/), Dayhoff Labs
- [Karna Gowda](https://microbiology.osu.edu/people/gowda.51), Ohio State
- [Sarah Kostinski](https://skostinski.github.io/), NYU
- [Yinon Bar-On](https://scholar.google.co.il/citations?user=3iE59GcAAAAJ&hl=en), WIS

{% include section.html %}

## Alumni

{% include list.html data="members" component="portrait" filter="group == 'alum'" %}
