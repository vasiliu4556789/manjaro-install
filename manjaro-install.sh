#!/bin/bash

#pacstrap --> basestrap
#genfstab --> fstabgen
#arch-chroot --> manjaro-chroot

# первоначальная настройка 

#loadkeys ru
#setfont cyr-sun16
#timedatectl set-ntp true

# установка нужных пакетов 
pacman -Sy wget btrfs-progs manjaro-tools-base

# работа с диском
echo -e '\n\n нужна разметка диска? \n\n'
read -p " 1 - да, 0 - нет: " diski
   if [[ $diski == 1 ]]; then 
      read -p "какой диск или раздел будем разбивать?: " cfd
#     cfdisk /dev/$cfd     
      gparted /dev/$cfd
    elif [[ $diski == 0 ]]; then
      echo 'разметка диска пропущена'
    fi
clear


echo -e '\n\n Показать список разделов ?\n\n'
read -p " 1 - да, 0 - нет: " fdisk
    if [[ $fdisk == 1 ]]; then
      fdisk -l
      elif [[ $fdisk == 0 ]]; then
      echo -e ' Пропущено  \n\n'
      clear            
    fi

#Для обычного жд nossd в параметрах монтирования
read -p " укажите раздел root: " root
  mkfs.btrfs -f -L Manjaro /dev/$root
  mount /dev/$root /mnt
  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home
  umount /mnt
  mount -o subvol=@,compress=zstd,autodefrag,ssd /dev/$root /mnt
  mkdir /mnt/home
  mount -o subvol=@home,compress=zstd,autodefrag,ssd /dev/$root /mnt/home

#Закоментировать для efi  
read -p " укажите раздел boot: " boot
  mkfs.ext2 -F -L boot /dev/$boot  
  mkdir /mnt/boot
  mount /dev/$boot /mnt/boot
  
#Раскоментировать для efi
#read -p "\тукажите раздел для /boot/efi:\n" $efi
#  mkfs.fat -F32 /dev/$efi
#  mkdir -p /mnt/boot/efi
#  mount /dev/$efi /mnt/boot/efi  

  
#Шпаргалка по управлению  
#sudo btrfs subvolume snapshot /mnt/@ /mnt/@test
#sudo btrfs subvolume delete /mnt/@test/
  
clear


echo -e '\n\n Установка пакетов \n\n'
  basestrap /mnt base base-devel linux54 linux-firmware manjaro-release manjaro-keyring zsh nano btrfs-progs
  
# Создаём fstab 
 fstabgen -pU /mnt >> /mnt/etc/fstab
 nano /mnt/etc/fstab
clear

# chroot 

manjaro-chroot /mnt /bin/zsh
