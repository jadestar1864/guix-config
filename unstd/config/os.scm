(define-module (unstd config os)
  #:use-module (gnu)
  #:use-module (gnu packages package-management)
  #:use-module (gnu system)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (guix channels)
  #:export (%common-base-services))

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

(define %common-base-services
  (modify-services
    %base-services
    (guix-service-type
      config =>
        (guix-configuration
          (inherit config)
          (channels system-channels)
          (substitute-urls
            (append
              (list "https://substitutes.nonguix.org")
              %default-substitute-urls))
          (authorized-keys
            (append
              (list (local-file "./nonguix-signing-key.pub"))
              %default-authorized-guix-keys))
          (guix (guix-for-channels system-channels))))))
