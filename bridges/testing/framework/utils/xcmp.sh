#!/usr/bin/env bash

source ./bridges.sh

ensure_polkadot_js_api

open_hrmp_channels "ws://127.0.0.1:9000" "//Alice" 2001 2000 8 10000
open_hrmp_channels "ws://127.0.0.1:9000" "//Alice" 2002 2000 8 10000
open_hrmp_channels "ws://127.0.0.1:9000" "//Alice" 2003 2000 8 10000
#open_hrmp_channels "ws://127.0.0.1:9000" "//Alice" 2004 2000 8 10000
#open_hrmp_channels "ws://127.0.0.1:9000" "//Alice" 2005 2000 8 10000



for i in $(seq 1 3);
do
  seed="//Alice"
  case $(($i%6)) in
  0)
    seed="//Alice";;
  1)
    seed="//Bob";;
  2)
    seed="//Charlie";;
  3)
    seed="//Dave";;
  4)
    seed="//Eve";;
  5)
    seed="//Ferdie";;
  esac
  echo "Seed: $seed"

  call_polkadot_js_api \
      --noWait \
      --ws "ws://127.0.0.1:10001" \
      --seed "$seed" \
      tx.polkadotXcm.send \
          "$(jq --null-input '{ "V5": { "parents": 1, "interior": { "X1": [ { "Parachain": 2000 } ] } } }')" \
          "$(jq --null-input '{ "V5": [ {"trap": '$i'} ] }')"

  call_polkadot_js_api \
      --noWait \
      --ws "ws://127.0.0.1:10002" \
      --seed "$seed" \
      tx.polkadotXcm.send \
          "$(jq --null-input '{ "V5": { "parents": 1, "interior": { "X1": [ { "Parachain": 2000 } ] } } }')" \
          "$(jq --null-input '{ "V5": [ {"trap": '$i'} ] }')"

    call_polkadot_js_api \
        --noWait \
        --ws "ws://127.0.0.1:10003" \
        --seed "$seed" \
        tx.polkadotXcm.send \
            "$(jq --null-input '{ "V5": { "parents": 1, "interior": { "X1": [ { "Parachain": 2000 } ] } } }')" \
            "$(jq --null-input '{ "V5": [ {"trap": '$i'} ] }')"

#    call_polkadot_js_api \
#        --noWait \
#        --ws "ws://127.0.0.1:10004" \
#        --seed "$seed" \
#        tx.polkadotXcm.send \
#            "$(jq --null-input '{ "V5": { "parents": 1, "interior": { "X1": [ { "Parachain": 2000 } ] } } }')" \
#            "$(jq --null-input '{ "V5": [ {"trap": '$i'} ] }')"

#    call_polkadot_js_api \
#        --noWait \
#        --ws "ws://127.0.0.1:10005" \
#        --seed "$seed" \
#        tx.polkadotXcm.send \
#            "$(jq --null-input '{ "V5": { "parents": 1, "interior": { "X1": [ { "Parachain": 2000 } ] } } }')" \
#            "$(jq --null-input '{ "V5": [ {"trap": '$i'} ] }')"

  sleep 3
done