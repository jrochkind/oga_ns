require 'test_helper'

# Test various kinds of craziness
describe "with crazy results" do
  describe "handles nested default namespace" do

    before do 
      doc = <<-EOS
        <root xmlns="http://example.org/top">
          <node>top</node>
          <container xmlns="http://example.org/bottom">
            <node>bottom</node>
          </container>
        </root>
        EOS
      @oxml = Oga.parse_xml(doc).extend(OgaNs::Document)
    end

    it "can find outer" do
      result = @oxml.xpath_ns("//e:node", "e" => "http://example.org/top")

      assert_equal 1, result.size, "expected 1 result not #{result.size}"
      node = result.first

      assert_equal "node", node.name
      assert_equal "top", node.text
    end

    it "can find inner" do 
      result = @oxml.xpath_ns("//e:node", "e" => "http://example.org/bottom")

      assert_equal 1, result.size, "expected 1 result not #{result.size}"
      node = result.first

      assert_equal "node", node.name
      assert_equal "bottom", node.text
    end
  end

  describe "handles multiple same prefix" do
    before do
      doc = <<-EOS
        <root>
          <container xmlns:ex="http://example.com/FIRST">
            <ex:node>FIRST</ex:node>
          </container>
          <container xmlns:ex="http://example.com/SECOND">
            <ex:node>SECOND</ex:node>
          </container>
        </root>
      EOS
      @oxml = Oga.parse_xml(doc).extend(OgaNs::Document)
    end

    it "finds one" do
      result = @oxml.xpath_ns("//e:node", "e" => "http://example.com/FIRST")

      assert_equal 1, result.size, "expected 1 result not #{result.size}"
      node = result.first

      assert_equal "node", node.name
      assert_equal "FIRST", node.text
    end

    it "finds the other" do
      result = @oxml.xpath_ns("//e:node", "e" => "http://example.com/SECOND")

      assert_equal 1, result.size, "expected 1 result not #{result.size}"
      node = result.first

      assert_equal "node", node.name
      assert_equal "SECOND", node.text
    end

  end


end