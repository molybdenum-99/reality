module Reality
  # Simple class representing timezone offset (in minutes). Knows nothing
  # about timezone name, DST or other complications, but useful when ONLY
  # offset is known for some {Entity}.
  #
  # Usage:
  #
  # ```ruby
  # # As entity property:
  # Reality::Entity('Beijing').tz_offset
  # # => #<Reality::TZOffset(UTC+08:00)>
  #
  # # On itself:
  # o = Reality::TZOffset.parse('UTC+3')
  # # => #<Reality::TZOffset(UTC+03:00)>
  #
  # o.now
  # # => 2016-04-16 19:01:40 +0300
  # o.local(2016, 4, 1, 20, 30)
  # # => 2016-04-01 20:30:00 +0300
  # o.convert(Time.now)
  # # => 2016-04-16 19:02:22 +0300
  # ```
  #
  class TZOffset
    using Refinements

    # Number of minutes in offset.
    #
    # @return [Fixnum]
    attr_reader :minutes

    # @private
    MINUSES = /[−—–]/

    # Parses TZOffset from string. Understands several options like:
    #
    # * `GMT` (not all TZ names, only those Ruby itself knows about);
    # * `UTC+3` (or `GMT+3`);
    # * `+03:30`;
    # * ..and several combinations.
    #
    # @return [TZOffset]
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

    # Constructs offset from number of minutes. In most cases, you don't
    # want to use it, but rather {TZOffset.parse}.
    #
    # @param minutes [Fixnum] Number of minutes in offset.
    def initialize(minutes)
      @minutes = minutes
    end

    # @return [String]
    def inspect
      '#<%s(UTC%+03i:%02i)>' % [self.class.name, *minutes.divmod(60)]
    end

    # @return [String]
    def to_s
      '%+03i:%02i' % minutes.divmod(60)
    end

    # @return [Boolean]
    def <=>(other)
      other.is_a?(TZOffset) or fail ArgumentError, "Can't compare TZOffset with #{other.class}"
      minutes <=> other.minutes
    end

    include Comparable

    # Like Ruby's `Time.now`, but in desired offset.
    #
    # @return [Time] Current time in that offset.
    def now
      convert(Time.now)
    end

    # Like Ruby's `Time.local`, but in desired offset.
    #
    # @return [Time] Constructed time in that offset.
    def local(*values)
      values << 0 until values.count == 6
      Time.new(*values, to_s)
    end

    # Converts `tm` into correct offset.
    #
    # @param tm [Time] Time object to convert (with any offset);
    # @return [Time] Converted object.
    def convert(tm)
      pattern = tm.utc + minutes * 60
      # FIXME: usec are lost
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
