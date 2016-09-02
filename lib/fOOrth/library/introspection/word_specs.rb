# coding: utf-8

#* library/introspection/word_specs.rb - WordSpec support for introspection.
module XfOOrth

  #Get information about this word spec.
  class AbstractWordSpec

    #Get introspection info.
    def get_info
      [["Spec"  , self.class.foorth_name],
       ["Tags"  , tags.join(' ')],
       ["Builds", builds],
       ["Does"  , does.inspect]]
    end
  end

end