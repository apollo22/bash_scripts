#! /bin/bash
#
# Read a shell alias file and adds complement lines with underscores(_) and dashes(-)

FUNCTION_NAME="alias_add_dash"

function help_message() {
  echo "Usage:"
  echo "  $FUNCTION_NAME -h|--help # Prints this help"
  echo "  $FUNCTION_NAME <variable_name>{1-__} # Execute function"
}

function add_complement_line(){

local file
file=$1

  while read line; do
    if echo "$line" | grep -o 'alias .*=\".*\"$' > /dev/null; then
      line_number=$(echo $line | cut --delimiter=" " --fields="1")
      alias_name=$(echo $line | cut --delimiter=" " --fields="3" | cut --delimiter="=" --fields="1" )
      line=$(echo $line | cut --delimiter=" " --fields="2-")
      dashed_alias=$(echo $alias_name | sed "s/_/-/g")
      underscored_alias=$(echo $alias_name| sed "s/-/_/g")
      dashed_line=$(echo $line | sed "s/$alias_name/$dashed_alias/")
      underscored_line=$(echo $line | sed "s/$alias_name/$underscored_alias/")

      if [[ $line_above -gt 1 ]]; then
        line_above=$(sed -ne "$(( $line_number - 1 )) p" < $file)
      else
        line_above=""
      fi
      line_below=$(sed -ne "$(( $line_number + 1 )) p" < $file)

       echo ------------
       echo "Line              : $line"
       echo "Line number       : $line_number"
      # echo "Alias             : $alias_name"
      # echo "Dashed alias      : $dashed_alias"
      # echo "Underscored alias : $underscored_alias"
      # echo "Dashed line       : $dashed_line"
      # echo "Underscored line  : $underscored_line"
      # echo "Line above        : $line_above"
      # echo "Line below        : $line_below"

      if echo $line | grep "$underscored_line" > /dev/null; then
        # echo "Underscored line detected"
        if ! ( echo $line_below | grep "$dashed_line" > /dev/null || echo $line_above | grep "$dashed_line" > /dev/null ); then
          # echo NO dashed line detected above/below
          sed -i "$line_number s/$line/$line\n$dashed_line/" $file
        fi
      elif echo $line | grep "$dashed_line" > /dev/null; then
        # echo "Dashed line detected"
        if ! ( echo $line_below | grep "$underscored_line" > /dev/null || echo $line_above | grep "$underscored_line" > /dev/null ); then
          # echo NO underscored line detected above/below
          sed -i "$line_number s/$line/$underscored_line\n$line/" $file
        fi
      fi
    fi
  done < <(cat -n $file | tac)
}

# Check number of arguments
if [[ $# -lt 1 ]]; then
  echo "This function needs at list one argument"
  help_message
  exit 1
fi

# Check arguments
if [[ $# -eq 1 ]]; then
  case $1 in
    -h|--help)
      help_message
      shift 1
      ;;
  esac
fi

# Check if files exist
for file in $@; do
  if [[ -f $file ]]; then
    add_complement_line $file
  else
    echo "File $file doesnt existin current directory"
  fi
done 

alias test_test_test="test"
          alias test_test-test="test"
    alias test-test-test="test"
