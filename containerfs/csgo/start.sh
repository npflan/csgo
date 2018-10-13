#!/bin/bash

export GAMESERVER_TOKEN=$(curl --silent "$TOKEN_API_URL/token/740/$HOSTNAME")
export RCON_PASSWORD="$(< /dev/urandom tr -dc A-Za-z0-9 | head -c32; echo)"

export SERVER_HOSTNAME="${SERVER_HOSTNAME:-}"
export RCON_PASSWORD="${RCON_PASSWORD:-changeme}"
export STEAM_ACCOUNT="${GAMESERVER_TOKEN:-changeme}"
export CSGO_DIR="${CSGO_DIR:-/csgo}"
export IP="${IP:-0.0.0.0}"
export PORT="${PORT:-27015}"
export TICKRATE="${TICKRATE:-128}"
export GAME_TYPE="${GAME_TYPE:-0}"
export GAME_MODE="${GAME_MODE:-1}"
export MAP="${MAP:-de_dust2}"
export MAPGROUP="${MAPGROUP:-mg_active}"
export MAXPLAYERS="${MAXPLAYERS:-12}"

: ${CSGO_DIR:?"ERROR: CSGO_DIR IS NOT SET!"}

cd $CSGO_DIR

### Create dynamic server config
cat << SERVERCFG > $CSGO_DIR/csgo/cfg/server.cfg
hostname "$SERVER_HOSTNAME"
rcon_password "$RCON_PASSWORD"
sv_lan 1
sv_cheats 0
SERVERCFG

./srcds_run \
    -console \
    -usercon \
    -game csgo \
    -tickrate $TICKRATE \
    -port $PORT \
    -maxplayers_override $MAXPLAYERS \
    +game_type $GAME_TYPE \
    +game_mode $GAME_MODE \
    +mapgroup $MAPGROUP \
    +map $MAP \
    +ip $IP \
    +sv_setsteamaccount $STEAM_ACCOUNT
