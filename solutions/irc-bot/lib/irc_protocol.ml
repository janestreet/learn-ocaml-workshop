module Irc_message = struct
  include Message
  let parser_ = Parser.message
end
