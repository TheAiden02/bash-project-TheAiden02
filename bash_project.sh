# The purpose of this script is to translate an inputted text file to pig latin.
# The user will specify the file to translate and the output directory for the translation.

function display_usage(){
  echo "Usage: $0 -f [filename] -d [output_dir]"
  echo "Options:"
  echo "  -f [filename]: Specify the input filename."
  echo "  -d [output_dir]: Specify the output directory where the results will be stored."
  echo "  -h: Display this script's help information."
}

# If no arguments are provided, display usage information and exit
if [ $# -eq 0 ]; then
  display_usage
  exit 1
fi

while getopts ":f:d:h" opt; do
  case $opt in
    f) # Determine the file to translate
      input_file=$OPTARG
      ;;
    d) # Specify where to save the translation
      output_dir=$OPTARG
      ;;
    h) # dislays usage information
      display_usage
      exit 1
      ;;
    \?) # Some other switch was used
      echo "Invalid option: -$OPTARG"
      # display usage and exit
      display_usage
      exit 1
      ;;
    :) # no argument
      echo "Option -$OPTARG requires an argument."
      # display usage and exit
      display_usage
      exit 1
      ;;
  esac
done

# Check to make sure that the provided input file exists
if [ ! -f $input_file ]; then
  echo "$input_file is not an existing file."
  display_usage
  exit 1
fi

# Check to make sure that the provided output directory exists
if [ ! -d $output_dir ]; then
  echo "$output_dir is not an existing directory."
  display_usage
  exit 1
fi

# Handle words starting with vowels by appending the suffix 'way'
# Create a temporary file that we can run another sed command on that file to handle words beginning in consonants
sed -E "s/(\b[aeiou][A-Za-z]*)/\1way/gi" $input_file > $input_file.temp

# Handle words beginning with consonants by moving the first letter to the end of the word and the suffix 'ay' at the end
sed -E "s/(\b[bcdfghj-np-tv-z])(\B[a-z]+)/\2\1ay/gi" $input_file.temp > $output_dir/$input_file

# Delete the temporary file
rm $input_file.temp

