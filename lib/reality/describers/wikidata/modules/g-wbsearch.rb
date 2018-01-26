# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Searches for entities using labels and aliases. This can be used as a generator for other queries. Returns the matched term that should be displayed. _Generator module: for fetching pages corresponding to request._
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::Describers::Wikidata::Impl::Actions::Query} and
    # its submodules):
    #
    # ```ruby
    # api.query             # returns Actions::Query
    #    .prop(:revisions)  # adds prop=revisions to action URL, and includes Modules::Revisions into action
    #    .limit(10)         # method of Modules::Revisions, adds rvlimit=10 to URL
    # ```
    #
    # All submodule's parameters are documented as its public methods, see below.
    #
    module GWbsearch

      # Search for this text.
      #
      # @param value [String]
      # @return [self]
      def search(value)
        merge(gwbssearch: value.to_s)
      end

      # Search in this language.
      #
      # @param value [String] One of "aa", "ab", "ace", "ady", "ady-cyrl", "aeb", "aeb-arab", "aeb-latn", "af", "ak", "aln", "als", "am", "an", "ang", "anp", "ar", "arc", "arn", "arq", "ary", "arz", "as", "ase", "ast", "atj", "av", "avk", "awa", "ay", "az", "azb", "ba", "ban", "bar", "bat-smg", "bbc", "bbc-latn", "bcc", "bcl", "be", "be-tarask", "be-x-old", "bg", "bgn", "bh", "bho", "bi", "bjn", "bm", "bn", "bo", "bpy", "bqi", "br", "brh", "bs", "bto", "bug", "bxr", "ca", "cbk-zam", "cdo", "ce", "ceb", "ch", "cho", "chr", "chy", "ckb", "co", "cps", "cr", "crh", "crh-cyrl", "crh-latn", "cs", "csb", "cu", "cv", "cy", "da", "de", "de-at", "de-ch", "de-formal", "din", "diq", "dsb", "dtp", "dty", "dv", "dz", "ee", "egl", "el", "eml", "en", "en-ca", "en-gb", "eo", "es", "et", "eu", "ext", "fa", "ff", "fi", "fit", "fiu-vro", "fj", "fo", "fr", "frc", "frp", "frr", "fur", "fy", "ga", "gag", "gan", "gan-hans", "gan-hant", "gd", "gl", "glk", "gn", "gom", "gom-deva", "gom-latn", "gor", "got", "grc", "gsw", "gu", "gv", "ha", "hak", "haw", "he", "hi", "hif", "hif-latn", "hil", "ho", "hr", "hrx", "hsb", "ht", "hu", "hy", "hz", "ia", "id", "ie", "ig", "ii", "ik", "ike-cans", "ike-latn", "ilo", "inh", "io", "is", "it", "iu", "ja", "jam", "jbo", "jut", "jv", "ka", "kaa", "kab", "kbd", "kbd-cyrl", "kea", "kg", "khw", "ki", "kiu", "kj", "kk", "kk-arab", "kk-cn", "kk-cyrl", "kk-kz", "kk-latn", "kk-tr", "kl", "km", "kn", "ko", "ko-kp", "koi", "kr", "krc", "kri", "krj", "krl", "ks", "ks-arab", "ks-deva", "ksh", "ku", "ku-arab", "ku-latn", "kv", "kw", "ky", "la", "lad", "lb", "lbe", "lez", "lfn", "lg", "li", "lij", "liv", "lki", "lmo", "ln", "lo", "loz", "lrc", "lt", "ltg", "lus", "luz", "lv", "lzh", "lzz", "mai", "map-bms", "mdf", "mg", "mh", "mhr", "mi", "min", "mk", "ml", "mn", "mo", "mr", "mrj", "ms", "mt", "mus", "mwl", "my", "myv", "mzn", "na", "nah", "nan", "nap", "nb", "nds", "nds-nl", "ne", "new", "ng", "niu", "nl", "nl-informal", "nn", "no", "nod", "nov", "nrm", "nso", "nv", "ny", "nys", "oc", "olo", "om", "or", "os", "ota", "pa", "pag", "pam", "pap", "pcd", "pdc", "pdt", "pfl", "pi", "pih", "pl", "pms", "pnb", "pnt", "prg", "ps", "pt", "pt-br", "qu", "qug", "rgn", "rif", "rm", "rmy", "rn", "ro", "roa-rup", "roa-tara", "ru", "rue", "rup", "ruq", "ruq-cyrl", "ruq-latn", "rw", "rwr", "sa", "sah", "sat", "sc", "scn", "sco", "sd", "sdc", "sdh", "se", "sei", "ses", "sg", "sgs", "sh", "shi", "shi-latn", "shi-tfng", "shn", "si", "simple", "sje", "sk", "sl", "sli", "sm", "sma", "smj", "sn", "so", "sq", "sr", "sr-ec", "sr-el", "srn", "srq", "ss", "st", "stq", "su", "sv", "sw", "szl", "ta", "tcy", "te", "tet", "tg", "tg-cyrl", "tg-latn", "th", "ti", "tk", "tl", "tly", "tn", "to", "tokipona", "tpi", "tr", "tru", "ts", "tt", "tt-cyrl", "tt-latn", "tum", "tw", "ty", "tyv", "tzm", "udm", "ug", "ug-arab", "ug-latn", "uk", "ur", "uz", "uz-cyrl", "uz-latn", "ve", "vec", "vep", "vi", "vls", "vmf", "vo", "vot", "vro", "wa", "war", "wo", "wuu", "xal", "xh", "xmf", "yi", "yo", "yue", "za", "zea", "zh", "zh-classical", "zh-cn", "zh-hans", "zh-hant", "zh-hk", "zh-min-nan", "zh-mo", "zh-my", "zh-sg", "zh-tw", "zh-yue", "zu".
      # @return [self]
      def language(value)
        _language(value) or fail ArgumentError, "Unknown value for language: #{value}"
      end

      # @private
      def _language(value)
        defined?(super) && super || ["aa", "ab", "ace", "ady", "ady-cyrl", "aeb", "aeb-arab", "aeb-latn", "af", "ak", "aln", "als", "am", "an", "ang", "anp", "ar", "arc", "arn", "arq", "ary", "arz", "as", "ase", "ast", "atj", "av", "avk", "awa", "ay", "az", "azb", "ba", "ban", "bar", "bat-smg", "bbc", "bbc-latn", "bcc", "bcl", "be", "be-tarask", "be-x-old", "bg", "bgn", "bh", "bho", "bi", "bjn", "bm", "bn", "bo", "bpy", "bqi", "br", "brh", "bs", "bto", "bug", "bxr", "ca", "cbk-zam", "cdo", "ce", "ceb", "ch", "cho", "chr", "chy", "ckb", "co", "cps", "cr", "crh", "crh-cyrl", "crh-latn", "cs", "csb", "cu", "cv", "cy", "da", "de", "de-at", "de-ch", "de-formal", "din", "diq", "dsb", "dtp", "dty", "dv", "dz", "ee", "egl", "el", "eml", "en", "en-ca", "en-gb", "eo", "es", "et", "eu", "ext", "fa", "ff", "fi", "fit", "fiu-vro", "fj", "fo", "fr", "frc", "frp", "frr", "fur", "fy", "ga", "gag", "gan", "gan-hans", "gan-hant", "gd", "gl", "glk", "gn", "gom", "gom-deva", "gom-latn", "gor", "got", "grc", "gsw", "gu", "gv", "ha", "hak", "haw", "he", "hi", "hif", "hif-latn", "hil", "ho", "hr", "hrx", "hsb", "ht", "hu", "hy", "hz", "ia", "id", "ie", "ig", "ii", "ik", "ike-cans", "ike-latn", "ilo", "inh", "io", "is", "it", "iu", "ja", "jam", "jbo", "jut", "jv", "ka", "kaa", "kab", "kbd", "kbd-cyrl", "kea", "kg", "khw", "ki", "kiu", "kj", "kk", "kk-arab", "kk-cn", "kk-cyrl", "kk-kz", "kk-latn", "kk-tr", "kl", "km", "kn", "ko", "ko-kp", "koi", "kr", "krc", "kri", "krj", "krl", "ks", "ks-arab", "ks-deva", "ksh", "ku", "ku-arab", "ku-latn", "kv", "kw", "ky", "la", "lad", "lb", "lbe", "lez", "lfn", "lg", "li", "lij", "liv", "lki", "lmo", "ln", "lo", "loz", "lrc", "lt", "ltg", "lus", "luz", "lv", "lzh", "lzz", "mai", "map-bms", "mdf", "mg", "mh", "mhr", "mi", "min", "mk", "ml", "mn", "mo", "mr", "mrj", "ms", "mt", "mus", "mwl", "my", "myv", "mzn", "na", "nah", "nan", "nap", "nb", "nds", "nds-nl", "ne", "new", "ng", "niu", "nl", "nl-informal", "nn", "no", "nod", "nov", "nrm", "nso", "nv", "ny", "nys", "oc", "olo", "om", "or", "os", "ota", "pa", "pag", "pam", "pap", "pcd", "pdc", "pdt", "pfl", "pi", "pih", "pl", "pms", "pnb", "pnt", "prg", "ps", "pt", "pt-br", "qu", "qug", "rgn", "rif", "rm", "rmy", "rn", "ro", "roa-rup", "roa-tara", "ru", "rue", "rup", "ruq", "ruq-cyrl", "ruq-latn", "rw", "rwr", "sa", "sah", "sat", "sc", "scn", "sco", "sd", "sdc", "sdh", "se", "sei", "ses", "sg", "sgs", "sh", "shi", "shi-latn", "shi-tfng", "shn", "si", "simple", "sje", "sk", "sl", "sli", "sm", "sma", "smj", "sn", "so", "sq", "sr", "sr-ec", "sr-el", "srn", "srq", "ss", "st", "stq", "su", "sv", "sw", "szl", "ta", "tcy", "te", "tet", "tg", "tg-cyrl", "tg-latn", "th", "ti", "tk", "tl", "tly", "tn", "to", "tokipona", "tpi", "tr", "tru", "ts", "tt", "tt-cyrl", "tt-latn", "tum", "tw", "ty", "tyv", "tzm", "udm", "ug", "ug-arab", "ug-latn", "uk", "ur", "uz", "uz-cyrl", "uz-latn", "ve", "vec", "vep", "vi", "vls", "vmf", "vo", "vot", "vro", "wa", "war", "wo", "wuu", "xal", "xh", "xmf", "yi", "yo", "yue", "za", "zea", "zh", "zh-classical", "zh-cn", "zh-hans", "zh-hant", "zh-hk", "zh-min-nan", "zh-mo", "zh-my", "zh-sg", "zh-tw", "zh-yue", "zu"].include?(value.to_s) && merge(gwbslanguage: value.to_s)
      end

      # Whether to disable language fallback
      #
      # @return [self]
      def strictlanguage()
        merge(gwbsstrictlanguage: 'true')
      end

      # Search for this type of entity.
      #
      # @param value [String] One of "item", "property".
      # @return [self]
      def type(value)
        _type(value) or fail ArgumentError, "Unknown value for type: #{value}"
      end

      # @private
      def _type(value)
        defined?(super) && super || ["item", "property"].include?(value.to_s) && merge(gwbstype: value.to_s)
      end

      # Maximal number of results
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gwbslimit: value.to_s)
      end
    end
  end
end
