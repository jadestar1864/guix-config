(define-module (unstd config users)
  #:use-module (gnu system accounts)
  #:export (jaden))

(define jaden
  (user-account
    (name "jaden")
    (password "$6$jv0bWmA1MrlvvseQ$tx21l7vuVD.2BFVT99CiM/bEaaB6QLuN7C0OmjQCiibzEg137t6C4YXdQG0heQkDbx7pvJfcvU11OH9ujkhag0")
    (home-directory "/home/jaden")
    (group "users")))
