(define-module (operating-systems thinkpadx1)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)

  #:use-module (gnu system)
  #:use-module (gnu system accounts)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system shadow)

  #:use-module (operating-systems base)
  #:use-module ((operating-systems common users)
                #:prefix user:)

  #:export (thinkpadx1))

(define thinkpadx1
  (operating-system
    (inherit base)
    (host-name "thinkpadx1")
    (keyboard-layout
      (keyboard-layout "us"))

    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))
        (keyboard-layout keyboard-layout)))

    (mapped-devices
      (list
        (mapped-device
          (source "/dev/nvme0n1")
          (target "cryptroot")
          (type luks-device-mapping)
          (arguments '(#:allow-discards? #t)))))

    (file-systems
      (append
        (list (file-system
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
                (mount-point "/boot")
                (type "btrfs")
                (options "subvol=boot")
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
                (device "/dev/nvme0n1p1")
                (mount-point "/boot/efi")
                (type "vfat")))
        %base-file-systems))

    (users
      (cons* user:jaden
             %base-user-accounts))))

thinkpadx1
