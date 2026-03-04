# Deploy Targets

## Apps/

This repo (`E101H/Apps/`) is the **primary source** for interactive apps.

| Target | Path |
|--------|------|
| ECON 101 | `/Users/sergiop/Dropbox/Teaching/101/Apps/` |

```bash
# Sync Apps to 101
cp -R Apps/* /Users/sergiop/Dropbox/Teaching/101/Apps/
```

## LECWeb/

This repo (`E101H/LECWeb/`) is a **deploy target** for GitHub Pages. The primary working copy is `Projects/LECWeb/101/`.

See **[Projects/LECWeb/SYNC-POLICY.md](../LECWeb/SYNC-POLICY.md)** for complete LECWeb sync workflows.

| Location | Purpose |
|----------|---------|
| Working Copy | `Projects/LECWeb/101/` |
| GitHub Pages | `Projects/E101H/LECWeb/` (this repo) |
| Dropbox Local | `~/Dropbox/Teaching/101/LECWeb/` |

## Notes

- Apps: Edit here, then copy to Teaching/101/Apps/
- LECWeb: Edit in Projects/LECWeb/101/, then copy here and to Teaching/101/LECWeb/
- Test files (*.test.html) are not deployed
- GitHub Pages: https://sergio0p.github.io/E101H/
