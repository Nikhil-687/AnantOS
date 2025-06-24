# Build new image
dd if=/dev/zero of=disk.img bs=1M count=64
mkfs.vfat disk.img

sleep 1
# Mount and prep folders
rm -r ./mnt
sleep 1

mkdir mnt
sudo mount -o loop disk.img mnt
sudo mkdir -p mnt/EFI/BOOT
sudo mkdir -p mnt/bin

sleep 1

# Copy binaries
sudo cp bin/busybox mnt/bin/busybox
sudo cp bin/busybox mnt/bin/sh

sleep 1

# Build .EFI binary (assuming Makefile is fixed)
make clean
make

sleep 1

# Validate
file build/BOOTX64.EFI

sleep 1

# Copy EFI app
sudo cp build/BOOTX64.EFI mnt/EFI/BOOT/

sleep 1

# Unmount image
sudo umount mnt

sleep 1

# Boot
qemu-system-x86_64 \
  -drive format=raw,file=disk.img \
  -bios /usr/share/ovmf/OVMF.fd \
  -m 512M \