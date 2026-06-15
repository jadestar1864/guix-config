(define-module (home-environments jaden thinkpadx1)

  #:use-module (gnu home)

  #:use-module (home-environments jaden shared desktop)
  
  #:export (jaden-home-thinkpadx1))

(define jaden-home-thinkpadx1
  (home-environment
    (inherit jaden-home-base-desktop)))
