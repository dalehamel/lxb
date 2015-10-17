# Set up the actual system
prepare()
{
  # Some final updates
  cexec apt-get update
  cexec apt-get install -y linux-generic-lts-vivid
}
