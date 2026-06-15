(define-module (home-environments jaden shared desktop)
  #:use-module (gnu home)

  #:use-module (gnu home services)
  #:use-module (gnu home services niri)
  #:use-module (gnu home services sound)

  #:use-module (gnu packages linux)

  #:use-module (home-environments jaden base)
  #:use-module (home-environments jaden shared packages)

  #:export (jaden-home-base-desktop))

(define jaden-home-base-desktop
  (home-environment
    (packages
      (append
        jaden-home-desktop-packages
        jaden-home-base-packages))
    (services
      (append
        (list
          #|Desktop services|#
          ;(service home-niri-service-type)

          #|Sound services|#
          (service home-pipewire-service-type
                   (home-pipewire-configuration
                     (wireplumber wireplumber-minimal))))
        (home-environment-user-services jaden-home-base)))))
