require 'infoboxer'
require 'reality/describers/wikipedia/simplifier'

RSpec.describe Reality::Describers::Wikipedia::Simplifier do
  include Saharspec::Util
  extend Saharspec::Util

  subject { ->(source) { described_class.call(Infoboxer::Parser.fragment(source)) } }

  def n(cls, *arg)
    Infoboxer::Tree.const_get(cls).new(*arg)
  end

  def parse(src)
    Infoboxer::Parser.inline(src)
  end

  its_call('India') { is_expected.to ret [n(:Text, 'India')] }
  its_call("''Bhārat Gaṇarājya'' <!--Do NOT remove -->") { is_expected.to ret [n(:Text, 'Bhārat Gaṇarājya')] }
  its_call('{{nowrap|[[Venkaiah Naidu]]}}') {
    is_expected.to ret [n(:Wikilink, 'Venkaiah Naidu')]
  }
  its_call('3,287,263<ref name="india.gov.in2"/>') { is_expected.to ret [n(:Text, '3,287,263')] }
  its_call("{{native name|uk|Україна|italics=off}}<br />''{{small|Ukrayina}}''") {
    is_expected.to ret parse('{{native name|uk|Україна|italics=off}}')
  }
  its_call("''[[Serenity (film)|Serenity]]'' (film)") { is_expected.to ret parse('[[Serenity (film)|Serenity]]') }
  its_call(multiline(%{
    |
    |* one
    |* two
    |* three
  })) { is_expected.to ret parse('one<br/>two<br/>three') }
  its_call(multiline(%{
    |{{hlist
    ||[[Assamese language|Assamese]]
    || [[Bengali language|Bengali]]
    || [[Bodo language|Bodo]]
    |}}
  })) { is_expected.to ret parse('[[Assamese language|Assamese]]<br/>[[Bengali language|Bengali]]<br/>[[Bodo language|Bodo]]') }

  # TODO: parasite spaces
  its_call(multiline(%{
    |{{unbulleted list
    |  | 77.8% [[Ukrainians]]
    |  | 17.3% [[Russians in Ukraine|Russians]]
    |  | {{nowrap|4.9% others/unspecified}}
    | }}
  })) { is_expected.to ret parse(' 77.8% [[Ukrainians]]<br/> 17.3% [[Russians in Ukraine|Russians]]<br/>4.9% others/unspecified') }

  its_call(multiline(%{
    |{{plainlist||
    |* ''one''
    |* two
    |* three
    |}}
  })) { is_expected.to ret parse('one<br/>two<br/>three') }
  its_call(multiline(%{
    |{{unbulleted list
    ||titlestyle = background:transparent;text-align:left;font-weight:normal;
    || 84.8% [[Bulgarians]]
    || 8.8% [[Turks in Bulgaria|Turks]]
    || 4.9% [[Roma in Bulgaria|Roma]]
    || 1.5% others}}
  })) { is_expected.to ret parse(' 84.8% [[Bulgarians]]<br/> 8.8% [[Turks in Bulgaria|Turks]]<br/> 4.9% [[Roma in Bulgaria|Roma]]<br/> 1.5% others') }
end
