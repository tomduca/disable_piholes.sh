# Pi-hole Bulk Disabler

A lightweight Bash script to temporarily disable two Pi-hole instances simultaneously via SSH using a dedicated key.

## Implementation Steps

### 1. Generate a Dedicated SSH Key
On your local machine, create a passwordless SSH key specifically for this automation:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/pihole_key -N "" -C "pihole-automation"
```
*How to verify:* Run `ls -la ~/.ssh/pihole_key*` and check that both the private and public key files exist.

### 2. Copy the Key to Each Pi-holes
Transfer the public key to each server (you will be prompted for the user password once per server):
```bash
ssh-copy-id -i ~/.ssh/pihole_key.pub user@IP_PIHOLE_1
ssh-copy-id -i ~/.ssh/pihole_key.pub user@IP_PIHOLE_2
```
*How to verify:* Run `ssh -i ~/.ssh/pihole_key user@IP_PIHOLE_1` and ensure you log in without entering a password. Type `exit` to leave.

### 3. Configure Passwordless Sudo on the Remotes
To allow the remote user to disable Pi-hole without an interactive password prompt, log into each Pi-hole, run `sudo visudo`, and add the following line at the end of the file:
```text
your_username ALL=(ALL) NOPASSWD: /usr/local/bin/pihole, /usr/bin/pihole
```
*How to verify:* Run `ssh -i ~/.ssh/pihole_key user@IP_PIHOLE_1 "sudo pihole status"` and check that it returns the status without asking for a password.

### 4. Create the Script File
Create the script file on your machine:
```bash
nano disable_piholes.sh
```

### 5. Paste the Script Code
Paste the following code into `disable_piholes.sh`, replacing the placeholder IPs, users, and desired duration:

```bash
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
```
*(Save the file in nano by pressing `Ctrl+O`, then `Enter`, and exit with `Ctrl+X`)*

### 6. Give Execution Permissions and Run
Make the script executable:
```bash
chmod +x disable_piholes.sh
```
*How to verify:* Run `./disable_piholes.sh` and verify via your Pi-hole web interfaces that both instances pause successfully.

## Use Case
This script is ideal for situations where you receive an email containing a link that routes through tracking or redirection services which you normally prefer to block for privacy and security. Because you do not want to permanently add these domains to your whitelist, but exceptionally need them to resolve so you can access the link, you can simply run this script from your terminal to pause your Pi-holes instantly without having to manually log into their admin web panels.
