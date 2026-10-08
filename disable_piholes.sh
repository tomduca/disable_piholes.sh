#!/bin/bash

# Configuration
DURATION="2m"

PIHOLE_1="[ip_addr_1]"
USER_1="[user_1]"

PIHOLE_2="[ip_addr_2]"
USER_2="[user_2]"

echo "Disabling Pi-hole 1..."
ssh -i ~/.ssh/pihole_key "$USER_1@$PIHOLE_1" "sudo pihole disable $DURATION"

echo "Disabling Pi-hole 2..."
ssh -i ~/.ssh/pihole_key "$USER_2@$PIHOLE_2" "sudo pihole disable $DURATION"

echo "Done!"
