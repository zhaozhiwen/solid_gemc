#!/usr/bin/env bash
# Run one job of this prototype inside the solid_gemc container (solid_gemc and evio2root on PATH):
# freeze the gcard into runs/<run_id>/, run solid_gemc from this directory (TEXT geometry is looked up
# relative to the cwd), convert with evio2root, write runs/<run_id>/config.json.
#
# Usage: [EVIO_OPTS=...] ./run.sh <gcard> <run_id> [extra solid_gemc options, e.g. -RANDOM=101]
#   EVIO_OPTS (evio2root options) default: -B=$PWD/solid_spacal_proto3   (loads solid_spacal_proto3__bank.txt)
#   add -R=solid_spacal when the gcard sets INTEGRATEDRAW=solid_spacal (validation gcards).
#   Parallel jobs need distinct -RANDOM seeds (default seed is the time).
set -u
GCARD=$1; RUN_ID=$2; shift 2
EXTRA="$*"
HERE=$(cd "$(dirname "$0")" && pwd -P)
EVIO_OPTS=${EVIO_OPTS:--B=$HERE/solid_spacal_proto3}
RUN_DIR="$HERE/runs/$RUN_ID"
[[ -e "$RUN_DIR" ]] && { echo "run dir exists: $RUN_DIR (pick a new id)"; exit 1; }
mkdir -p "$RUN_DIR"
cp "$HERE/$GCARD" "$RUN_DIR/gcard.gcard"

START_ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ); START=$(date +%s)
( cd "$HERE" && solid_gemc "$RUN_DIR/gcard.gcard" -OUTPUT="evio,$RUN_DIR/out.evio" $EXTRA ) > "$RUN_DIR/log.txt" 2>&1
GEMC_EXIT=$?
EVIO_EXIT=-1
if [[ $GEMC_EXIT -eq 0 && -f "$RUN_DIR/out.evio" ]]; then
  ( cd "$RUN_DIR" && evio2root -INPUTF=out.evio $EVIO_OPTS ) >> "$RUN_DIR/log.txt" 2>&1
  EVIO_EXIT=$?
fi
END=$(date +%s)

cat > "$RUN_DIR/config.json" <<JSON
{
  "run_id": "$RUN_ID",
  "gcard_source": "$GCARD",
  "extra_options": "$EXTRA",
  "evio2root_options": "$EVIO_OPTS",
  "solid_gemc_sha": "$(git -C "$HERE" rev-parse HEAD 2>/dev/null || echo unknown)",
  "solid_gemc_dirty": "$(git -C "$HERE" status --porcelain -- . ../../source 2>/dev/null | wc -l) changed paths",
  "geometry_sha256": "$(cd "$HERE" && sha256sum solid_spacal_proto3__geometry_*.txt | tr '\n' ';')",
  "start_utc": "$START_ISO",
  "wall_seconds": $((END - START)),
  "gemc_exit_code": $GEMC_EXIT,
  "evio2root_exit": $EVIO_EXIT
}
JSON
echo "run $RUN_ID: gemc exit $GEMC_EXIT, evio2root exit $EVIO_EXIT, $((END - START)) s -> $RUN_DIR"
