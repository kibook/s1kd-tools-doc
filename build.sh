#!/bin/sh

# Usage: sh build.sh <OUTDIR> <CSDB> <PM> <MEDIA> <VERSION>

set -e

if test "$#" -ne 5
then
	echo "Usage: sh build.sh <OUTDIR> <CSDB> <PM> <MEDIA>"
	echo
	echo "Options:"
	echo "  <OUTDIR>   Directory to write filtered objects to."
	echo "  <CSDB>     Directory to read objects from."
	echo "  <PM>       The publication module to use."
	echo "  <MEDIA>    The type of media (web or pdf)."
	echo "  <VERSION>  Version of the product."
	echo
	echo "Example:"
	echo "  sh build.sh custom csdb PMC-XX-12345-00001-00 pdf"
	exit 1
fi

OUTDIR="$1"
CSDB="$2"
PM="$3"
MEDIA="$4"
VERSION="$5"

# Create the output directory
rm -rf "$OUTDIR"
mkdir "$OUTDIR"

# Filter the PM and DMs and copy them to the output directory
s1kd-refs -Ds -d "$CSDB" "$PM" | s1kd-instance -L -O "$OUTDIR" -s media:prodattr="$MEDIA" -Y "Version: $VERSION"

# Copy the ICNs used by the filtered PM and DMs to the output directory
s1kd-ls -DP "$OUTDIR" | s1kd-refs -Gl -d "$CSDB" | sort -u | xargs cp -t "$OUTDIR"

# Synchronize references in the filtered DMs
s1kd-ls -D "$OUTDIR" | s1kd-syncrefs -fl

# Validate the filtered PM and DMs
s1kd-ls -DP "$OUTDIR" | s1kd-validate -l
s1kd-ls -DP "$OUTDIR" | s1kd-brexcheck -L
