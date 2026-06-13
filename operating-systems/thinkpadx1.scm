(define-module (operating-systems thinkpadx1)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)

  #:use-module (gnu services)
  #:use-module (gnu services networking)

  #:use-module (gnu system)
  #:use-module (gnu system accounts)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system shadow)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  #:use-module (operating-systems common base-services)
  #:use-module ((operating-systems common users)
                #:prefix user:)

  #:export (thinkpadx1))

(define thinkpadx1
  (operating-system
    (host-name "thinkpadx1")
    (keyboard-layout
      (keyboard-layout "us"))

    (kernel linux)
    (initrd microcode-initrd)
    (firmware
      (cons*
        iwlwifi-firmware
        %base-firmware))

    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))
        (keyboard-layout keyboard-layout)))

    (mapped-devices
      (list
        (mapped-device
          (source (uuid "c4006768-dd54-4cb2-8ae3-83185acfd261"))
          (target "cryptroot")
          (type luks-device-mapping)
          (arguments '(#:allow-discards? #t)))))

    (file-systems
      (append
        (list
          (file-system
            (device "/dev/nvme0n1p1")
            (mount-point "/boot/efi")
            (type "vfat"))
          (file-system
            (device "/dev/mapper/cryptroot")
            (mount-point "/")
            (type "btrfs")
            (options "subvol=rootfs")
            (dependencies mapped-devices))
          (file-system
            (device "/dev/mapper/cryptroot")
            (mount-point "/home")
            (type "btrfs")
            (options "subvol=home")
            (dependencies mapped-devices))
          (file-system
            (device "/dev/mapper/cryptroot")
            (mount-point "/gnu")
            (type "btrfs")
            (options "subvol=gnu")
            (dependencies mapped-devices))
          (file-system
            (device "/dev/mapper/cryptroot")
            (mount-point "/var/log")
            (type "btrfs")
            (options "subvol=log")
            (dependencies mapped-devices))
          (file-system
            (device "/dev/mapper/cryptroot")
            (mount-point "/swap")
            (type "btrfs")
            (options "subvol=swap")
            (dependencies mapped-devices)))
        %base-file-systems))

    (swap-devices
      (list
        (swap-space
          (target "/swap/swapfile")
          (dependencies (filter (file-system-mount-point-predicate "/swap")
                                file-systems)))))

    (users
      (cons*
        (user-account
          (inherit user:jaden)
          (supplementary-groups '("wheel")))
         %base-user-accounts))

     (services
       (append
         (list
           (service network-manager-service-type)
           (service wpa-supplicant-service-type)
           (service ntp-service-type))
         %common-base-services))))

thinkpadx1
