echo -e 'У вас ssd ? \n'
read -p "1 - ssd , 0 - нет:" ssd
   if [[ $ssd == 0 ]]; then
     echo ''
   elif [[ $ssd == 1 ]]; then
     sed -i 's/.*HOOKS=(base udev autodetect modconf block filesystems keyboard fsck).*/HOOKS=(base udev autodetect modconf block filesystems keyboard keymap)/' ~/mkinitcpio.conf     
   fi 
