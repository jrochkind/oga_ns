require 'test_helper'

describe "basic OgaNs" do
  before do
    @doc_str = <<-EOS
      <root xmlns:e="http://example.com/example">
        <plain>plain</plain>
        <e:node />
      </root>
      EOS
    @oga_xml = Oga.parse_xml(@doc_str)
    @oga_xml.extend(OgaNs::Document)
  end

  describe "xpath_ns" do
    it "uses namespace argument" do
      result = @oga_xml.xpath_ns("//example:node", "example" => "http://example.com/example")

      assert result.size == 1, "expected one result, not #{result.size}"
      assert_equal "node", result.first.name
    end

    it "uses query_namespaces" do
      dup = @oga_xml.dup.extend(OgaNs::Document).use_query_namespaces!("example" => "http://example.com/example")      
      
      result = dup.xpath_ns("//example:node")

      assert result.size == 1, "expected one result, not #{result.size}"
      assert_equal "node", result.first.name
    end

    it "finds default namespaces" do
      doc = Oga.parse_xml(<<-EOS)
        <root xmlns="http://example.com/example">
          <node />
        </root>
        EOS
      doc.extend(OgaNs::Document)

      result = doc.xpath_ns("//example:node", "example" => "http://example.com/example")

      assert result.size == 1, "expected one result, not #{result.size}"
      assert_equal "node", result.first.name
    end

    it "raises on undefined namespace" do
      e = nil
      begin
        @oga_xml.xpath_ns("//unspecified:foo")
      rescue ::OgaNs::UnspecifiedPrefixException => e
      end
      assert e, "OgaNs::UnspecifiedParseException expected to be raised, not #{e.inspect}"

      assert_equal "Unspecified namespace prefix: 'unspecified'", e.message
    end

    it "does not find namespaced node with no ns in query" do
      assert_equal 0, @oga_xml.xpath_ns("//node").size, "expected no results"
    end

    it "does not find namespaced node with wrong namespace" do
      assert_equal 0, @oga_xml.xpath_ns("//e:node", "e" => "http://example.org/OTHER").size, "expected no results"
    end

    it "finds nothing on good namespace but no matches" do
      assert_equal 0, @oga_xml.xpath_ns("//example:noneSuch", "example" => "http://example.com/example").size, "expected no results"
    end

    it "can still find un-namespaced nodes" do
      result = @oga_xml.xpath_ns("//plain")

      assert_equal 1, result.size, "expected 1 result not #{result.size}"
      assert_equal "plain", result.first.name
    end

    it "still respects oga * namespace" do
      # Using '*' as a namespace prefix isn't XPath, it's an Oga
      # extension apparently. But it's useful, let's make sure xpath_ns supports
      # it too. 
      oga_xml = Oga.parse_xml(<<-EOS)
        <root>
          <node xmlns="http://example.com/example" />
          <node />
        </root>
        EOS
      oga_xml.extend(OgaNs::Document)

      result = oga_xml.xpath("//*:node")

      assert_equal 2, result.size, "expected 2 results, not #{result.size}"

      assert result.find {|node| node.name == "node" && node.namespace == nil}
      assert result.find {|node| node.name == "node" && node.namespace.uri == "http://example.com/example"}
    end
  end

  describe "at_xpath_ns" do
    # just a simple test for at_xpath_ns too for now. add more if bugs?

    it "works" do
      result = @oga_xml.at_xpath_ns("//example:node", "example" => "http://example.com/example")

      assert_kind_of Oga::XML::Element, result
    end

    it "correctly returns nil on no match" do
      assert_nil @oga_xml.at_xpath_ns("//noSuchElement")
    end

  end
  

end