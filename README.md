# pdf-chunk
A simple, single bash script for the chunking of large PDF files into smaller ones, built on PDFtk.

# Requirements
pdftk must be installed. Use 
`sudo apt install pdftk` 
or similar for your system. 

# Usage
Make the script executable using 
`chmod +x /path/to/pdf-chunk.sh`

Run using 
`/path/to/pdf-chunk.sh <input.pdf> [chunk-size] [output-path]`

The chunk size and output path default to 100, and the input file directory respectively.

For ease of use, the script may be placed in `/usr/local/bin`, or added to `PATH`. 
