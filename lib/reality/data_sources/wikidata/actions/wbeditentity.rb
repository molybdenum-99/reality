# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Creates a single new Wikibase entity and modifies it with serialised information.
    #
    # Usage:
    #
    # ```ruby
    # api.wbeditentity.id(value).perform # returns string with raw output
    # # or
    # api.wbeditentity.id(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbeditentity < Reality::DataSources::Wikidata::Impl::Actions::Post

      # The identifier for the entity, including the prefix. Use either id or site and title together.
      #
      # @param value [String]
      # @return [self]
      def id(value)
        merge(id: value.to_s)
      end

      # If set, a new entity will be created. Set this to the type of the entity to be created. It is not allowed to have this set when id is also set.
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

      # The serialized object that is used as the data source. A newly created entity will be assigned an 'id'.
      #
      # @param value [String]
      # @return [self]
      def data(value)
        merge(data: value.to_s)
      end

      # If set, the complete entity is emptied before proceeding. The entity will not be saved before it is filled with the "data", possibly with parts excluded.
      #
      # @return [self]
      def clear()
        merge(clear: 'true')
      end
    end
  end
end
