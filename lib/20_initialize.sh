# Start the system
initialize()
{
  # Start the container in the background
  lxc-start -n $CONTAINER_NAME -P $CONTAINER_HOME -d
}

