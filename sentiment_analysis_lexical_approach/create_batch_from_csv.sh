#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Invalid number of arguments, expected 3 but got $#"
	echo "Usage: $0 <input_csv_filename> <output_csv_filename> <batch_size>"
	exit 1
fi

# check if file exists
if [ ! -f "$1" ]; then
	echo "$1 does not exists or it's not a file."
	exit 2
fi

input_with_header_length="$(wc -l "$1" | awk '{print $1}')"
input_length="$(expr $input_with_header_length - 1)"

# check if the batch_size is valid (must be smaller than the number of rows in the input)
if [ "$3" -gt "$input_length" ]; then
	echo "Batch size cannot be greater than the number of rows in the data."
	echo "Batch size = $3, number of rows in $1 = $input_length"
	echo "Try a smaller batch size."
	exit 3
fi

cat "$1" | head -1 > "$2"
cat "$1" | tail -$3 >> "$2"

echo "Created $2 from $1 with $3 row(s)."
