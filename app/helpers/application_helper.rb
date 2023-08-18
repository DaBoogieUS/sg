module ApplicationHelper
  class Float
      def precision(p)
          # Make sure the precision level is actually an integer and > 0
          raise ArgumentError, "#{p} is an invalid precision level. Valid ranges are integers > 0." unless p.class == Fixnum or p < 0
          # Special case for 0 precision so it returns a Fixnum and thus doesn't have a trailing .0
          return self.round if p == 0
          # Standard case
          return (self * 10**p).round.to_f / 10**p
      end
  end

  def clean_i x
    Float(x)
    i, f = x.to_i, x.to_f
    i == f ? i : f
  rescue ArgumentError
    x
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def get_fraction(num,den)
    default = '<sup>' + num.to_s + '</sup>/<sub>' + den.to_s + '</sub>'
    return default
  end

  def get_int_string(whole,num,den)
    if whole > 0
      if num > 0
        string = whole.to_s + '' + get_fraction(num,den)
        if num == 1 && den == 1
          string = (whole + 1).to_s
        end
      else
        string = whole.to_s
      end
    elsif num > 0
      string = get_fraction(num,den)
      if num == 1 && den == 1
        string = '1'
      end
    else
      string = '0'
    end
    return string
  end

  def get_feet(i)
    feet = (i/12).floor
    remainder = (i/12) - feet
    inches = 12 * remainder.to_f
    whole,num,den = inches.to_whole_fraction
    if feet > 0
      if inches > 0
        return (feet.to_s + 'ft ' + get_int_string(whole,num,den) + 'in').html_safe
      else
        return (feet.to_s + 'ft').html_safe
      end
    else
      return (get_int_string(whole,num,den) + 'in').html_safe
    end
  end

  def get_inches(i)
    whole,num,den = i.to_whole_fraction
    int_string = get_int_string(whole,num,den)
    if int_string == ''
      int_string = '0'
    end
    return (int_string + 'in').html_safe
  end

  def get_measurements(i)
    feet = get_feet(i)
    inches = get_inches(i)
    return (feet + ' (' + inches + ')').html_safe
  end

  def get_square_inches(i)
    whole,num,den = i.to_whole_fraction
    return (get_int_string(whole,num,den) + 'in<sup>2</sup>').html_safe
  end

  def get_square_feet(i)
    # whole,num,den = (i / 144).to_whole_fraction
    return ((i/144).round(1).to_s + 'ft<sup>2</sup>').html_safe
  end

  def panel_letter(panel)
    letters = ('A'..'Z').to_a
    panel_side = letters[panel.side_position-1]
    return panel_side
  end

  def get_date(datetime)
    # now
    now_year = Time.now.utc.strftime("%Y")
    datetime = datetime.utc
    year = datetime.strftime("%Y")
    if now_year == year
      date = datetime.strftime("%b %d")
    else
      date = datetime.strftime("%^b %d, %Y")
    end
    return date
  end

  def full_time(datetime)
    time = datetime.utc.strftime("%l:%M %P")
    return get_date(datetime) + ' at ' + time
  end

end
