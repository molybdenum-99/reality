module Reality
  class TZOffset
    using Refinements
    
    attr_reader :minutes

    MINUSES = /[−—–]/

    def self.parse(text)
      text = text.gsub(MINUSES, '-')
      
      case text
      when /^[A-Z]{3}$/
        Time.zone_offset(text)
      when /^(?:UTC|GMT)?([+-]\d{1,2}:?\d{2})$/
        offset = $1
        Time.zone_offset(offset.sub(/^([+-])(\d):/, '\10\2:'))
      when /^(?:UTC|GMT)?([+-]\d{1,2})/
        $1.to_i * 3600
      end.derp{|sec| sec && new(sec / 60)}
    end
    
    def initialize(minutes)
      @minutes = minutes
    end

    def inspect
      '#<%s(UTC%+03i:%02i)>' % [self.class.name, *minutes.divmod(60)]
    end

    def to_s
      '%+03i:%02i' % minutes.divmod(60)
    end

    def <=>(other)
      other.is_a?(TZOffset) or fail ArgumentError, "Can't compare TZOffset with #{other.class}"
      minutes <=> other.minutes
    end

    include Comparable

    def now
      convert(Time.now)
    end

    def local(*values)
      values << 0 until values.count == 6
      Time.new(*values, to_s)
    end

    # FIXME: usec are lost
    def convert(tm)
      pattern = tm.utc + minutes * 60
      Time.new(
        pattern.year,
        pattern.month,
        pattern.day,
        pattern.hour,
        pattern.min,
        pattern.sec,
        to_s
      )
    end
  end
end
