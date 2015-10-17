# Start the system
initialize()
{
  # Create the container (shouldn't do anything)
  lxc-create -n $CONTAINER_NAME -P $CONTAINER_HOME

  # Start the container in the background
  lxc-start -n $CONTAINER_NAME -P $CONTAINER_HOME -d
}

