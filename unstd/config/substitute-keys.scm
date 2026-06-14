(define-module (unstd config substitute-keys)
  #:use-module (gnu)
  #:export (guix.pub
            moe.pub
            nonguix.pub))

(define guix.pub
  (plain-file
    "guix.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #8D156F295D24B0D9A86FA5741A840FF2D24F60F7B6C4134814AD55625971B394#)))"))

(define moe.pub
  (plain-file
    "moe.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))"))

(define nonguix.pub
  (plain-file
    "nonguix.pub"
    "(public-key 
       (ecc 
        (curve Ed25519)
        (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
