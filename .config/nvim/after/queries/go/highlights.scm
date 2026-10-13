;; extends

;; Match all identifiers directly declared in a const spec (e.g. a, b, c in const ( a, b, c = ... ))
(const_spec
  (identifier) @constant)
