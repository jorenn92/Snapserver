#!/bin/bash

curl -X POST -H Content-Type:application/json -d '{
  "method": "core.playback.stop",
  "jsonrpc": "2.0",
  "id": 1
}' http://127.0.0.1:6680/mopidy/rpc
