class Date
  def inspect
    strftime('#<Date: %Y-%m-%d>')
  end
end

class Rational
  def inspect
    Reality::Util::Format.number(self)
  end
end
