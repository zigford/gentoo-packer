#!/usr/bin/env bash

if [[ -z $STAGE3 ]]
then
  echo "STAGE3 environment variable must be set to a timestamp."
  exit 1
fi

if [[ -z $SCRIPTS ]]
then
  SCRIPTS=.
fi

chmod +x $SCRIPTS/scripts/*.sh

for script in \
  partition   \
  stage3      \
  mounts      \
  resolv.conf \
  portage     \
  timezone    \
  fstab       \
  kernel      \
  grub        \
  network     \
  admin_user
do
  "$SCRIPTS/scripts/$script.sh"
done

echo "All done."
