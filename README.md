# chrubuntu
Configs to flash BIOS, install ubuntu, and provision dev environment on Chromebook (from USB)

Flow:
  
  Remove hardware screw to disable write protection
  
  Flash bios to enable SeaBios legacy
    
    cd;
    sudo -E bash seabios-flash.sh 
    Pray flash doesn't brick the device
    sudo crossystem dev_boot_usb=1 dev_boot_legacy=1
    sudo enable_dev_boot
  
  Boot to ubuntu
  
    bash -c "$(wget -qO - https://raw.github.com/harisbeha/dotfiles/master/dotfiles)"
    
    ./dotfiles to update
  
  Provision usb stick raid 
    
    (ノ͡° ͜ʖ ͡°)ノ︵┻┻
    
    apt-get install mdadm
    # for raid 0 
      mdadm /dev/md0 --create --level=1 -n 2 /dev/sdb1 /dev/sdc1  
    
    # for raid 10 
      mdadm -v --create /dev/md0 --level=raid10 --raid-devices=4 /dev/sda2 /dev/sdb1 /dev/sdc1 /dev/sdd1
      
  Install toolbelt
    
    ./bookit
    
  Pray everything works
  
    ¯\_(⊙_ʖ⊙)_/¯
