# Migration notes

Migration of the lab pages on rockefeller.edu (Home, People, Projects, Publications, Resources, Lab Photos) to a Lab Website Template (LWT) v1.4.1 site, served as static files from Apache at https://envmicro.rockefeller.edu.
Content was pulled from the old pages on 2026-11-17.

## Where things went

| Old page / content | New location |
|---|---|
| Home: "About the lab", research-area tags, photo carousel | `index.md` (`/`): intro, captioned 6-photo gallery, buttons to every section. The RU research-area tags were dropped (imposed by the RU page design, not lab content) |
| People: PI + 5 members | `_members/*.md`, shown on `team/index.md` (`/team/`); each person also gets a page at `/members/<name>/` |
| People: Collaborators and Friends | "Collaborators and friends" list on `/team/` (text only, no member pages) |
| People: Alums | `_members/*.md` with `group: alum`, shown in the "Alumni" section of `/team/` |
| Publications (22 papers, 3 sections) | DOIs in `_data/sources.yaml` → `_data/citations.yaml` (generated) → three filtered lists (recent papers, commentary, other contributions) on `publications/index.md` (`/publications/`) |
| Projects (5 items) | One heading per project in `projects/index.md` (`/projects/`), using the old page's one-line descriptions as headings, each followed by its example papers and a `TODO` comment where a paragraph can go. (An earlier version used LWT's image cards from `_data/projects.yaml`; replaced at your request on 2026-11-17 with this text-first layout.) |
| Resources | `resources/index.md` (`/resources/`): tool cards (`_data/tools.yaml`), seminars list, video embeds |
| Lab Photos (+ "Building the Lab" sub-gallery) | `photos/index.md` (`/photos/`) |
| Lab opportunities (home page) | `contact/index.md` (`/contact/`; was `/join/` until 2026-11-17, which now redirects) |
| Contact block | Footer on every page: lab name and postal address only (`contact:` in `_config.yaml`). The phone number and email are deliberately not published, except the email on `/contact/`, written as "aflamholz at rockefeller dot edu" (no mailto link) to discourage scraping |
| Tri-I Theory Lunch (was flamholz.github.io/theory-lunch/, added 2026-11-17) | `theory-lunch/index.md` (`/theory-lunch/`), top-level nav link and a button on the home page. Photo reuses `images/photos/tri-i-theory-lunch.jpg` (same image as the Google Photos hotlink). "Write to me" links to the Contact page. The old GitHub Pages copy should redirect here (e.g. `redirect_to: https://envmicro.rockefeller.edu/theory-lunch/` with jekyll-redirect-from in that repo) |
| News item (Nov 21, 2024) | `_posts/2024-11-21-new-faculty-member.md`, listed at `/news/` |
| (new) News items | Welcome posts for James (Feb 1, 2025), Sophia (May 15, 2025), Eden (Sep 15, 2025), Julie (Feb 17, 2026, which also announces her Women & Science Postdoctoral Fellowship, awarded Nov 2025) and Javi (Nov 16, 2026). Text is drawn from the Team bios |

