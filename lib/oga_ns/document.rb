require 'oga_ns/xpath/evaluator'
require 'oga_ns/unspecified_prefix_exception'

module OgaNs
  module Document

    def use_query_namespaces!(ns)
      @query_namespaces = ns
      return self
    end

    def query_namespaces
      @query_namespaces ||= {}
    end

    def xpath_ns(expression, namespaces = nil, variables = {})
      namespaces ||= query_namespaces

      return ::OgaNs::XPath::Evaluator.new(self, namespaces, variables).evaluate(expression)
    end

    # copy of Oga at_xpath but based on our xpath_ns
    def at_xpath_ns(*args)
      result = xpath_ns(*args)

      return result.is_a?(::Oga::XML::NodeSet) ? result.first : result
    end

  end  
end