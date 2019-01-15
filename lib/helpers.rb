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
    if attr['type'] == 'string' || attr['type'] == 'String'
      output += "= '',    "
    elsif attr['type'] == 'boolean'
      output += '= false, '
    else # integer
      output += '= 0,     '
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

