# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Sets the aliases for a Wikibase entity.
    #
    # Usage:
    #
    # ```ruby
    # api.wbsetaliases.id(value).perform # returns string with raw output
    # # or
    # api.wbsetaliases.id(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbsetaliases < Reality::DataSources::Wikidata::Impl::Actions::Post

      # The identifier for the entity, including the prefix. Use either id or site and title together.
      #
      # @param value [String]
      # @return [self]
      def id(value)
        merge(id: value.to_s)
      end

      # If set, a new entity will be created. Set this to the type of the entity you want to create.
      #
      # @param value [String] One of "item", "property".
      # @return [self]
      def new(value)
        _new(value) or fail ArgumentError, "Unknown value for new: #{value}"
      end

      # @private
      def _new(value)
        defined?(super) && super || ["item", "property"].include?(value.to_s) && merge(new: value.to_s)
      end

      # An identifier for the site on which the page resides. Use together with title to make a complete sitelink.
      #
      # @param value [String] One of "aawikibooks", "afwikibooks", "afwikiquote", "akwikibooks", "alswikibooks", "alswikiquote", "amwikiquote", "angwikibooks", "angwikiquote", "angwikisource", "arwikibooks", "arwikinews", "arwikiquote", "arwikisource", "arwikiversity", "astwikibooks", "astwikiquote", "aswikibooks", "aswikisource", "aywikibooks", "azwikibooks", "azwikiquote", "azwikisource", "bawikibooks", "bewikibooks", "bewikiquote", "bewikisource", "bgwikibooks", "bgwikinews", "bgwikiquote", "bgwikisource", "biwikibooks", "bmwikibooks", "bmwikiquote", "bnwikibooks", "bnwikisource", "bowikibooks", "brwikiquote", "brwikisource", "bswikibooks", "bswikinews", "bswikiquote", "bswikisource", "cawikibooks", "cawikinews", "cawikiquote", "cawikisource", "chwikibooks", "commonswiki", "cowikibooks", "cowikiquote", "crwikiquote", "cswikibooks", "cswikinews", "cswikiquote", "cswikisource", "cswikiversity", "cvwikibooks", "cywikibooks", "cywikiquote", "cywikisource", "dawikibooks", "dawikiquote", "dawikisource", "dewikibooks", "dewikinews", "dewikiquote", "dewikisource", "dewikiversity", "dewikivoyage", "elwikibooks", "elwikinews", "elwikiquote", "elwikisource", "elwikiversity", "elwikivoyage", "enwikibooks", "enwikinews", "enwikiquote", "enwikisource", "enwikiversity", "enwikivoyage", "eowikibooks", "eowikinews", "eowikiquote", "eowikisource", "eswikibooks", "eswikinews", "eswikiquote", "eswikisource", "eswikiversity", "eswikivoyage", "etwikibooks", "etwikiquote", "etwikisource", "euwikibooks", "euwikiquote", "fawikibooks", "fawikinews", "fawikiquote", "fawikisource", "fawikivoyage", "fiwikibooks", "fiwikinews", "fiwikiquote", "fiwikisource", "fiwikiversity", "fiwikivoyage", "fowikisource", "frwikibooks", "frwikinews", "frwikiquote", "frwikisource", "frwikiversity", "frwikivoyage", "fywikibooks", "gawikibooks", "gawikiquote", "glwikibooks", "glwikiquote", "glwikisource", "gnwikibooks", "gotwikibooks", "guwikibooks", "guwikiquote", "guwikisource", "hewikibooks", "hewikinews", "hewikiquote", "hewikisource", "hewikivoyage", "hiwikibooks", "hiwikiquote", "hrwikibooks", "hrwikiquote", "hrwikisource", "htwikisource", "huwikibooks", "huwikinews", "huwikiquote", "huwikisource", "hywikibooks", "hywikiquote", "hywikisource", "iawikibooks", "idwikibooks", "idwikiquote", "idwikisource", "iewikibooks", "iswikibooks", "iswikiquote", "iswikisource", "itwikibooks", "itwikinews", "itwikiquote", "itwikisource", "itwikiversity", "itwikivoyage", "jawikibooks", "jawikinews", "jawikiquote", "jawikisource", "jawikiversity", "kawikibooks", "kawikiquote", "kkwikibooks", "kkwikiquote", "kmwikibooks", "knwikibooks", "knwikiquote", "knwikisource", "kowikibooks", "kowikinews", "kowikiquote", "kowikisource", "kowikiversity", "krwikiquote", "kswikibooks", "kswikiquote", "kuwikibooks", "kuwikiquote", "kwwikiquote", "kywikibooks", "kywikiquote", "lawikibooks", "lawikiquote", "lawikisource", "lbwikibooks", "lbwikiquote", "liwikibooks", "liwikiquote", "liwikisource", "lnwikibooks", "ltwikibooks", "ltwikiquote", "ltwikisource", "lvwikibooks", "mediawikiwiki", "metawiki", "mgwikibooks", "miwikibooks", "mkwikibooks", "mkwikisource", "mlwikibooks", "mlwikiquote", "mlwikisource", "mnwikibooks", "mrwikibooks", "mrwikiquote", "mrwikisource", "mswikibooks", "mywikibooks", "nahwikibooks", "nawikibooks", "nawikiquote", "ndswikibooks", "ndswikiquote", "newikibooks", "nlwikibooks", "nlwikinews", "nlwikiquote", "nlwikisource", "nlwikivoyage", "nnwikiquote", "nowikibooks", "nowikinews", "nowikiquote", "nowikisource", "ocwikibooks", "orwikisource", "pawikibooks", "pawikisource", "plwikibooks", "plwikinews", "plwikiquote", "plwikisource", "plwikivoyage", "pswikibooks", "ptwikibooks", "ptwikinews", "ptwikiquote", "ptwikisource", "ptwikiversity", "ptwikivoyage", "quwikibooks", "quwikiquote", "rmwikibooks", "rowikibooks", "rowikinews", "rowikiquote", "rowikisource", "rowikivoyage", "ruwikibooks", "ruwikinews", "ruwikiquote", "ruwikisource", "ruwikiversity", "ruwikivoyage", "sahwikisource", "sawikibooks", "sawikiquote", "sawikisource", "sdwikinews", "sewikibooks", "simplewikibooks", "simplewikiquote", "siwikibooks", "skwikibooks", "skwikiquote", "skwikisource", "slwikibooks", "slwikiquote", "slwikisource", "slwikiversity", "specieswiki", "sqwikibooks", "sqwikinews", "sqwikiquote", "srwikibooks", "srwikinews", "srwikiquote", "srwikisource", "suwikibooks", "suwikiquote", "svwikibooks", "svwikinews", "svwikiquote", "svwikisource", "svwikiversity", "svwikivoyage", "swwikibooks", "tawikibooks", "tawikinews", "tawikiquote", "tawikisource", "tewikibooks", "tewikiquote", "tewikisource", "tgwikibooks", "thwikibooks", "thwikinews", "thwikiquote", "thwikisource", "tkwikibooks", "tkwikiquote", "tlwikibooks", "trwikibooks", "trwikinews", "trwikiquote", "trwikisource", "ttwikibooks", "ttwikiquote", "ugwikibooks", "ugwikiquote", "ukwikibooks", "ukwikinews", "ukwikiquote", "ukwikisource", "ukwikivoyage", "urwikibooks", "urwikiquote", "uzwikibooks", "uzwikiquote", "vecwikisource", "viwikibooks", "viwikiquote", "viwikisource", "viwikivoyage", "vowikibooks", "vowikiquote", "wawikibooks", "wikidatawiki", "wowikiquote", "xhwikibooks", "yiwikisource", "yowikibooks", "zawikibooks", "zawikiquote", "zh_min_nanwikibooks", "zh_min_nanwikiquote", "zh_min_nanwikisource", "zhwikibooks", "zhwikinews", "zhwikiquote", "zhwikisource", "zhwikivoyage", "zuwikibooks", "aawiki", "abwiki", "acewiki", "afwiki", "akwiki", "alswiki", "amwiki", "anwiki", "angwiki", "arwiki", "arcwiki", "arzwiki", "aswiki", "astwiki", "avwiki", "aywiki", "azwiki", "bawiki", "barwiki", "bat_smgwiki", "bclwiki", "bewiki", "be_x_oldwiki", "bgwiki", "bhwiki", "biwiki", "bjnwiki", "bmwiki", "bnwiki", "bowiki", "bpywiki", "brwiki", "bswiki", "bugwiki", "bxrwiki", "cawiki", "cbk_zamwiki", "cdowiki", "cewiki", "cebwiki", "chwiki", "chowiki", "chrwiki", "chywiki", "ckbwiki", "cowiki", "crwiki", "crhwiki", "cswiki", "csbwiki", "cuwiki", "cvwiki", "cywiki", "dawiki", "dewiki", "diqwiki", "dsbwiki", "dvwiki", "dzwiki", "eewiki", "elwiki", "emlwiki", "enwiki", "eowiki", "eswiki", "etwiki", "euwiki", "extwiki", "fawiki", "ffwiki", "fiwiki", "fiu_vrowiki", "fjwiki", "fowiki", "frwiki", "frpwiki", "frrwiki", "furwiki", "fywiki", "gawiki", "gagwiki", "ganwiki", "gdwiki", "glwiki", "glkwiki", "gnwiki", "gotwiki", "guwiki", "gvwiki", "hawiki", "hakwiki", "hawwiki", "hewiki", "hiwiki", "hifwiki", "howiki", "hrwiki", "hsbwiki", "htwiki", "huwiki", "hywiki", "hzwiki", "iawiki", "idwiki", "iewiki", "igwiki", "iiwiki", "ikwiki", "ilowiki", "iowiki", "iswiki", "itwiki", "iuwiki", "jawiki", "jbowiki", "jvwiki", "kawiki", "kaawiki", "kabwiki", "kbdwiki", "kgwiki", "kiwiki", "kjwiki", "kkwiki", "klwiki", "kmwiki", "knwiki", "kowiki", "koiwiki", "krwiki", "krcwiki", "kswiki", "kshwiki", "kuwiki", "kvwiki", "kwwiki", "kywiki", "lawiki", "ladwiki", "lbwiki", "lbewiki", "lezwiki", "lgwiki", "liwiki", "lijwiki", "lmowiki", "lnwiki", "lowiki", "ltwiki", "ltgwiki", "lvwiki", "maiwiki", "map_bmswiki", "mdfwiki", "mgwiki", "mhwiki", "mhrwiki", "miwiki", "minwiki", "mkwiki", "mlwiki", "mnwiki", "mowiki", "mrwiki", "mrjwiki", "mswiki", "mtwiki", "muswiki", "mwlwiki", "mywiki", "myvwiki", "mznwiki", "nawiki", "nahwiki", "napwiki", "ndswiki", "nds_nlwiki", "newiki", "newwiki", "ngwiki", "nlwiki", "nnwiki", "nowiki", "novwiki", "nrmwiki", "nsowiki", "nvwiki", "nywiki", "ocwiki", "omwiki", "orwiki", "oswiki", "pawiki", "pagwiki", "pamwiki", "papwiki", "pcdwiki", "pdcwiki", "pflwiki", "piwiki", "pihwiki", "plwiki", "pmswiki", "pnbwiki", "pntwiki", "pswiki", "ptwiki", "quwiki", "rmwiki", "rmywiki", "rnwiki", "rowiki", "roa_rupwiki", "roa_tarawiki", "ruwiki", "ruewiki", "rwwiki", "sawiki", "sahwiki", "scwiki", "scnwiki", "scowiki", "sdwiki", "sewiki", "sgwiki", "shwiki", "siwiki", "simplewiki", "skwiki", "slwiki", "smwiki", "snwiki", "sowiki", "sqwiki", "srwiki", "srnwiki", "sswiki", "stwiki", "stqwiki", "suwiki", "svwiki", "swwiki", "szlwiki", "tawiki", "tewiki", "tetwiki", "tgwiki", "thwiki", "tiwiki", "tkwiki", "tlwiki", "tnwiki", "towiki", "tpiwiki", "trwiki", "tswiki", "ttwiki", "tumwiki", "twwiki", "tywiki", "tyvwiki", "udmwiki", "ugwiki", "ukwiki", "urwiki", "uzwiki", "vewiki", "vecwiki", "vepwiki", "viwiki", "vlswiki", "vowiki", "wawiki", "warwiki", "wowiki", "wuuwiki", "xalwiki", "xhwiki", "xmfwiki", "yiwiki", "yowiki", "zawiki", "zeawiki", "zhwiki", "zh_classicalwiki", "zh_min_nanwiki", "zh_yuewiki", "zuwiki", "lrcwiki", "gomwiki", "azbwiki", "adywiki", "jamwiki", "tcywiki", "olowiki", "dtywiki".
      # @return [self]
      def site(value)
        _site(value) or fail ArgumentError, "Unknown value for site: #{value}"
      end

      # @private
      def _site(value)
        defined?(super) && super || ["aawikibooks", "afwikibooks", "afwikiquote", "akwikibooks", "alswikibooks", "alswikiquote", "amwikiquote", "angwikibooks", "angwikiquote", "angwikisource", "arwikibooks", "arwikinews", "arwikiquote", "arwikisource", "arwikiversity", "astwikibooks", "astwikiquote", "aswikibooks", "aswikisource", "aywikibooks", "azwikibooks", "azwikiquote", "azwikisource", "bawikibooks", "bewikibooks", "bewikiquote", "bewikisource", "bgwikibooks", "bgwikinews", "bgwikiquote", "bgwikisource", "biwikibooks", "bmwikibooks", "bmwikiquote", "bnwikibooks", "bnwikisource", "bowikibooks", "brwikiquote", "brwikisource", "bswikibooks", "bswikinews", "bswikiquote", "bswikisource", "cawikibooks", "cawikinews", "cawikiquote", "cawikisource", "chwikibooks", "commonswiki", "cowikibooks", "cowikiquote", "crwikiquote", "cswikibooks", "cswikinews", "cswikiquote", "cswikisource", "cswikiversity", "cvwikibooks", "cywikibooks", "cywikiquote", "cywikisource", "dawikibooks", "dawikiquote", "dawikisource", "dewikibooks", "dewikinews", "dewikiquote", "dewikisource", "dewikiversity", "dewikivoyage", "elwikibooks", "elwikinews", "elwikiquote", "elwikisource", "elwikiversity", "elwikivoyage", "enwikibooks", "enwikinews", "enwikiquote", "enwikisource", "enwikiversity", "enwikivoyage", "eowikibooks", "eowikinews", "eowikiquote", "eowikisource", "eswikibooks", "eswikinews", "eswikiquote", "eswikisource", "eswikiversity", "eswikivoyage", "etwikibooks", "etwikiquote", "etwikisource", "euwikibooks", "euwikiquote", "fawikibooks", "fawikinews", "fawikiquote", "fawikisource", "fawikivoyage", "fiwikibooks", "fiwikinews", "fiwikiquote", "fiwikisource", "fiwikiversity", "fiwikivoyage", "fowikisource", "frwikibooks", "frwikinews", "frwikiquote", "frwikisource", "frwikiversity", "frwikivoyage", "fywikibooks", "gawikibooks", "gawikiquote", "glwikibooks", "glwikiquote", "glwikisource", "gnwikibooks", "gotwikibooks", "guwikibooks", "guwikiquote", "guwikisource", "hewikibooks", "hewikinews", "hewikiquote", "hewikisource", "hewikivoyage", "hiwikibooks", "hiwikiquote", "hrwikibooks", "hrwikiquote", "hrwikisource", "htwikisource", "huwikibooks", "huwikinews", "huwikiquote", "huwikisource", "hywikibooks", "hywikiquote", "hywikisource", "iawikibooks", "idwikibooks", "idwikiquote", "idwikisource", "iewikibooks", "iswikibooks", "iswikiquote", "iswikisource", "itwikibooks", "itwikinews", "itwikiquote", "itwikisource", "itwikiversity", "itwikivoyage", "jawikibooks", "jawikinews", "jawikiquote", "jawikisource", "jawikiversity", "kawikibooks", "kawikiquote", "kkwikibooks", "kkwikiquote", "kmwikibooks", "knwikibooks", "knwikiquote", "knwikisource", "kowikibooks", "kowikinews", "kowikiquote", "kowikisource", "kowikiversity", "krwikiquote", "kswikibooks", "kswikiquote", "kuwikibooks", "kuwikiquote", "kwwikiquote", "kywikibooks", "kywikiquote", "lawikibooks", "lawikiquote", "lawikisource", "lbwikibooks", "lbwikiquote", "liwikibooks", "liwikiquote", "liwikisource", "lnwikibooks", "ltwikibooks", "ltwikiquote", "ltwikisource", "lvwikibooks", "mediawikiwiki", "metawiki", "mgwikibooks", "miwikibooks", "mkwikibooks", "mkwikisource", "mlwikibooks", "mlwikiquote", "mlwikisource", "mnwikibooks", "mrwikibooks", "mrwikiquote", "mrwikisource", "mswikibooks", "mywikibooks", "nahwikibooks", "nawikibooks", "nawikiquote", "ndswikibooks", "ndswikiquote", "newikibooks", "nlwikibooks", "nlwikinews", "nlwikiquote", "nlwikisource", "nlwikivoyage", "nnwikiquote", "nowikibooks", "nowikinews", "nowikiquote", "nowikisource", "ocwikibooks", "orwikisource", "pawikibooks", "pawikisource", "plwikibooks", "plwikinews", "plwikiquote", "plwikisource", "plwikivoyage", "pswikibooks", "ptwikibooks", "ptwikinews", "ptwikiquote", "ptwikisource", "ptwikiversity", "ptwikivoyage", "quwikibooks", "quwikiquote", "rmwikibooks", "rowikibooks", "rowikinews", "rowikiquote", "rowikisource", "rowikivoyage", "ruwikibooks", "ruwikinews", "ruwikiquote", "ruwikisource", "ruwikiversity", "ruwikivoyage", "sahwikisource", "sawikibooks", "sawikiquote", "sawikisource", "sdwikinews", "sewikibooks", "simplewikibooks", "simplewikiquote", "siwikibooks", "skwikibooks", "skwikiquote", "skwikisource", "slwikibooks", "slwikiquote", "slwikisource", "slwikiversity", "specieswiki", "sqwikibooks", "sqwikinews", "sqwikiquote", "srwikibooks", "srwikinews", "srwikiquote", "srwikisource", "suwikibooks", "suwikiquote", "svwikibooks", "svwikinews", "svwikiquote", "svwikisource", "svwikiversity", "svwikivoyage", "swwikibooks", "tawikibooks", "tawikinews", "tawikiquote", "tawikisource", "tewikibooks", "tewikiquote", "tewikisource", "tgwikibooks", "thwikibooks", "thwikinews", "thwikiquote", "thwikisource", "tkwikibooks", "tkwikiquote", "tlwikibooks", "trwikibooks", "trwikinews", "trwikiquote", "trwikisource", "ttwikibooks", "ttwikiquote", "ugwikibooks", "ugwikiquote", "ukwikibooks", "ukwikinews", "ukwikiquote", "ukwikisource", "ukwikivoyage", "urwikibooks", "urwikiquote", "uzwikibooks", "uzwikiquote", "vecwikisource", "viwikibooks", "viwikiquote", "viwikisource", "viwikivoyage", "vowikibooks", "vowikiquote", "wawikibooks", "wikidatawiki", "wowikiquote", "xhwikibooks", "yiwikisource", "yowikibooks", "zawikibooks", "zawikiquote", "zh_min_nanwikibooks", "zh_min_nanwikiquote", "zh_min_nanwikisource", "zhwikibooks", "zhwikinews", "zhwikiquote", "zhwikisource", "zhwikivoyage", "zuwikibooks", "aawiki", "abwiki", "acewiki", "afwiki", "akwiki", "alswiki", "amwiki", "anwiki", "angwiki", "arwiki", "arcwiki", "arzwiki", "aswiki", "astwiki", "avwiki", "aywiki", "azwiki", "bawiki", "barwiki", "bat_smgwiki", "bclwiki", "bewiki", "be_x_oldwiki", "bgwiki", "bhwiki", "biwiki", "bjnwiki", "bmwiki", "bnwiki", "bowiki", "bpywiki", "brwiki", "bswiki", "bugwiki", "bxrwiki", "cawiki", "cbk_zamwiki", "cdowiki", "cewiki", "cebwiki", "chwiki", "chowiki", "chrwiki", "chywiki", "ckbwiki", "cowiki", "crwiki", "crhwiki", "cswiki", "csbwiki", "cuwiki", "cvwiki", "cywiki", "dawiki", "dewiki", "diqwiki", "dsbwiki", "dvwiki", "dzwiki", "eewiki", "elwiki", "emlwiki", "enwiki", "eowiki", "eswiki", "etwiki", "euwiki", "extwiki", "fawiki", "ffwiki", "fiwiki", "fiu_vrowiki", "fjwiki", "fowiki", "frwiki", "frpwiki", "frrwiki", "furwiki", "fywiki", "gawiki", "gagwiki", "ganwiki", "gdwiki", "glwiki", "glkwiki", "gnwiki", "gotwiki", "guwiki", "gvwiki", "hawiki", "hakwiki", "hawwiki", "hewiki", "hiwiki", "hifwiki", "howiki", "hrwiki", "hsbwiki", "htwiki", "huwiki", "hywiki", "hzwiki", "iawiki", "idwiki", "iewiki", "igwiki", "iiwiki", "ikwiki", "ilowiki", "iowiki", "iswiki", "itwiki", "iuwiki", "jawiki", "jbowiki", "jvwiki", "kawiki", "kaawiki", "kabwiki", "kbdwiki", "kgwiki", "kiwiki", "kjwiki", "kkwiki", "klwiki", "kmwiki", "knwiki", "kowiki", "koiwiki", "krwiki", "krcwiki", "kswiki", "kshwiki", "kuwiki", "kvwiki", "kwwiki", "kywiki", "lawiki", "ladwiki", "lbwiki", "lbewiki", "lezwiki", "lgwiki", "liwiki", "lijwiki", "lmowiki", "lnwiki", "lowiki", "ltwiki", "ltgwiki", "lvwiki", "maiwiki", "map_bmswiki", "mdfwiki", "mgwiki", "mhwiki", "mhrwiki", "miwiki", "minwiki", "mkwiki", "mlwiki", "mnwiki", "mowiki", "mrwiki", "mrjwiki", "mswiki", "mtwiki", "muswiki", "mwlwiki", "mywiki", "myvwiki", "mznwiki", "nawiki", "nahwiki", "napwiki", "ndswiki", "nds_nlwiki", "newiki", "newwiki", "ngwiki", "nlwiki", "nnwiki", "nowiki", "novwiki", "nrmwiki", "nsowiki", "nvwiki", "nywiki", "ocwiki", "omwiki", "orwiki", "oswiki", "pawiki", "pagwiki", "pamwiki", "papwiki", "pcdwiki", "pdcwiki", "pflwiki", "piwiki", "pihwiki", "plwiki", "pmswiki", "pnbwiki", "pntwiki", "pswiki", "ptwiki", "quwiki", "rmwiki", "rmywiki", "rnwiki", "rowiki", "roa_rupwiki", "roa_tarawiki", "ruwiki", "ruewiki", "rwwiki", "sawiki", "sahwiki", "scwiki", "scnwiki", "scowiki", "sdwiki", "sewiki", "sgwiki", "shwiki", "siwiki", "simplewiki", "skwiki", "slwiki", "smwiki", "snwiki", "sowiki", "sqwiki", "srwiki", "srnwiki", "sswiki", "stwiki", "stqwiki", "suwiki", "svwiki", "swwiki", "szlwiki", "tawiki", "tewiki", "tetwiki", "tgwiki", "thwiki", "tiwiki", "tkwiki", "tlwiki", "tnwiki", "towiki", "tpiwiki", "trwiki", "tswiki", "ttwiki", "tumwiki", "twwiki", "tywiki", "tyvwiki", "udmwiki", "ugwiki", "ukwiki", "urwiki", "uzwiki", "vewiki", "vecwiki", "vepwiki", "viwiki", "vlswiki", "vowiki", "wawiki", "warwiki", "wowiki", "wuuwiki", "xalwiki", "xhwiki", "xmfwiki", "yiwiki", "yowiki", "zawiki", "zeawiki", "zhwiki", "zh_classicalwiki", "zh_min_nanwiki", "zh_yuewiki", "zuwiki", "lrcwiki", "gomwiki", "azbwiki", "adywiki", "jamwiki", "tcywiki", "olowiki", "dtywiki"].include?(value.to_s) && merge(site: value.to_s)
      end

      # Title of the page to associate. Use together with site to make a complete sitelink.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # The numeric identifier for the revision to base the modification on. This is used for detecting conflicts during save.
      #
      # @param value [Integer]
      # @return [self]
      def baserevid(value)
        merge(baserevid: value.to_s)
      end

      # Summary for the edit. Will be prepended by an automatically generated comment. The length limit of the autocomment together with the summary is 260 characters. Be aware that everything above that limit will be cut off.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Mark this edit as bot. This URL flag will only be respected if the user belongs to the group "Bots".
      #
      # @return [self]
      def bot()
        merge(bot: 'true')
      end

      # List of aliases to add (can be combined with remove)
      #
      # @param values [Array<String>]
      # @return [self]
      def add(*values)
        values.inject(self) { |res, val| res._add(val) }
      end

      # @private
      def _add(value)
        merge(add: value.to_s, replace: false)
      end

      # List of aliases to remove (can be combined with add)
      #
      # @param values [Array<String>]
      # @return [self]
      def remove(*values)
        values.inject(self) { |res, val| res._remove(val) }
      end

      # @private
      def _remove(value)
        merge(remove: value.to_s, replace: false)
      end

      # A list of aliases that will replace the current list (cannot be combined with neither add nor remove)
      #
      # @param values [Array<String>]
      # @return [self]
      def set(*values)
        values.inject(self) { |res, val| res._set(val) }
      end

      # @private
      def _set(value)
        merge(set: value.to_s, replace: false)
      end

      # The language for which to set the aliases
      #
      # @param value [String] One of "aa", "ab", "ace", "ady", "ady-cyrl", "aeb", "aeb-arab", "aeb-latn", "af", "ak", "aln", "als", "am", "an", "ang", "anp", "ar", "arc", "arn", "arq", "ary", "arz", "as", "ase", "ast", "atj", "av", "avk", "awa", "ay", "az", "azb", "ba", "ban", "bar", "bat-smg", "bbc", "bbc-latn", "bcc", "bcl", "be", "be-tarask", "be-x-old", "bg", "bgn", "bh", "bho", "bi", "bjn", "bm", "bn", "bo", "bpy", "bqi", "br", "brh", "bs", "bto", "bug", "bxr", "ca", "cbk-zam", "cdo", "ce", "ceb", "ch", "cho", "chr", "chy", "ckb", "co", "cps", "cr", "crh", "crh-cyrl", "crh-latn", "cs", "csb", "cu", "cv", "cy", "da", "de", "de-at", "de-ch", "de-formal", "din", "diq", "dsb", "dtp", "dty", "dv", "dz", "ee", "egl", "el", "eml", "en", "en-ca", "en-gb", "eo", "es", "et", "eu", "ext", "fa", "ff", "fi", "fit", "fiu-vro", "fj", "fo", "fr", "frc", "frp", "frr", "fur", "fy", "ga", "gag", "gan", "gan-hans", "gan-hant", "gd", "gl", "glk", "gn", "gom", "gom-deva", "gom-latn", "gor", "got", "grc", "gsw", "gu", "gv", "ha", "hak", "haw", "he", "hi", "hif", "hif-latn", "hil", "ho", "hr", "hrx", "hsb", "ht", "hu", "hy", "hz", "ia", "id", "ie", "ig", "ii", "ik", "ike-cans", "ike-latn", "ilo", "inh", "io", "is", "it", "iu", "ja", "jam", "jbo", "jut", "jv", "ka", "kaa", "kab", "kbd", "kbd-cyrl", "kea", "kg", "khw", "ki", "kiu", "kj", "kk", "kk-arab", "kk-cn", "kk-cyrl", "kk-kz", "kk-latn", "kk-tr", "kl", "km", "kn", "ko", "ko-kp", "koi", "kr", "krc", "kri", "krj", "krl", "ks", "ks-arab", "ks-deva", "ksh", "ku", "ku-arab", "ku-latn", "kv", "kw", "ky", "la", "lad", "lb", "lbe", "lez", "lfn", "lg", "li", "lij", "liv", "lki", "lmo", "ln", "lo", "loz", "lrc", "lt", "ltg", "lus", "luz", "lv", "lzh", "lzz", "mai", "map-bms", "mdf", "mg", "mh", "mhr", "mi", "min", "mk", "ml", "mn", "mo", "mr", "mrj", "ms", "mt", "mus", "mwl", "my", "myv", "mzn", "na", "nah", "nan", "nap", "nb", "nds", "nds-nl", "ne", "new", "ng", "niu", "nl", "nl-informal", "nn", "no", "nod", "nov", "nrm", "nso", "nv", "ny", "nys", "oc", "olo", "om", "or", "os", "ota", "pa", "pag", "pam", "pap", "pcd", "pdc", "pdt", "pfl", "pi", "pih", "pl", "pms", "pnb", "pnt", "prg", "ps", "pt", "pt-br", "qu", "qug", "rgn", "rif", "rm", "rmy", "rn", "ro", "roa-rup", "roa-tara", "ru", "rue", "rup", "ruq", "ruq-cyrl", "ruq-latn", "rw", "rwr", "sa", "sah", "sat", "sc", "scn", "sco", "sd", "sdc", "sdh", "se", "sei", "ses", "sg", "sgs", "sh", "shi", "shi-latn", "shi-tfng", "shn", "si", "simple", "sje", "sk", "sl", "sli", "sm", "sma", "smj", "sn", "so", "sq", "sr", "sr-ec", "sr-el", "srn", "srq", "ss", "st", "stq", "su", "sv", "sw", "szl", "ta", "tcy", "te", "tet", "tg", "tg-cyrl", "tg-latn", "th", "ti", "tk", "tl", "tly", "tn", "to", "tokipona", "tpi", "tr", "tru", "ts", "tt", "tt-cyrl", "tt-latn", "tum", "tw", "ty", "tyv", "tzm", "udm", "ug", "ug-arab", "ug-latn", "uk", "ur", "uz", "uz-cyrl", "uz-latn", "ve", "vec", "vep", "vi", "vls", "vmf", "vo", "vot", "vro", "wa", "war", "wo", "wuu", "xal", "xh", "xmf", "yi", "yo", "yue", "za", "zea", "zh", "zh-classical", "zh-cn", "zh-hans", "zh-hant", "zh-hk", "zh-min-nan", "zh-mo", "zh-my", "zh-sg", "zh-tw", "zh-yue", "zu".
      # @return [self]
      def language(value)
        _language(value) or fail ArgumentError, "Unknown value for language: #{value}"
      end

      # @private
      def _language(value)
        defined?(super) && super || ["aa", "ab", "ace", "ady", "ady-cyrl", "aeb", "aeb-arab", "aeb-latn", "af", "ak", "aln", "als", "am", "an", "ang", "anp", "ar", "arc", "arn", "arq", "ary", "arz", "as", "ase", "ast", "atj", "av", "avk", "awa", "ay", "az", "azb", "ba", "ban", "bar", "bat-smg", "bbc", "bbc-latn", "bcc", "bcl", "be", "be-tarask", "be-x-old", "bg", "bgn", "bh", "bho", "bi", "bjn", "bm", "bn", "bo", "bpy", "bqi", "br", "brh", "bs", "bto", "bug", "bxr", "ca", "cbk-zam", "cdo", "ce", "ceb", "ch", "cho", "chr", "chy", "ckb", "co", "cps", "cr", "crh", "crh-cyrl", "crh-latn", "cs", "csb", "cu", "cv", "cy", "da", "de", "de-at", "de-ch", "de-formal", "din", "diq", "dsb", "dtp", "dty", "dv", "dz", "ee", "egl", "el", "eml", "en", "en-ca", "en-gb", "eo", "es", "et", "eu", "ext", "fa", "ff", "fi", "fit", "fiu-vro", "fj", "fo", "fr", "frc", "frp", "frr", "fur", "fy", "ga", "gag", "gan", "gan-hans", "gan-hant", "gd", "gl", "glk", "gn", "gom", "gom-deva", "gom-latn", "gor", "got", "grc", "gsw", "gu", "gv", "ha", "hak", "haw", "he", "hi", "hif", "hif-latn", "hil", "ho", "hr", "hrx", "hsb", "ht", "hu", "hy", "hz", "ia", "id", "ie", "ig", "ii", "ik", "ike-cans", "ike-latn", "ilo", "inh", "io", "is", "it", "iu", "ja", "jam", "jbo", "jut", "jv", "ka", "kaa", "kab", "kbd", "kbd-cyrl", "kea", "kg", "khw", "ki", "kiu", "kj", "kk", "kk-arab", "kk-cn", "kk-cyrl", "kk-kz", "kk-latn", "kk-tr", "kl", "km", "kn", "ko", "ko-kp", "koi", "kr", "krc", "kri", "krj", "krl", "ks", "ks-arab", "ks-deva", "ksh", "ku", "ku-arab", "ku-latn", "kv", "kw", "ky", "la", "lad", "lb", "lbe", "lez", "lfn", "lg", "li", "lij", "liv", "lki", "lmo", "ln", "lo", "loz", "lrc", "lt", "ltg", "lus", "luz", "lv", "lzh", "lzz", "mai", "map-bms", "mdf", "mg", "mh", "mhr", "mi", "min", "mk", "ml", "mn", "mo", "mr", "mrj", "ms", "mt", "mus", "mwl", "my", "myv", "mzn", "na", "nah", "nan", "nap", "nb", "nds", "nds-nl", "ne", "new", "ng", "niu", "nl", "nl-informal", "nn", "no", "nod", "nov", "nrm", "nso", "nv", "ny", "nys", "oc", "olo", "om", "or", "os", "ota", "pa", "pag", "pam", "pap", "pcd", "pdc", "pdt", "pfl", "pi", "pih", "pl", "pms", "pnb", "pnt", "prg", "ps", "pt", "pt-br", "qu", "qug", "rgn", "rif", "rm", "rmy", "rn", "ro", "roa-rup", "roa-tara", "ru", "rue", "rup", "ruq", "ruq-cyrl", "ruq-latn", "rw", "rwr", "sa", "sah", "sat", "sc", "scn", "sco", "sd", "sdc", "sdh", "se", "sei", "ses", "sg", "sgs", "sh", "shi", "shi-latn", "shi-tfng", "shn", "si", "simple", "sje", "sk", "sl", "sli", "sm", "sma", "smj", "sn", "so", "sq", "sr", "sr-ec", "sr-el", "srn", "srq", "ss", "st", "stq", "su", "sv", "sw", "szl", "ta", "tcy", "te", "tet", "tg", "tg-cyrl", "tg-latn", "th", "ti", "tk", "tl", "tly", "tn", "to", "tokipona", "tpi", "tr", "tru", "ts", "tt", "tt-cyrl", "tt-latn", "tum", "tw", "ty", "tyv", "tzm", "udm", "ug", "ug-arab", "ug-latn", "uk", "ur", "uz", "uz-cyrl", "uz-latn", "ve", "vec", "vep", "vi", "vls", "vmf", "vo", "vot", "vro", "wa", "war", "wo", "wuu", "xal", "xh", "xmf", "yi", "yo", "yue", "za", "zea", "zh", "zh-classical", "zh-cn", "zh-hans", "zh-hant", "zh-hk", "zh-min-nan", "zh-mo", "zh-my", "zh-sg", "zh-tw", "zh-yue", "zu"].include?(value.to_s) && merge(language: value.to_s)
      end
    end
  end
end
