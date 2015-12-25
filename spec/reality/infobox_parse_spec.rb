INFOBOX_PARSE_TEMPLATE = %Q{
{{Infobox country
|name = Neverland
%s
}}

Neverlend exists!
}

module Reality
  describe Country, 'infobox variants parsing' do
    before(:all){
      VCR.use_cassette('wikipedia-traits'){
        @traits = Infoboxer.wp.traits
      }
    }
    def country_with(lines)
      wikitext = INFOBOX_PARSE_TEMPLATE % lines
      page = Infoboxer::MediaWiki::Page.new(nil,
        Infoboxer::Parser.paragraphs(wikitext, @traits),
        double(title: 'Neverland', fullurl: 'https://en.wikipedia.org/wiki/Neverland')
        )

      Country.new(page)
    end

    context 'cctld' do
      it 'parses' do
        expect(country_with('|cctld= [[.ar]]').tld).
          to eq '.ar'
        expect(country_with('|cctld= [[.be]]<sup>c</sup>').tld).
          to eq '.be'
        expect(country_with('| cctld = [[.am]] [[.հայ]]').tld).
          to eq '.am'
        expect(country_with('| cctld = [[.am]] [[.հայ]]').tlds).
          to eq ['.am', '.հայ']
        expect(country_with('|cctld = {{unbulleted list |[[.ua]] |[[.укр]]}}').tlds).
          to eq ['.ua', '.укр']
        expect(country_with('| cctld = [[.bd]]<br />{{lang|bn|[[.bangla|.বাংলা]]}}').tlds).
          to eq ['.bd', '.bangla']
        expect(country_with("|cctld = [[.dz]]<br>''الجزائر.''").tld).
          to eq '.dz' # FIXME: ignoring second one for now
        expect(country_with(
          '|cctld = {{unbulleted list | [[.by]] | [[.бел]]<ref>{{cite web |url=http://hoster.by/about/news/1985/#.VAHIlUPjHfI |archiveurl= |publisher=hoster.by |title=ICANN сообщает о выделении кириллического домена .БЕЛ для Республики Беларусь |accessdate=30 August 2014 |archivedate= }}</ref>}}'
          ).tlds).to eq ['.by', '.бел']
        expect(country_with(
          '|cctld = [[.in]] {{collapsible list|title = other TLDs|[[.ভাৰত]] |[[.ভারত]] |[[.ભારત]] |[[.भारत]] |[[.ਭਾਰਤ]] |[[.இந்தியா]] |[[.భారత్]] |[[بھارت.]] }}'
          ).tlds).to include '.in'
      end
    end

    context 'population' do
      it 'parses' do
        expect(country_with(
          '|population_estimate = 43,417,000<ref>[http://esa.un.org/unpd/wpp/Publications/Files/Key_Findings_WPP_2015.pdf "United Nations population prospects"](PDF) 2015 revision</ref>'
          ).population).to eq Reality::Measure(43_417_000, 'person')
        expect(country_with(
          "|population_estimate = \n|population_census = 24,383,301"
          ).population).to eq Reality::Measure(24_383_301, 'person')
      end
    end

    context 'currency' do
      it 'parses' do
        expect(country_with('|currency = [[Angolan kwanza|Kwanza]]').currency).
          to eq Infoboxer::Tree::Wikilink.new('Angolan kwanza', Infoboxer::Tree::Text.new('Kwanza'))

        expect(country_with(
          '| currency = {{unbulleted list|[[Bhutanese ngultrum]] {{nowrap|([[ISO 4217|BTN]])}}|[[Indian Rupee]] {{nowrap|([[ISO 4217|INR]])}}}}'
          ).currency).
          to eq Infoboxer::Tree::Wikilink.new('Bhutanese ngultrum')

        expect(country_with(
          '| currency = {{unbulleted list|[[Bhutanese ngultrum]] {{nowrap|([[ISO 4217|BTN]])}}|[[Indian Rupee]] {{nowrap|([[ISO 4217|INR]])}}}}'
          ).currencies).
          to eq [Infoboxer::Tree::Wikilink.new('Bhutanese ngultrum'), Infoboxer::Tree::Wikilink.new('Indian Rupee')]
      end
    end
  end
end
