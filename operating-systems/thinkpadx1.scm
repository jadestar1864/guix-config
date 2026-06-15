(define-module (operating-systems thinkpadx1)
  #:use-module (gnu)

  #:use-module (guix gexp)

  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services desktop)
  #:use-module (gnu services guix)
  #:use-module (gnu services networking)

  #:use-module (gnu system)
  #:use-module (gnu system accounts)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system shadow)

  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages wm)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  #:use-module (operating-systems base)

  #:use-module (home-environments jaden thinkpadx1)

  #:use-module ((unstd config users)
                #:prefix user:)

  #:export (thinkpadx1))

(define thinkpadx1
  (let ((system (base "thinkpadx1")))
       (operating-system
         (inherit system)
         (kernel linux)
         (initrd microcode-initrd)
         (firmware
           (cons*
             iwlwifi-firmware
             %base-firmware))

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

          (packages
            (append
              (list
                niri
                xdg-desktop-portal-gtk
                xdg-desktop-portal-gnome
                xwayland-satellite)
              base-config-packages))

          (services
            (append
              (list
                (service network-manager-service-type
                         (network-manager-configuration
                           (extra-configuration-files
                             `(("wifi_backend.conf" ,(plain-file "wifi_backend.conf"
                                                                 "[device]
wifi.backend=iwd
wifi.iwd.autoconnect=false\n"))))))
                (service guix-home-service-type
                          `(("jaden" ,jaden-home-thinkpadx1))))
              (modify-services
                (operating-system-user-services system)
                (greetd-service-type
                  config => (greetd-configuration
                    (inherit config)
                    (greeter-supplementary-groups `("video" "input" "seat"))
                    (terminals
                      (append
                        (list
                          (greetd-terminal-configuration
                            (terminal-vt "1")
                            (terminal-switch #t)
                            (default-session-command
                              (greetd-tuigreet-session
                                (command
                                  (greetd-user-session
                                    (command
                                      (file-append niri "/bin/niri")
                                      (command-args '("--session")))))))))
                        (map
                          (lambda (x)
                                  (greetd-terminal-configuration
                                    (terminal-vt (number->string x))
                                    (default-session-command
                                      (greetd-agreety-session
                                        (command
                                          (greetd-user-session
                                            (command #~(passwd:shell (getpw)))))))))
                          (iota 3 2))))))))))))

thinkpadx1
