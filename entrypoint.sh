# if the env var `RRVIDEO_EVENTS` exists
if [ -n "$RRVIDEO_EVENTS" ]; then
  # replace the default events with the env var
  echo $RRVIDEO_EVENTS > /data/event.json
fi
