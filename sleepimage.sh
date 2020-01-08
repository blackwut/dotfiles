#!/usr/bin/env bash


# Restart your machine and hold down CMD + R to boot into recovery mode.
# Type the following to disable SIP
#
#     csrutil disable
#     reboot
#
# When your machine starts back up, go into terminal and remove the sleepimage.
# This time, it’ll work.

if csrutil status | grep -q enabled; then
    echo "Please disable System Integrity Protection (SIP) by following sleepimage.sh script description."
    exit
fi

# Remove the sleep image file to save disk space
sudo rm -f /private/var/vm/sleepimage
# Create a zero-byte file instead
sudo touch /private/var/vm/sleepimage
# and make sure it can’t be rewritten
sudo chflags uchg /private/var/vm/sleepimage

# Now boot back into recovery mode and re-enable SIP:
#     csrutil enable
#     reboot
#
# When you’re back into MacOS verify that SIP is enabled and
# the sleepimage has a size of 0 bytes.
#     csrutil status
#     ls -la /private/var/vm