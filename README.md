# OgaNs

An alternate api and semantics for namespaced xpaths in Oga

## Motivation

I am very excited about [oga](https://github.com/YorickPeterse/oga), a new XML parser written in ruby. 

However, the API and semantics it supplies for querying xpath with XML namespaces is not ideal for me. 

There are a variety of ways to express namespaces in XML, that are all meant to be considered semantically equivalent. I want to be able to search for a node with a given namespace URI, without having to worry about the specific way that namespace was expressed in the document.

* Whether the original document specified that namespace as a default namespace or prefixed namespace
* Without knowing what prefix the original document used, if any
* Even if the original document uses, at different parts of the document, multiple default namespaces, or multiple prefixed namespaces with the same prefixes or the same namespace URI's. 

[This test suite](./test/unit/pathological_tests.rb) shows some examples of complicated things that it's legal to do in XML, and which I need to take account of. 

In standard oga, you can query with semantics taking account of those cases, only only by using the XML `namespace-uri()` function in an xpath, eg

    doc.xpath("//*:parent[namespace-uri()='http://example.com/A']/*:child[namespace-uri()='http://example.com/A']/*:grandchild[namespace-uri()='http://example.com/B']") 

This can be difficult to work with, I wanted a better API for my use cases, eg

    doc.xpath("a:parent/a:child/b:grandchild", "a" => "http://example.com/", "b" => "http://other.example.com/")

So `oga_ns` is a very simple and lightly-stepping extension to oga that provides the API and semantics I need. It's only a couple dozen lines of code, adding `xpath_ns` and `at_xpath_ns` methods -- **it does not alter any existing oga methods whatsoever** and should never change oga's api for any client code expecting the standard oga api and unaware of the oga_ns methods. 

## Usage

OgaNS adds two new methods to an Oga document, `#xpath_ns` and `#at_xpath_ns`. 

For now, for the sake of caution, you need to explicitly extend every individual Oga document you'd like to add these methods to. 

~~~ruby
require 'oga'
require 'oga_ns'

doc = Oga.parse_xml(some_xml).extend( OgaNs::Document )
~~~

Then, you can query supplying _query context namespace_ prefixes that will be used to resolve your query, nokogiri-style, using the new `xpath_ns` method:

~~~ruby
doc.xpath_ns("ex:one/b:two", "ex" => "http://example.com/", "b" => "http://b.example.com/")
~~~

As a convenience, you can alternately register these _query context namespaces_ on the document, and then you don't need to supply them with every `xpath` call:

~~~ruby
doc.use_query_namespaces!("ex" => "http://example.com/", "b" => "http://b.example.com/")
doc.xpath_ns("ex:one/b:two")
~~~

If you need to supply the oga variable bindings hash argument, you can still do as an optional third argument (may require an empty hash argument to skip the query namespace hash):

~~~ruby
doc.xpath_ns("xpath", {}, variable_bindings_hash)
~~~

In addition to `xpath_ns`, a corresponding `at_xpath_ns` is available which works just the same as `xpath_ns` with the same arguments, but it returns only the first match or nil, like ordinary `at_xpath. 

### Note: Document prefixes vs query context prefixes

