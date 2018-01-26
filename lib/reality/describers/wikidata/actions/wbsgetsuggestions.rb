# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # API module for getting suggestions of additional properties to add to a Wikibase entity. The API module is primarily intended for use by the suggester widget when users are editing Wikibase entities.
    #
    # Usage:
    #
    # ```ruby
    # api.wbsgetsuggestions.entity(value).perform # returns string with raw output
    # # or
    # api.wbsgetsuggestions.entity(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbsgetsuggestions < Reality::Describers::Wikidata::Impl::Actions::Get

      # Suggest properties for the given entity, based on existing list of properties that the entity has.
      #
      # @param value [String]
      # @return [self]
      def entity(value)
        merge(entity: value.to_s)
      end

      # Suggest additional properties for the given list of properties.
      #
      # @param values [Array<String>]
      # @return [self]
      def properties(*values)
        values.inject(self) { |res, val| res._properties(val) }
      end

      # @private
      def _properties(value)
        merge(properties: value.to_s, replace: false)
      end

      # Maximum number of results.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(limit: value.to_s)
      end

      # Offset where to continue a search.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(continue: value.to_s)
      end

      # Language for result.
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

      # Either item, reference or qualifier.
      #
      # @param value [String] One of "item", "qualifier", "reference".
      # @return [self]
      def context(value)
        _context(value) or fail ArgumentError, "Unknown value for context: #{value}"
      end

      # @private
      def _context(value)
        defined?(super) && super || ["item", "qualifier", "reference"].include?(value.to_s) && merge(context: value.to_s)
      end

      # Search for this text.
      #
      # @param value [String]
      # @return [self]
      def search(value)
        merge(search: value.to_s)
      end
    end
  end
end
