require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'

class DTDTests < MiniTest::Unit::TestCase

  def setup_and_exercise type
    Dir.mkdir('tmp') unless File.exists?('tmp')
    out = File.open("tmp/temp.scml", 'w')
    out.write @input
    out.fsync
    @r, @w = IO.pipe
    pid = Process.spawn("xmlstarlet val -e -d #{type}.dtd tmp/temp.scml", [:out, :err]=>@w)
    @w.close
  end

  def teardown
    File.delete("tmp/temp.scml")
  end

  def is_valid
    @r.read !~ /invalid/
  end

  def is_not_valid
    @r.read.match /invalid/
  end

  def test_basic_sam
@input = """
<sam>
<p>stuff</p>
</sam>
"""
    setup_and_exercise 'sam'
    assert is_valid
  end

  def test_sam_with_table
@input = """
<sam>
<p>stuff</p>
<table>
<tr><cell><td>stuff</td></cell></tr>
</table>
</sam>
"""
    setup_and_exercise 'sam'
    assert is_valid
  end

  def test_invalid_sam
@input = """
<sam>
<blockquote/>
<p>stuff</p>
</sam>
"""
    setup_and_exercise 'sam'
    assert is_not_valid
  end

  def test_table_cells
@input = """
<scml>
<book>
<chapter>
<table>
<tr><cell><td>things and stuff</td></cell></tr>
</table>
</chapter>
</book>
</scml>
"""
    setup_and_exercise 'scml'
    assert is_valid
  end

  def test_lots_of_thing_in_table_cells
@input = """
<scml>
<book>
<chapter>
<table>
<tr><cell><list><nl>things and stuff</nl></list><p>stuff</p></cell></tr>
</table>
</chapter>
</book>
</scml>
"""
    setup_and_exercise 'scml'
    assert is_valid
  end

  def test_table_only_allows_table_tr_cell_scheme
@input = """
<scml>
<book>
<chapter>
<table>
<th>this is a head that should be in a cell</th>
<tr><td>yo</td><cell><list><nl>things and stuff</nl></list><p>stuff</p></cell></tr>
</table>
</chapter>
</book>
</scml>
"""
    setup_and_exercise 'scml'
    assert is_not_valid
  end

  def test_blockquote_allowed_in_sidebar
@input = """
<scml>
<book>
<chapter>
<sidebar>
<blockquote/>
</sidebar>
</chapter>
</book>
</scml>
"""
    setup_and_exercise 'scml'
    assert is_valid
  end

  def test_lang_allowed_everywhere_scml
@input = '
<scml lang="en">
<book lang="en">
<chapter lang="en">
<sidebar lang="en">
<blockquote lang="en"/>
</sidebar>
</chapter>
</book>
</scml>
'
    setup_and_exercise 'scml'
    assert is_valid
  end

  def test_lang_allowed_everywhere_sam
@input = '
<sam lang="en">
<p lang="en"><i lang="en"/></p>
<ah lang="en"><grc lang="en"/></ah>
</sam>
'
    setup_and_exercise 'sam'
    assert is_valid
  end

  def test_idref_on_xref_in_sam
@input = <<-EOF
<sam>
<p id="p01">some stuff</p>
<ah><xref idref="p01">whatever</xref></ah>
</sam>
EOF
    setup_and_exercise 'sam'
    assert is_valid
  end

  def test_anchor_in_sam
@input = <<-EOF
<sam>
<p id="p01">some stuff<a id="j9"/></p>
</sam>
EOF
    setup_and_exercise 'sam'
    assert is_valid
  end

  def test_footnote_endnote_in_sam
@input = <<-EOF
<sam>
<p>more stuff</p>
<footnote>
<fn>something</fn>
</footnote>
<endnote>
<en>something</en>
</endnote>
</sam>
EOF
    setup_and_exercise 'sam'
    assert is_valid
  end
end
