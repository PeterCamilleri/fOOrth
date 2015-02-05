# coding: utf-8

require 'thread'

#* library/queue_library.rb - The Queue support fOOrth library.
module XfOOrth

  #Connect the Queue class to the fOOrth class system.
  Queue.create_foorth_proxy

end
