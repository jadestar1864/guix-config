(define-module (home-environments jaden shared packages)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages wm)

  #:export (jaden-home-base-packages
            jaden-home-desktop-packages))

(define jaden-home-base-packages
  (list
    ))

(define jaden-home-desktop-packages
  (append
    (list
      dank-material-shell
      foot)
    jaden-home-base-packages))
