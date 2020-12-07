#!/bin/bash

curl -X POST -H Content-Type:application/json -d '{
  "method": "core.playback.stop",
  "jsonrpc": "2.0",
  "id": 1
}' http://192.168.0.2:6680/mopidy/rpc
