#!/bin/bash
NTFY_ESCAPED_REPLACE=$(printf '%s\n' "$NTFY_APP_BASE_URL" | sed -e 's/[\/&]/\\&/g')
if test -f "/volumes/keystore/keystore.jks"; then
  echo "Keystore already exists"
else
  keytool -genkey -v -dname "CN=ntfy, OU=ntfy, O=ntfy, L=ntfy, ST=ntfy, C=nt" -keystore /volumes/keystore/keystore.jks -alias ntfy -keyalg RSA -keysize 2048 -validity 10000 -storepass "RANDOM"
fi
git clone https://github.com/binwiederhier/ntfy-android/ &&
cd ntfy-android &&
git checkout $NTFY_TAG &&
cp /volumes/firebase/google-services.json app/google-services.json &&
sed -i "s/>https:\\/\\/ntfy.sh</>$NTFY_ESCAPED_REPLACE</" app/src/main/res/values/values.xml &&
./gradlew assemblePlayRelease &&
cp app/build/outputs/apk/play/release/app-play-release-unsigned.apk /volumes/builds &&
cd /volumes/builds &&
/home/circleci/android-sdk/build-tools/30.0.3/apksigner sign --out my-app-release.apk --ks /volumes/keystore/keystore.jks --ks-pass "pass:RANDOM" --ks-key-alias ntfy app-play-release-unsigned.apk
