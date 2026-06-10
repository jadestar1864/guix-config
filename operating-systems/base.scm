(define-module (operating-systems base)
  #:use-module (gnu system)
  #:export (base))

(define base
  (operating-system
    (host-name "base")
    (timezone "America/Chicago")
    (locale "en_US.utf8")
    (firmware '())
    (file-systems '())
    (bootloader #f)
  ))
