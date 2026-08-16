# Elfball Board Tracker

Board tracker for Anthony's Eladamri, Korvecdal elfball Commander deck. Tracks mana,
creatures, Elf Warrior tokens (individually, with counters and tap state), nine tracked
permanents with automatic ETB triggers, per-turn statistics and a by-turn log.

Live: https://adjwilley.github.io/elfball-tracker/

Single self-contained `index.html` — all art and audio are embedded, so it works with no
network once cached. On iPad/iPhone, open the link in Safari and use **Share → Add to Home
Screen** for a full-screen app with offline support.

## Source of truth

The working copy lives in OneDrive:

    OneDrive-Personal/Dropbox/Magic the gathering/Elfball Tracker.html

This repo is a **deploy target**. Edit the OneDrive copy, then run `./deploy.sh` to publish.

## Deploying

    ./deploy.sh "what changed"

Copies the OneDrive file over `index.html`, re-applies the manifest/service-worker tags,
bumps the service-worker cache version so devices pick up the change, then commits and pushes.
