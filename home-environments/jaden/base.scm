(define-module (home-environments jaden base)
  #:use-module (gnu home)

  #:use-module (gnu home services)
  #:use-module (gnu home services admin)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services xdg)

  #:use-module (home-environments jaden shared packages)

  #:use-module (operating-systems base)

  #:export (jaden-home-base))

(define jaden-home-base
  (home-environment
    (packages jaden-home-base-packages)

    (services
      (list
        (service home-xdg-user-directories-service-type
                 (home-xdg-user-directories-configuration
                   (desktop "$HOME/desktop/")
                   (documents "$HOME/documents/")
                   (download "$HOME/downloads/")
                   (music "$HOME/music/")
                   (pictures "$HOME/images/")
                   (videos "$HOME/videos/")
                   (templates "")
                   (publicshare "")))

        #|Shepherd services|#
        (service home-shepherd-service-type)
        (service home-shepherd-timer-service-type)
        (service home-shepherd-transient-service-type)

        #|Log services|#
        (service home-log-rotation-service-type
                 (log-rotation-configuration
                   (requirement '())
                   (expiry (* 2 30 24 60 60)))) ; 2 months

        #|Session services|#
        (service home-dbus-service-type)

        #|Guix service|#
        (simple-service 'home-extra-channels
                        home-channels-service-type
                        system-channels)))))
