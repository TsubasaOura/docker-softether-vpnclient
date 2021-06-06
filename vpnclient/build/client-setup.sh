#!/bin/bash
vpncmd_client () {
    /usr/bin/vpncmd localhost /CLIENT /CSV /CMD "$@"
}

vpncmd_client RemoteEnable
