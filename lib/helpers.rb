module Helpers


  # Custom Type Helpers

  def declare_attributes(attributes)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += declare_attribute(attr)
      output += "\n" if last > loop_count # must be double quotes
    end
    output
  end

  def declare_attribute(attr)
    output =  "'#{attr['name']}' "
    output += spacer(attr['name'].size, @largest_name)
    if attr['type'] == 'integer'
      if attr['default'].blank?
        output += '= 0, '
        output += spacer(1, @largest_default)
      else
        output += "= #{attr['default']}, "
        output += spacer(attr['default'].size, @largest_default)
      end
    elsif attr['type'] == 'boolean'
      if attr['default'].blank?
        output += '= false, '
        output += spacer(5, @largest_default)
      else
        output += "= #{attr['default']}, "
        output += spacer(attr['default'].size, @largest_default)
      end
    else # string
      if attr['default'].blank?
        output += "= '', "
        output += spacer(2, @largest_default)
      else
        output += "= '#{attr['default']}', "
        output += spacer(attr['default'].size + 2, @largest_default)
      end
    end
    output += "// #{attr['field']}" unless attr['field'].blank?
    output
  end

  # Helper Utilities

  def spacer(current, largest)
    spaces = ''
    x = largest - current
    while x >= 0
      spaces += ' '
      x = x - 1
    end
    spaces
  end

end

