# nixos-lbc
## Partition scheme:
```
sudo -i
lsblk
cfdisk /dev/vda
```
- gpt labels: 1G type: EFI, 4G type: swap, remaining space, type: Linux Filesystem
```
mkfs.ext4 -L nixos /dev/vda3
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda1
```
- Mount the partitions:
```
mount /dev/vda3 /mnt
mount --mkdir /dev/vda1 /mnt/boot
swapon /dev/vda2
lsblk ## check
```

## Generate the NexOS config files:
```
nixos-generate-config --root /mnt
cd /mnt/etc/nixos/
```
## Clone the rest from this repo:
```git clone git@github.com:lbc0/nixos-lbc.git```

# Install NixOS:
```
nixos-install --flake /mnt/etc/nixos#nixos-lbc
# Enter the root password
nixos-enter --root /mnt -c 'passwd lbc' #add password for the user
reboot

# If their is an issue, add the "no-write" option: (nixos-install --flake /mnt/etc/nixos#nixos-lbc --no-write-lock-file)
```
# Dotfiles
```
mkdir ~/nixos-dotfiles
git clone git@github.com:lbc0/nixos-lbc.git
# verify the ownership and permissions: sudo chown -R lbc:users ~/nixos-dotfiles && 
```

# Rebuild
```sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-lbc```





