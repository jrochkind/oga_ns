module OgaNs
  # The exception we throw if querying with xpath_ns for a namespace
  # prefix not defined. We subclass from the same exception class
  # oga itself seems to throw from bad xpath parses, as odd as it is, so
  # people rescueing that superclass will rescue this too. 
  class UnspecifiedPrefixException < Racc::ParseError    
  end
end