(define-module (operating-systems base)
  #:use-module (gnu system)
  #:use-module (operating-systems common base-services)
  #:export (base))

(define base
  (operating-system
    (host-name "base")
    (timezone "America/Chicago")
    (locale "en_US.utf8")
    (firmware '())
    (file-systems '())
    (bootloader #f)
    (services %common-base-services)))
