---
---

<p class="center">
  <img
    class="lab-logo"
    src="{{ "/images/logo/lem-logo.png" | relative_url }}"
    alt="Laboratory of Environmental Microbiology logo: a globe ringed by CO₂ cycle arrows"
    width="280"
  >
</p>

## About the lab

We study & engineer the roles of microbes in the global carbon cycle.
Some projects in our group are motivated by engineering goals, aiming to build carbon negative technologies using autotrophic (CO₂-eating) microbes.
Other projects are motivated by problems that arise in climate models, which need to predict the collective respiration (CO₂ production) by microbial communities in order to estimate future warming.

Because we are focused on microbial metabolism in natural settings, we also pursue basic questions in microbiology, systems biology, and ecology.
If you have an interest in quantitative thinking, environmental systems, and/or microbial physiology and metabolism, [drop us a line]({{ "/join/" | relative_url }}).

<div class="photo-frame photo-frame-wide">
{%
  include figure.html
  image="images/home/lab-photo-bear-mountain.jpg"
  caption="Lab hike to Bear Mountain"
%}
</div>

{% include section.html %}

{% capture content %}

{%
  include figure.html
  image="images/gallery/millbrook-lab-trip.jpg"
  caption="Lab trip to Millbrook, NY"
%}

{%
  include figure.html
  image="images/gallery/central-valley-cyanobacteria-sampling.jpg"
  caption="Sampling for cyanobacteria in the Central Valley, CA"
%}

{%
  include figure.html
  image="images/gallery/field-center-sampling-2026-08.jpg"
  caption="Sampling at the Field Center, August 2026"
%}

{%
  include figure.html
  image="images/gallery/nylittle-2026-group-retreat.jpg"
  caption="Group retreat / NYLittle meeting 2026"
%}

{%
  include figure.html
  image="images/gallery/nylittle-2026-innisfree-garden.jpg"
  caption="NYLittle 2026 at Innisfree Garden"
%}

{% endcapture %}

{% include grid.html style="gallery" content=content %}

{% include section.html %}

## Explore

{% include button.html link="research/" text="Publications" icon="fa-solid fa-microscope" %}
{% include button.html link="projects/" text="Projects" icon="fa-solid fa-wrench" %}
{% include button.html link="team/" text="Team" icon="fa-solid fa-users" %}
{% include button.html link="resources/" text="Resources" icon="fa-solid fa-toolbox" %}
{% include button.html link="theory-lunch/" text="Theory Lunch" icon="fa-solid fa-chalkboard-user" %}
{% include button.html link="photos/" text="Lab photos" icon="fa-solid fa-camera" %}
{% include button.html link="join/" text="Join us" icon="fa-solid fa-user-plus" %}
{% include button.html link="news/" text="News" icon="fa-solid fa-newspaper" %}
{:.center}