Top nav: Team · Projects · Resources · Publications · Photos · News · Theory Lunch · Contact (order set by `nav.order` in each page's front matter; the home page had matching Explore buttons until 2026-11-18, now removed). The Publications page lives at `/publications/` (it was titled "Research" at `/research/` until 2026-11-17/18; `/research/` now redirects).

## Decisions and deviations from the brief

- **`_config.yaml`, not `_config.yml`.** The template uses the `.yaml` name, and its scripts and Docker setup expect it.
- **Pages are folders** (`photos/index.md`, not `photos.md`). The LWT header builds nav links from each page's directory, so a top-level `photos.md` would link to `/`.
- **Role keys.** The template's PI role is `principal-investigator`, not `pi`. I added `staff` (label "Research Associate") and `volunteer` to `_data/types.yaml`, and relabeled `postdoc` → "Postdoctoral Fellow" and `phd` → "Graduate Student" to match the old site. Pippa uses `programmer` (shown as her fellowship title); the SURF students use `undergrad`.
- **Alumni** are member files with `group: alum`, which is LWT's convention. They get a member page with a neutral placeholder portrait (`images/people/placeholder.svg`). The past program is shown as `description` and the current position as `affiliation`.
- **Photos is its own page.** The old Lab Photos page and the home carousel share only one photo (the 2026 Innisfree Garden shot), so they were not merged. The "Building the Lab" sub-gallery (12 captioned photos) was migrated into `/photos/` rather than linking to the old rockefeller.edu page. The album covers link to the Google Photos albums, as before.
- **Videos.** LWT has no embed component. Its `jekyll-spaceship` plugin can turn a Markdown image of a YouTube URL into an iframe, but it uses `youtube.com` (not the privacy-enhanced `youtube-nocookie.com` the old site used) and a fixed height. I added a small responsive include, `_includes/embed.html` (styles in `_styles/embed.scss`). Usage: `{% include embed.html youtube="VIDEO_ID" title="…" %}`.
- **Section filtering.** Each source has `tags: [recent | commentary | other]` (recent papers, commentary and framing, other contributions), and the Publications page (`publications/index.md`) filters with `filter="tags && tags.include?('…')"`, newest first, without year subheadings (`hide_years=true`).
- **Citation links** are the shortDOI URLs that Manubot generates (e.g. `https://doi.org/hcsrjj`), which redirect to the full DOI. During the cite step Manubot prints a `403` warning for a PubMed Central ID lookup; it is harmless, because the citations come from DOI metadata.
- **Template pieces removed.** The demo members, posts and projects; `testbed.md`; the demo `contact/` page (its content now lives in the footer and on `/contact/`); the template's ORCID source (`_data/orcid.yaml`, which belonged to someone else); the committed citation cache; `CITATION.cff` and `CHANGELOG.md`; the issue and discussion templates; and **all of the template's GitHub workflows**. Those workflows deploy to GitHub Pages, or exist only to auto-commit `citations.yaml` around that deploy. The new `build.yaml` runs the citation step as part of every build instead.
- **Small template fixes.** Post tag links pointed at `/blog`, so they now point at `/news/`. The member page's "posts" link was updated the same way. I added a `gallery` grid style (`_styles/gallery.scss`) and footer contact styles.
- **Styling.** The default theme, with only the color variables in `_styles/-theme.scss` changed to navy (`#1f4e8c` light, `#8fb3e3` on dark). Header and footer use a close-up of a cyanobacterial bloom (`images/header/cyanobacteria-bloom.jpg`, set by `header:`/`footer:` in `_config.yaml`), deliberately a landscape rather than a photo of people.
- **Logo** (added 2026-11-17). The source SVGs are in `images/logo/`. The header uses a white version (`lem-logo-reverse.svg`, with the dark green #0E4D3C swapped for white) because the header photo is dark. `images/logo.png` is that version rendered to PNG, and the template's built-in logo slot shows it large in the home-page header, where the text title is hidden because the logo spells out the name. Other pages use the compact globe mark `images/logo/lem-mark-reverse.png` next to the title text (set in `_includes/header.html`). There is deliberately no `images/logo.svg`: the template would paste its ~220 KB contents into every page. `images/logo/lem-logo.png` is a transparent PNG of the original dark-green logo, for light backgrounds.
- **Images** were downloaded at full resolution, resized (max 1600 px for photos, 800 px for headshots, never upscaled), re-encoded as JPEG (Julie's PNG kept), and stripped of EXIF/GPS metadata. Total: about 7 MB.
- **Copy edits.** Two typo fixes from the old site ("applications **from** current PhD students", "we **host**") and light capitalization in photo captions. Everything else is verbatim.

## Please review / couldn't fully migrate

1. **2026 NYLittle album link.** On the old Photos page, that item's image linked to `photos.app.goo.gl/ToQLJfMvV656hQDCA`, but its caption linked to the 2025 album (`q6MQtLGuiqjW6cTu9`), which looked like a copy-paste slip. I used `ToQL…` for both. ✅ Confirmed correct (2026-11-17).
2. **"Join our staff → More info"** linked to the rockefeller.edu homepage. ✅ Removed at your request (2026-11-17).
3. **Ed Reznik link.** `reznik-lab.webflow.io` returns 404, so I replaced it with https://www.mskcc.org/research-areas/labs/ed-reznik.
4. **Project 5** ("Environmental analysis of human choices…") had no example paper on the old page. I linked the two Environmental-analysis papers from the publications list (Eshel et al. PNAS 2025; Lovat et al. Nat. Biotechnol. 2025).
5. **Project titles.** ✅ No longer applicable: the Projects page is back to the old page's one-line descriptions, with no separate titles.
6. **Avi's bio.** The old People page had no bio for Avi. `_members/avi-flamholz.md` is written from the facts on his official RU profile (education, positions, awards, programs). Please edit.
7. **Social links.** Google Scholar (`A7RolPoAAAAJ`) comes from the old site. The ORCID (`0000-0002-9278-5479`) is ✅ confirmed (2026-11-17). GitHub points to the lab organization, https://github.com/Flamholz-Lab, in the footer and on Avi's member page (✅ 2026-11-17). I did not add a YouTube channel, Bluesky or LinkedIn.
8. **Collaborator affiliations** are verbatim from the old site (e.g. "TATA Bangalore", "WIS").
9. **Not migrated (RU-wide, not lab content):** the RU research-area tags, the RU sidebar's "Upcoming Events" and RU-wide news teasers, the RU global nav/footer, and the newsletter signup.
10. **Member order.** Within the same role, members sort alphabetically by file name, so Eden appears before Sophia (the reverse of the old page).
11. **External dependencies** (from the template, loaded by visitors' browsers): Google Fonts, Font Awesome (use.fontawesome.com), unpkg (popper, tippy, mark.js) and jsDelivr. If RU web policy requires self-hosting or a Content-Security-Policy, these need attention.

## Placeholders to fill in

- [ ] **Alumni photos** (optional). All four use `images/people/placeholder.svg`.
- [ ] **Julie's headshot** is only 297×344 px on the old site. A higher-resolution photo would look better.
- [ ] **Favicon** `images/icon.png` is a generated "EM" placeholder. The social share image `images/share.jpg` is cropped from the 2026 group retreat photo.
- [x] **Tool cards** use each site's own logo, centered on a white 3:2 tile (`images/resources/*.png`). The BioNumbers and eQuilibrator logos come from those sites. The Classic Reactions tile reuses the eQuilibrator mark, which that page uses as its logo, with the name added. The Human Impacts Database has no logo, so its tile is text ("HuIDs", as in its navbar).
- [ ] Bios for current members are as on the old site. Links (email, ORCID, GitHub, website) can be added under `links:` in each member file.

## How to…

### Add a new member

Create `_members/firstname-lastname.md`:

```yaml
---
name: Firstname Lastname
image: images/people/firstname-lastname.jpg   # put a ~800px photo here
role: phd          # principal-investigator | postdoc | phd | staff | volunteer | undergrad | programmer
links:             # optional; keys are defined in _data/types.yaml
  email: someone@rockefeller.edu
  orcid: 0000-0000-0000-0000
  github: username
---

One- or two-sentence bio.
```

The Team page shows members by role, in the order postdoc → phd → staff → volunteer. A new role needs an entry in `_data/types.yaml` and a matching line in `team/index.md`.
When someone leaves, add `group: alum`, a `description:` (their role and years in the lab), and an `affiliation:` ("Now: …").

### Add a paper (by DOI)

1. Add an entry to `_data/sources.yaml`, using the topic tag for the Publications-page section it belongs in:
   ```yaml
   - id: doi:10.1234/abcd.5678
     tags: [metabolism]   # metabolism | co2-fixation | environment
   ```
2. Run `scripts/build.sh`. It regenerates `_data/citations.yaml` (title, authors, journal, date) with Manubot.
3. Commit both `sources.yaml` and `citations.yaml`.

Optional fields that override or extend the generated citation: `title`, `date`, `link`, `image`, `description`, `buttons`.
For a new section, add a heading and `list.html` call to `publications/index.md` with a new tag.

To give a paper a write-up page, add `_papers/<author-year-topic>.md` with front matter `title:` (the paper title), `doi:` (exactly as in `sources.yaml`, without `doi:`), `description:` (one- or two-sentence teaser shown on the Publications list) and optionally `image:` / `image_alt:` / `image_credit:` (a figure shown on the page, e.g. from `images/publications/writeups/`). The Markdown body is the write-up. The page is published at `/publications/<file name>/`, uses `_layouts/paper.html` (citation details come from `_data/citations.yaml` by DOI), and the paper's title and thumbnail on the Publications list link to it.

### Add a news post

Create `_posts/YYYY-MM-DD-short-title.md`:

```markdown
---
title: Headline
tags: news                             # e.g. news, team, award
image: images/people/someone.jpg       # optional: thumbnail on the News list
banner: images/photos/something.jpg    # optional: faded banner behind the title
---

Text of the post. Link out with a normal Markdown link or a button:
{% include button.html link="https://…" text="Read more" icon="fa-solid fa-arrow-right" flip=true %}
```

It appears at `/news/` and gets its own page at `/news/YYYY/MM/DD/short-title/`. Posts show only the date in the file name; the template's "last updated" stamp (from git history) was removed, since backdated posts would all show the day they were committed. In the template, `image` is also the banner on the post page; here the banner is a separate, opt-in `banner` key, so welcome posts don't put a headshot behind the title.

### Add photos

Put resized images in `images/photos/`, then add a `{% include figure.html image="…" caption="…" link="…" %}` block inside the relevant `{% capture content %}` in `photos/index.md`. The caption doubles as alt text.

## Build

```bash
scripts/build.sh          # Ruby gems (vendor/bundle), Python venv (.venv), citations, production build -> _site/
scripts/check-links.sh    # html-proofer, internal links (add --external for external links)
```

- Ruby is pinned by `.ruby-version` (3.4) and `Gemfile.lock` (bundler 2.5.6). Python packages are pinned in `requirements.txt`, while `_cite/requirements.txt` keeps the template's looser ranges.
- On macOS the system Ruby (2.6) is too old: `brew install ruby@3.4`. The build script finds it automatically. The citation step needs Python ≥ 3.10 (the macOS system `python3` is 3.9); the script uses the first suitable `python3` on your PATH, or set `PYTHON=`.
- `SKIP_CITE=1 scripts/build.sh` builds without network access from the committed `citations.yaml`.
- CI: `.github/workflows/build.yaml` runs on every push and PR. It runs `build.sh` and `check-links.sh`, then uploads `_site/` (including `.htaccess`) as the artifact `site-main` (on main) or `site-<sha>`. Download it from the run's summary page.
- The output uses root-relative URLs (`baseurl: ""`) and contains no server-side code, so it works when copied into the root of the docroot. Absolute URLs (feed, sitemap, social meta tags) use `url: https://envmicro.rockefeller.edu`.

### `.htaccess`

`.htaccess` in the repo root is copied into `_site/`. It sets `ErrorDocument 404 /404.html`, turns off directory listings, sets cache headers (images 30 days, CSS/JS 1 day since filenames aren't fingerprinted, HTML always revalidated), and enables gzip when the modules exist.

**It only takes effect if Apache allows overrides for the docroot.** The directives need at least `AllowOverride FileInfo Indexes Options` (or `All`).
With `AllowOverride None` the file is silently ignored.
If overrides are partly allowed but `Options` is not, Apache returns **500 errors** for the whole site.
If IT prefers, the same directives can go in the `<VirtualHost>` / `<Directory>` block instead, and `.htaccess` can be removed from `_config.yaml`'s `include:` list.
The cache and compression rules are wrapped in `<IfModule>`, so missing `mod_expires`, `mod_headers` or `mod_deflate` won't break anything.

## Deployment

The site is hosted on RU's self-host web server (set up by RU IT, 2026-11-17):

- **Host:** `ruselfhost-2023.rockefeller.edu`, login `flamholz_curator` (LDAP curator account; SSH/SFTP with **SSH keys only**, no password login).
- **Docroot:** `/WWW/sites/envmicro.rockefeller.edu/htdocs/`

`scripts/deploy.sh` builds the site and mirrors `_site/` into the docroot with rsync over SSH:

```bash
scripts/deploy.sh          # build, then preview the changes (dry run; nothing uploaded)
scripts/deploy.sh --go     # build, then upload
```

Mirroring deletes server files that are no longer in `_site/`, except `.well-known/` and `cgi-bin/`, and stops if a run would delete more than 200 files (`MAX_DELETE`). Files are uploaded world-readable (dirs 755, files 644). It needs rsync on the server; if IT doesn't provide it, upload `_site/` (including the hidden `.htaccess`) with an SFTP client instead. Before the first `--go`, run the preview and check the `*deleting` lines, in case IT left files in the docroot that should stay.

### Server setup (checked 2026-11-19)

- SSH key login works; the docroot is owned by `flamholz_curator` and writable, and rsync is installed (`/usr/bin/rsync`).
- Apache 2.4 (RHEL). The site's vhost is `/etc/httpd/sites.d/envmicro.conf` with `AllowOverride All` on the docroot, so `.htaccess` works.
- HTTPS: Let's Encrypt certificate (certbot, webroot mode on the docroot, hence `.well-known/` is protected from deletion). HSTS is on.

### Still to confirm with IT

1. **HTTP redirect points to the wrong domain.** The port-80 vhost has `Redirect / https://envmicro.org/`; it should be `https://envmicro.rockefeller.edu/`. Ask IT to fix it.
2. Any Content-Security-Policy, analytics or accessibility requirements, and is loading fonts and scripts from external CDNs allowed?

### Automation options (later)


**A. rsync from your machine (current setup: `scripts/deploy.sh`).**
One command, full control, nothing needed on the server. The downside is that deploys depend on your laptop and environment.

**B. GitHub Action deploying over SSH on push to `main`.**
Add a deploy job after `build` in `.github/workflows/build.yaml` that rsyncs `_site/` over SSH. Store an SSH deploy key for a restricted account as a repository secret, and pin the server's host key.
Merging to main updates the site automatically, with no local toolchain needed. This needs IT to allow inbound SSH from GitHub's runner IP ranges (or a self-hosted runner inside RU) and a key with write access to the docroot.

**C. Server pulls a built artifact (if IT allows outbound HTTPS but not inbound SSH).**
A cron job on the server downloads the latest `site-main` artifact (or a GitHub Release asset) with a read-only token, unpacks it to a staging directory and swaps it in (`rsync --delete` or a symlink flip).
No credentials for the server live in GitHub, but someone has to maintain the cron/script on the server, plus a token with `actions:read` scope.

If IT uploads files for us, the artifact from any CI run (`site-main.zip`) is the deliverable: unzip it into the docroot as is.
