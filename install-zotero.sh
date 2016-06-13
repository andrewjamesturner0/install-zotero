#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    cat << EOF
usage: install-zotero.sh [version number]
:: Check https://www.zotero.org/download for the latest verison number.
EOF
    exit 1
fi

pkgver="$1"
arch='x86_64'
pkgdir='pkg'
srcdir="Zotero_linux-${arch}"
source="http://download.zotero.org/standalone/${pkgver}/Zotero-${pkgver}_linux-${arch}.tar.bz2"

wget -qO - "${source}" | tar -xj
mkdir -p "$pkgdir"/usr/{bin,lib/zotero}
mv "$srcdir"/* "$pkgdir/usr/lib/zotero"
ln -s /usr/lib/zotero/run-zotero.sh "$pkgdir/usr/bin/zotero"
sed -i -e 's|MOZ_PROGRAM=""|MOZ_PROGRAM="/usr/lib/zotero/zotero"|g' "$pkgdir/usr/lib/zotero/run-zotero.sh"
install -Dm644 zotero.desktop "$pkgdir/usr/share/applications/zotero.desktop"
install -Dm644 "$pkgdir/usr/lib/zotero/chrome/icons/default/default16.png" "$pkgdir/usr/share/icons/hicolor/16x16/apps/zotero.png"
install -Dm644 "$pkgdir/usr/lib/zotero/chrome/icons/default/default32.png" "$pkgdir/usr/share/icons/hicolor/32x32/apps/zotero.png"
install -Dm644 "$pkgdir/usr/lib/zotero/chrome/icons/default/default48.png" "$pkgdir/usr/share/icons/hicolor/48x48/apps/zotero.png"

tar --create -f "zotero_v${pkgver}.pkg.tar" -C pkg .
rm -rf "${pkgdir}" "${srcdir}"
sudo tar -xf "zotero_v${pkgver}.pkg.tar" -C /
