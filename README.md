# envmicro.rockefeller.edu

Website of the **Laboratory of Environmental Microbiology** (Flamholz Lab) at The Rockefeller University.
Built with the Greene Lab [Lab Website Template](https://github.com/greenelab/lab-website-template) v1.4.1 (Jekyll) and served as static files from Apache at <https://envmicro.rockefeller.edu> (RU self-host server; see Deployment in MIGRATION_NOTES.md).

## Build

Requirements: Ruby ≥ 3.1 (3.4 recommended; on macOS `brew install ruby@3.4`) and Python ≥ 3.10 (for the citation step).

```bash
scripts/build.sh            # gems + venv + citations + production build -> _site/
scripts/check-links.sh      # html-proofer on _site/ (internal links)
python3 -m http.server -d _site 4000   # preview at http://localhost:4000
scripts/deploy.sh           # build + preview what would change on the web server
scripts/deploy.sh --go      # build + upload to the web server (SSH key required)
```

`SKIP_CITE=1 scripts/build.sh` builds offline from the committed `_data/citations.yaml`.

For live-reloading while editing: `bundle exec jekyll serve` (after one `scripts/build.sh`, with the same Ruby on your PATH).

Every push runs `.github/workflows/build.yaml`, which builds the site and uploads `_site/` as a downloadable artifact (no deployment).

## Editing

See [MIGRATION_NOTES.md](MIGRATION_NOTES.md) for how to add members, papers and news posts, the open placeholders, and deployment notes.
Template documentation: <https://greene-lab.gitbook.io/lab-website-template-docs>.

## License

Site content © the Flamholz Lab ([LICENSE](LICENSE)).
The Lab Website Template is © Greene Laboratory under the BSD 3-Clause License ([LICENSE.md](LICENSE.md)).
