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
      output += "\n" if last > loop_count # \n must be in double quotes
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

  def define_tag_inputs(attributes)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += define_tag_input(attr)
      output += ", \n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def define_tag_input(attr)
    output = ''
    if attr['usage'] == 'required'
      output += "-required='#{attr['name']}'"
    elsif attr['usage'] == 'optional' || attr['usage'] == 'virtual'
      output += "-optional='#{attr['name']}'"
    end
    output
  end

  def assign_inputs(attributes)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += assign_input(attr)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def assign_input(attr)
    output = ''
    output += "local_defined('#{attr['name']}')"
    output += spacer(attr['name'].size, @largest_name)
    output += "? self->set(-#{attr['name']}#{spacer(attr['name'].size, @largest_name)}= ##{attr['name']});"
    output
  end

  def set_attributes(attributes)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += set_attribute(attr)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def set_attribute(attr)
    output = ''
    output += "local_defined('#{attr['name']}')"
    output += spacer(attr['name'].size, @largest_name)
    output += "&& ##{attr['name']}"
    output += spacer(attr['name'].size, @largest_name)
    output += "? self->'#{attr['name']}'#{spacer(attr['name'].size, @largest_name)}= ##{attr['name']};"
    output
  end

  def load_fields(attributes)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += load_field(attr)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def load_field(attr)
    output = ''
    output += "self->'#{attr['name']}'#{spacer(attr['name'].size, @largest_name)}= "
    if attr['type'] == 'boolean' || attr['type'] == 'integer'
      output += "integer(field('#{attr['field']}'));"
    else
      output += "field('#{attr['field']}');"
    end
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

