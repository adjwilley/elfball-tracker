#!/bin/bash
# Publish the OneDrive working copy to GitHub Pages.
set -euo pipefail
SRC="/Users/anthony/Library/CloudStorage/OneDrive-Personal/Dropbox/Magic the gathering/Elfball Tracker.html"
cd "$(dirname "$0")"
[ -f "$SRC" ] || { echo "source not found: $SRC" >&2; exit 1; }
cp "$SRC" index.html
python3 - <<'PY'
import io, re
h = io.open("index.html", encoding="utf-8").read()
if "manifest.webmanifest" not in h:
    h = h.replace('<meta name="theme-color" content="#0C1410">',
'''<meta name="theme-color" content="#0C1410">
<meta name="apple-mobile-web-app-title" content="Elfball">
<link rel="manifest" href="manifest.webmanifest">
<link rel="apple-touch-icon" href="icon-180.png">
<link rel="icon" type="image/png" sizes="192x192" href="icon-192.png">''', 1)
if "serviceWorker" not in h:
    h = h.replace("</body>", '''<script>
if ("serviceWorker" in navigator && location.protocol === "https:") {
  window.addEventListener("load", function () {
    navigator.serviceWorker.register("sw.js")["catch"](function () {});
  });
}
</script>

</body>''', 1)
io.open("index.html", "w", encoding="utf-8").write(h)
# bump the cache name or devices keep serving the old copy
sw = io.open("sw.js", encoding="utf-8").read()
n = int(re.search(r'elfball-v(\d+)', sw).group(1)) + 1
io.open("sw.js", "w", encoding="utf-8").write(re.sub(r'elfball-v\d+', 'elfball-v%d' % n, sw))
print("service worker cache -> elfball-v%d" % n)
PY
git add -A
git commit -m "${1:-update tracker}" -q || { echo "nothing to deploy"; exit 0; }
git push -q origin main
echo "deployed -> https://adjwilley.github.io/elfball-tracker/"
