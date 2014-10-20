require 'oga'
require 'oga/xpath/evaluator'

module OgaNs
  module XPath
    # Sublcass of Oga::XPath::Evaluator that handles namespaces differently,
    # with query namespace context. 
    #
    # Second argument in initializer is now a hash of prefix=>namespaces
    # to be used just in the context of this evaluator, for this query. 
    class Evaluator < Oga::XPath::Evaluator
      def initialize(document, namespaces = {}, variables = {})
        super(document, variables)
        @query_namespaces = namespaces
      end

      # OVERRIDE of Oga namespace_matches?, to take query namespace
      # context into account and match on URI match, ignoring prefix. 
      def namespace_matches?(xml_node, ns)
        return false unless xml_node.respond_to?(:namespace)

        unless (query_uri = @query_namespaces[ns])
          raise ::OgaNs::UnspecifiedPrefixException.new("Unspecified namespace prefix: '#{ns}'")
        end

        return (ns == '*') || (xml_node.namespace && xml_node.namespace.uri == query_uri)
      end


    end
  end
end