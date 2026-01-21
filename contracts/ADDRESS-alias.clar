;; =====================================================================
;; ADDRESS ALIAS SYSTEM - FULL CLARINET CONTRACT
;; =====================================================================
;; PURPOSE
;; -------
;; This smart contract allows blockchain addresses to register a single,
;; human-readable alias (username).
;;
;; RULES
;; -----
;; 1. One address can own only ONE alias
;; 2. One alias can belong to only ONE address
;; 3. Aliases are immutable once registered
;; 4. Anyone can read alias information
;;
;; DESIGN GOALS
;; ------------
;; - Extremely readable and beginner-friendly
;; - Clear separation of concerns
;; - Safe Clarity patterns
;; - Easy to test with Clarinet
;; =====================================================================

;; ---------------------------------------------------------------------
;; SECTION 1: CONSTANTS
;; ---------------------------------------------------------------------

;; Maximum allowed alias length (ASCII characters)
(define-constant MAX-ALIAS-LENGTH u20)

;; Error codes
;; u100 - sender already owns an alias
;; u101 - alias already taken
;; u102 - alias is empty

;; ---------------------------------------------------------------------
;; SECTION 2: DATA STORAGE
;; ---------------------------------------------------------------------

;; Map: address to alias
;; Ensures one alias per address
(define-map address-to-alias principal (string-ascii 20))

;; Map: alias to address
;; Ensures alias uniqueness
(define-map alias-to-address (string-ascii 20) principal)

;; ---------------------------------------------------------------------
;; SECTION 3: PRIVATE HELPERS
;; ---------------------------------------------------------------------

;; Validate that alias is not empty
(define-private (valid-alias? (alias (string-ascii 20)))
  (> (len alias) u0))

;; ---------------------------------------------------------------------
;; SECTION 4: PUBLIC FUNCTIONS (STATE-CHANGING)
;; ---------------------------------------------------------------------

;; --------------------------------------------------
;; register-alias
;; --------------------------------------------------
;; Allows tx-sender to claim an alias
;;
;; Returns:
;; (ok alias) on success
;; (err u100) sender already has alias
;; (err u101) alias already taken
;; (err u102) alias is empty
;; --------------------------------------------------

(define-public (register-alias (alias (string-ascii 20)))
  (begin
    ;; Alias must not be empty
    (asserts!
      (valid-alias? alias)
      (err u102))

    ;; Sender must not already have an alias
        (asserts!
          (is-none
            (map-get? address-to-alias tx-sender))
          (err u100))

    ;; Alias must not already be claimed
    (asserts!
      (is-none
        (map-get? alias-to-address alias))
      (err u101))

    ;; Save address to alias
    (map-set address-to-alias tx-sender alias)

    ;; Save alias to address
    (map-set alias-to-address alias tx-sender)

    ;; Return confirmation
    (ok alias)))

;; ---------------------------------------------------------------------
;; SECTION 5: READ-ONLY FUNCTIONS
;; ---------------------------------------------------------------------

;; --------------------------------------------------
;; get-alias
;; --------------------------------------------------
;; Returns alias owned by a given address
;;
;; (some { alias }) or none
;; --------------------------------------------------

(define-read-only (get-alias (who principal))
  (map-get? address-to-alias
     who))

;; --------------------------------------------------
;; get-address
;; --------------------------------------------------
;; Returns address that owns a given alias
;;
;; (some { user }) or none
;; --------------------------------------------------

(define-read-only (get-address (alias (string-ascii 20)))
  (map-get? alias-to-address
     alias))

;; --------------------------------------------------
;; has-alias
;; --------------------------------------------------
;; Convenience helper for UIs
;;
;; Returns true or false
;; --------------------------------------------------

(define-read-only (has-alias (who principal))
  (is-some
     (map-get? address-to-alias who)))
