# Current problem
# - ssh-copy-id calls ssh
# - "-n", "-e" and "-E" are caught by echo


function ssh (){
  ARGUMENT_NUMBER=1
  ARGUMENT_IS_DESTINATION=0

  while [[ ARGUMENT_IS_DESTINATION -eq 0 ]]; do
    ARGUMENT=$(echo $(eval echo "\$$ARGUMENT_NUMBER"))
    echo $ARGUMENT: $ARGUMENT_NUMBER

    if echo $ARGUMENT | grep '-'; then
      if echo $ARGUMENT | grep '[46AaCfGgKkMNnqsTtVvXxYy]' > /dev/null ; then
        ARGUMENT_NUMBER=$(( $ARGUMENT_NUMBER + 1 ))
      elif echo $ARGUMENT | grep '[BbcDEeFIiJLlmOopQRSWw]' > /dev/null ; then
        ARGUMENT_NUMBER=$(( $ARGUMENT_NUMBER + 2 ))
      else
        echo "ssh option was not recognised, exiting..."
        return 1
      fi
    else
      ARGUMENT_IS_DESTINATION=1
    fi
    echo test
  done

  echo destination
  ssh-copy-id $destination
  ssh $@

}
