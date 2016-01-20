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

      Country.new('Narnia', page)
    end

    def wikilink(link, text = link)
      Infoboxer::Tree::Wikilink.new(link, Infoboxer::Tree::Text.new(text))
    end

    it 'parses cctld' do
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

    it 'parses population' do
      expect(country_with(
        '|population_estimate = 43,417,000<ref>[http://esa.un.org/unpd/wpp/Publications/Files/Key_Findings_WPP_2015.pdf "United Nations population prospects"](PDF) 2015 revision</ref>'
        ).population).to eq Reality::Measure(43_417_000, 'person')
      expect(country_with(
        "|population_estimate = \n|population_census = 24,383,301"
        ).population).to eq Reality::Measure(24_383_301, 'person')
      expect(country_with(
        '| population_estimate    = 50.76 million<ref name="worldbank"/>'
        ).population).to eq Reality::Measure(50_760_000, 'person')
    end

    it 'parses currency' do
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

    it 'parses long name' do
      expect(country_with("| conventional_long_name   = Republic of Costa Rica\n").long_name).
        to eq 'Republic of Costa Rica'
    end

    it 'parses languages' do
      expect(country_with('|official_languages = [[Spanish language|Spanish]]{{ref label|note-lang|a|}}').languages).
        to eq('Official' => [wikilink('Spanish language', 'Spanish')])

      expect(country_with('|languages_type = [[Official language]]s|languages = {{hlist|style=white-space:nowrap; |[[Pashto]]|[[Dari language|Dari]]}}<ref name=AO />').languages).
        to eq('Official' => [wikilink('Pashto'), wikilink('Dari language', 'Dari')])

      expect(country_with('||official_languages = None{{refn|English does not have ''[[de jure]]'' status.<ref name=language/>|name="official language"|group="N"}}|languages_type = [[National language]]|languages          = [[Australian English|English]]<ref name="official language" group="N" />').languages).
        to eq('National' => [wikilink('Australian English', 'English')])
    end

    it 'parses GDP' do
      expect(country_with(
        '|GDP_PPP={{nowrap|$11.95 billion<sup>a</sup>}}'
        ).gdp_ppp).to eq Reality::Measure(11_950_000_000, '$')

      expect(country_with(
        '|GDP_PPP = $139.059&nbsp;billion<ref name=imf2>{{cite web |url=http://www.imf.org/external/pubs/ft/weo/2014/01/weodata/weorept.aspx?pr.x=74&pr.y=0&sy=2012&ey=2014&scsm=1&ssd=1&sort=country&ds=.&br=1&c=614&s=NGDPD%2CNGDPDPC%2CPPPGDP%2CPPPPC%2CLP&grp=0&a= |title=Angola |publisher=International Monetary Fund |accessdate=26 April 2014}}</ref>'
        ).gdp_ppp).to eq Reality::Measure(139_059_000_000, '$')

      expect(country_with(
        '|GDP_PPP = US$18.535 billion'
        ).gdp_ppp).to eq Reality::Measure(18_535_000_000, '$')

      expect(country_with(
        '|GDP_nominal = {{nowrap|{{US$|1.44}} billion}}'
        ).gdp_nominal).to eq Reality::Measure(1_440_000_000, '$')

      expect(country_with(
        '|GDP_PPP = USD36&nbsp;million'
        ).gdp_ppp).to eq Reality::Measure(36_000_000, '$')
    end
  end
end
