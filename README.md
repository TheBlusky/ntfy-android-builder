# Automagic script for building ntfy

⚠️ *This project is not officially provided by ntfy team and comes with no warranty. It is provided
as-is and comes with no guaranteed support either by me or by ntfy.*

The purpose of this repository is to simplify the process of creating your own android package
of [binwiederhier/ntfy-android](https://github.com/binwiederhier/ntfy-android/).

The main goal of creating your own package is to configure it with your Firebase account, so
you can enable FCM notification on [ntfy](https://github.com/binwiederhier/ntfy/) application,
and use the Google Service for fetching messages instead of having a background task that perform
permanent polling.

## Requirement

- Docker (tested on Windows, but should work on MacOS and Linux) ;
- A Firebase account, with the corresponding `google-services.json` ;
- A self-hosted ntfy instance, configured with corresponding `firebase-key-file`
([Firebase documentation for ntfy](https://docs.ntfy.sh/config/#firebase-fcm)).

## Usage 

- `git clone https://github.com/TheBlusky/ntfy-android-builder`;
- `cd ntfy-android-builder`;
- Add `google-services.json` in `./volumes/firebase/`;
- Copy `.env-dist` to `.env`;
- Edit `.env` with your `NTFY_APP_BASE_URL`;
- `docker compose run --rm -it android`;
- Install `builds/my-app-release.apk` on your android device.

(Do not install `app-play-release-unsigned.apk` as it is not signed and, therefor, might be
installed correctly)

## What this project actually do

Everything runs inside a container, so you don't have to install SDK and care about dependencies,
generating a certificate, signing an APK. The following is performed :

- Pulling compatible Android SDK;
- Generating a signing certificate;
- Pulling ntfy-android (main, tag or branch) ;
- Customizing code base with Firebase credential and base API URL;
- Compiling android project.
