#!/usr/bin/env bash
set -euo pipefail

show_help() {
        cat << EOF
Usage: $(basename "$0") <input.pdf> [chunk-size] [output-path]

Splits a PDF into multiple smaller PDFs.

Arguments:
  input.pdf     Path to the PDF file to split (required)
  chunk-size    Pages per chunk (default: 100)
  output-path   Output directory (defaults to input directory)

Requires pdftk 
EOF
}

if [ "$#" -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

if ! command -v pdftk >/dev/null 2>&1
then
    echo "pdftk could not be found."
    exit 1
fi

input_pdf="$1"
chunk_size="${2:-100}"
output_path="${3:-$(dirname "$input_pdf")}"

if [ ! -f "$input_pdf" ]; then
    echo "Error: file not found." >&2
    exit 1
fi

total_pages=$(pdftk "$input_pdf" dump_data | awk '/NumberOfPages/ {print $2}')

filename=$(basename "$input_pdf")
name="${filename%.*}"
 
outdir="${output_path}/${name} (chunked)"
mkdir -p "$outdir"

start=1
while [ "$start" -le "$total_pages" ]; do
    end=$((start + chunk_size - 1))
    if [ "$end" -gt "$total_pages" ]; then
        end=$total_pages
    fi
 
    outfile="${outdir}/${name}(p${start}-${end}).pdf"
    pdftk "$input_pdf" cat "${start}-${end}" output "$outfile"
    echo "Created: $outfile"
 
    start=$((end + 1))
done
 
echo "Done. ${total_pages} pages chunked into: ${outdir}"
