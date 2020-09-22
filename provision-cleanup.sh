#!/usr/bin/env bash

if [[ -z $SCRIPTS ]]
then
  SCRIPTS=.
fi

chmod +x $SCRIPTS/scripts/*.sh

for script in \
  emerge      \
  cleanup     
do
  "$SCRIPTS/scripts/$script.sh"
done

echo "All done."
