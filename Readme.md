# Firefox Sync Server

This is the backend server allowing you to sync your Firefox tabs, bookmarks,
etc between various computers (or your computer and your phone).

Note that this still relies on a Firefox Account Server.

[![GitHub issues](https://img.shields.io/github/issues-raw/minchinweb/docker-firefox-sync-server.svg?style=popout)](https://github.com/MinchinWeb/docker-firefox-sync-server/issues)
<!--
[![Docker Pulls](https://img.shields.io/docker/pulls/minchinweb/python.svg?style=popout)](https://hub.docker.com/r/minchinweb/python)
[![Size & Layers](https://images.microbadger.com/badges/image/minchinweb/python.svg)](https://microbadger.com/images/minchinweb/python)
![MicroBadger Layers](https://img.shields.io/microbadger/layers/layers/minchinweb/python.svg?style=plastic)
![MicroBadger Size](https://img.shields.io/microbadger/image-size/image-size/minchinweb/python.svg?style=plastic)
-->

## How to Use This

### Docker Setup

This container can be used directly. Here is a portion of my personal
`docker-compose.yaml` file:

    services:
        # many others...

        ffsync:
            build: ../../build/ffsync
            container_name: ffsync
            restart: "no"
            environment:
                - PUID=${PUID}
                - PGID=${PGID}
                - SYNCSERVER_PUBLIC_URL=http://ffsync.${LOCAL_DOMAIN_NAME}
                - SYNCSERVER_SECRET=Z6OCh20wR2jFnWuGkIvWsp3NAJ6Qc1lB
                - SYNCSERVER_SQLURI=sqlite:////data/syncserver.db
                - SYNCSERVER_BATCH_UPLOAD_ENABLED=true
                - SYNCSERVER_FORCE_WSGI_ENVIRON=false
                - PORT=${FFSYNC_PORT}  # default is 5000
            ports:
                - ${FFSYNC_PORT}:${FFSYNC_PORT}
            volumes:
                - ${DOCKER_USERDIR}/volumes/ffsync:/data

`PUID`, `GUID`, `DOCKER_USERDIR`, `LOCAL_DOMAIN_NAME`, and `FFSYNC_PORT` are
environmental variables used by service services in my local stack, and are
provided by a `.env` file located in the same directory as my
`docker-compose.yaml` file.

### Local Firefox Configuration

From the [official
documentation](https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html):

> To configure desktop Firefox to talk to your new Sync server, go to
> `about:config`, search for `identity.sync.tokenserver.uri` and change its
> value to be the public URL of your server with a path of
> `token/1.0/sync/1.5`:
> 
>   identity.sync.tokenserver.uri: http://localhost:5000/token/1.0/sync/1.5
> 
> [...] To configure Android Firefox 44 and later to talk to your new Sync
> server, just set the `identity.sync.tokenserver.uri` exactly as above
> **before signing in to Firefox Accounts and Sync on your Android device.**
> 
> **Important**: after creating the Android account, changes to
> `identity.sync.tokenserver.uri` will be ignored. (If you need to change the
> URI, delete the Android account using the *Settings > Sync > Disconnect...*
> menu item, update the pref[rence], and sign in again.) Non-default
> TokenServer URLs are displayed in the *Settings > Sync* panel in Firefox for
> Android, so you should be able to verify your URL there.



https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html

## Why I Created This

or, *What Problems is This Trying to Solve?*

A Firefox Sync server seemed like a simple and useful thing to run to try my
hand at self-hosting.

## Personal Additions and Notes

None, really, for now.

## Prior Art

This builds on [my personal base Python
image](https://github.com/MinchinWeb/docker-python), updated to run Python 2.7.

This is also based on Mozilla's official [Sync Server
code](https://github.com/mozilla-services/syncserver).

## Known Issues

- It seems to *work*, in the sense that I can log in on both my desktop and
  phone, but I can't get it to share tabs between the two; I don't know if
  that's a problem with Firefox Sync generally, the version of the Sync server
  I'm running, or something in my local configuration.
- The upstream program is based on Python 2.7, which has a planned end-of-life
  at the end of 2019. There is some talk about move to Python 3, but that
  remains a work in progress.
- If you're seriously concerned about the privacy aspects (and that's why
  you're running your own Sync server), you should probably run your own
  Firefox Account server as well.
