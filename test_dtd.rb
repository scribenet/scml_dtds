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

end
