#!/bin/bash

if [ $(uname -s) = Darwin ]; then
    basedir=$(dirname $(cd "$(dirname "$0")"; pwd -P))
else
    basedir=$(dirname $(dirname $(readlink -fm $0)))
fi

source "$basedir/bin/java-config.sh"

VERSION=$(head -n 1 "$basedir/org.getmonero.i2p.zero/src/org/getmonero/i2p/zero/VERSION")

rm -fr "$basedir/dist-zip-staging"
mkdir -p "$basedir/dist-zip-staging"

rm -fr "$basedir/dist-zip"
mkdir -p "$basedir/dist-zip"

cd "$basedir/dist"

for i in linux linux-gui mac mac-gui win win-gui; do cp -r ${i} "$basedir"/dist-zip-staging/i2p-zero-${i}.v${VERSION}; done

versionDate=`date -r "$basedir"/org.getmonero.i2p.zero/src/org/getmonero/i2p/zero/VERSION +"%Y%m%d%H%M.%S"`

find "$basedir"/dist-zip-staging -exec touch -t $versionDate {} \;

cd "$basedir/dist-zip-staging"

for i in linux linux-gui mac mac-gui win win-gui; do
  zip -r9 "$basedir"/dist-zip/i2p-zero-${i}.v${VERSION}.zip i2p-zero-${i}.v${VERSION}
  normalizeZip "$basedir"/dist-zip/i2p-zero-${i}.v${VERSION}.zip
done

cd ..


print4ColsJustified () {
  printf "%-.12s %s" "$1                                " "| "
  printf "%-.23s %s" "$2                                " "| "
  printf "%-.21s %s" "$3                                " "| "
  printf "%s\n" "$4"
}
getFileSizeMB () {
  s=`du -sk $1 | awk '{printf "%.1f",$1/1024,$2}'`
  echo $s
}

print4ColsJustified "OS" "Uncompressed size (MB)" "Compressed size (MB)" "v$VERSION Reproducible build SHA-256"
print4ColsJustified "------------------------" "------------------------" "------------------------" "------------------------------------------------------------------"
print4ColsJustified "Mac"         "`getFileSizeMB $basedir/dist/mac`"       "`getFileSizeMB $basedir/dist-zip/i2p-zero-mac.v${VERSION}.zip`"       "\``getHash $basedir/dist-zip/i2p-zero-mac.v${VERSION}.zip`\`"
print4ColsJustified "Windows"     "`getFileSizeMB $basedir/dist/win`"       "`getFileSizeMB $basedir/dist-zip/i2p-zero-win.v${VERSION}.zip`"       "\``getHash $basedir/dist-zip/i2p-zero-win.v${VERSION}.zip`\`"
print4ColsJustified "Linux"       "`getFileSizeMB $basedir/dist/linux`"     "`getFileSizeMB $basedir/dist-zip/i2p-zero-linux.v${VERSION}.zip`"     "\``getHash $basedir/dist-zip/i2p-zero-linux.v${VERSION}.zip`\`"
print4ColsJustified "Mac GUI"     "`getFileSizeMB $basedir/dist/mac-gui`"   "`getFileSizeMB $basedir/dist-zip/i2p-zero-mac-gui.v${VERSION}.zip`"   "\``getHash $basedir/dist-zip/i2p-zero-mac-gui.v${VERSION}.zip`\`"
print4ColsJustified "Windows GUI" "`getFileSizeMB $basedir/dist/win-gui`"   "`getFileSizeMB $basedir/dist-zip/i2p-zero-win-gui.v${VERSION}.zip`"   "\``getHash $basedir/dist-zip/i2p-zero-win-gui.v${VERSION}.zip`\`"
print4ColsJustified "Linux GUI"   "`getFileSizeMB $basedir/dist/linux-gui`" "`getFileSizeMB $basedir/dist-zip/i2p-zero-linux-gui.v${VERSION}.zip`" "\``getHash $basedir/dist-zip/i2p-zero-linux-gui.v${VERSION}.zip`\`"

echo ""
echo "Note: Reproducible builds are currently experimental. Due to JDK differences, Builds on Mac will consistently have different hashes than builds on Linux. Official releases will always be built using Docker."