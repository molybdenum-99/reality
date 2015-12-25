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
      end
    end
  end
end
