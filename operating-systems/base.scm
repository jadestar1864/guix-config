(define-module (operating-systems base)
  #:use-module (gnu)

  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)

  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages package-management)

  #:use-module (gnu services)
  #:use-module (gnu services admin)
  #:use-module (gnu services base)
  #:use-module (gnu services dbus)
  #:use-module (gnu services desktop)
  #:use-module (gnu services guix)
  #:use-module (gnu services linux)
  #:use-module (gnu services networking)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services sysctl)

  #:use-module (gnu system)
  #:use-module (gnu system keyboard)

  #:use-module (gnu packages curl)
  #:use-module (gnu packages version-control)

  #:use-module (guix channels)

  #:use-module ((unstd config substitute-keys)
                #:prefix substitute-key:)

  #:export (base
            base-config-packages
            system-channels))

(define system-channels
  (append
    (list
      (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (introduction
          (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
    %default-channels))

(define base-config-packages
  (append
    (list
      git
      curl)
    %base-packages))

(define (base host-name)
  (operating-system
    (host-name host-name)
    (timezone "America/Chicago")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us"))

    (file-systems '())

    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))
        (keyboard-layout keyboard-layout)))

    (packages base-config-packages)

    (services
      (list
        (service zram-device-service-type
                 (zram-device-configuration
                   (priority 100)
                   (size (* 4 (expt 2 30))) ; 4GB zRAM size
                   (compression-algorithm 'zstd)))

        #|Shepard services|#
        (service shepherd-timer-service-type)
        (service shepherd-transient-service-type)

        #|Login services|#
        (service virtual-terminal-service-type)
        (service console-font-service-type
                 `(("tty1" . ,%default-console-font)
                   ("tty2" . ,%default-console-font)
                   ("tty3" . ,%default-console-font)))
        (service seatd-service-type)
        (service greetd-service-type
                 (greetd-configuration
                   (greeter-supplementary-groups `("seat"))
                   (terminals
                     (map (lambda (x)
                            (greetd-terminal-configuration
                              (terminal-vt (number->string x))
                              (terminal-switch (= x 1))
                              (default-session-command
                                (greetd-agreety-session
                                  (command
                                    (greetd-user-session
                                      (command #~(passwd:shell (getpw)))))))))
                          (iota 3 1)))))

        #|Log services|#
        (service shepherd-system-log-service-type)
        (service log-rotation-service-type
                 (log-rotation-configuration
                   (expiry (* 2 30 24 3600)))) ; 2 months in seconds
        (service log-cleanup-service-type
                 (log-cleanup-configuration
                   (directory "/var/log/guix/drvs")
                   (expiry (* 2 30 24 3600)))) ; 2 months in seconds

        #|IPC services|#
        (service dbus-root-service-type)

        #|Guix services|#
        (service guix-service-type
                 (guix-configuration
                   (channels system-channels)
                   (guix (guix-for-channels system-channels))
                   (substitute-urls
                     '("https://cache-us-lax.guix.moe"
                       "https://ci.guix.gnu.org"
                       "https://substitutes.nonguix.org"))
                   (authorized-keys
                     (list
                       substitute-key:guix.pub
                       substitute-key:moe.pub
                       substitute-key:nonguix.pub))
                   (extra-options
                     (list
                       "--gc-keep-derivations=yes"
                       "--gc-keep-outputs=yes"))))
        (service shared-cache-service-type
                 (shared-cache-configuration
                   (mode 'share)
                   (users (list (user-cache (user "jaden"))))))

        #|Device management services|#
        (service udev-service-type)

        #|Network services|#
        (service static-networking-service-type
                 (list %loopback-static-networking))
        (service ntp-service-type)
        (service iwd-service-type
                 (iwd-configuration
                   (config
                     (iwd-settings
                       (general
                         (iwd-general-settings
                           (enable-network-configuration? #t)
                           (extra-options
                             `(("Country" . "US")
                               ("AddressRandomization" . "once")
                               ("AddressRandomizationRange" . "full")))))
                         (network
                           (iwd-network-settings
                             (name-resolving-service 'resolvconf)))))))

        #|Base services|#
        (service sysctl-service-type)
        (service urandom-seed-service-type)
        (service nscd-service-type)
        (service special-files-service-type
                 `(("/bin/sh" ,(file-append bash "/bin/sh"))
                   ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))))))
