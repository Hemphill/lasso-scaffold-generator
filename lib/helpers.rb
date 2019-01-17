module Helpers


  # Custom Type Helpers

  def declare_attributes(attributes, largest=@largest_name)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += declare_attribute(attr, largest)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def declare_attribute(attr, largest)
    output =  "'#{attr['name']}' "
    output += spacer(attr['name'].size, largest)
    if attr['type'] == 'integer'
      if attr['default'].blank?
        output += '= 0, '
        output += spacer(1, largest)
      else
        output += "= #{attr['default']}, "
        output += spacer(attr['default'].size, largest)
      end
    elsif attr['type'] == 'boolean'
      if attr['default'].blank?
        output += '= false, '
        output += spacer(5, largest)
      else
        output += "= #{attr['default']}, "
        output += spacer(attr['default'].size, largest)
      end
    else # string
      if attr['default'].blank?
        output += "= '', "
        output += spacer(2, largest)
      else
        output += "= '#{attr['default']}', "
        output += spacer(attr['default'].size + 2, largest)
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
    elsif attr['usage'] == 'hidden' || attr['usage'] == 'internal'
      # no input for `hidden` & `internal`
    else
      output += "-optional='#{attr['name']}'"
    end
    output
  end

  def assign_inputs(attributes, largest=@largest_name)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += assign_input(attr, largest)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def assign_input(attr, largest)
    output = ''
    output += "local_defined('#{attr['name']}')"
    output += spacer(attr['name'].size, largest)
    output += "? self->set(-#{attr['name']}#{spacer(attr['name'].size, largest)}= ##{attr['name']});"
    output
  end

  def set_attributes(attributes, largest=@largest_name)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += set_attribute(attr, largest)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def set_attribute(attr, largest)
    output = ''
    output += "local_defined('#{attr['name']}')"
    output += spacer(attr['name'].size, largest)
    output += "&& ##{attr['name']}"
    output += spacer(attr['name'].size, largest)
    output += "? self->'#{attr['name']}'#{spacer(attr['name'].size, largest)}= ##{attr['name']};"
    output
  end

  def load_fields(attributes, largest=@largest_name)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += load_field(attr, largest)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def load_field(attr, largest)
    output = ''
    output += "self->'#{attr['name']}'#{spacer(attr['name'].size, largest)}= "
    if attr['type'] == 'boolean' || attr['type'] == 'integer'
      output += "integer(field('#{attr['field']}'));"
    else
      output += "field('#{attr['field']}');"
    end
    output
  end

  def inline_params(attributes, largest=@largest_name)
    output = ''
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '          ' if loop_count > 1
      output += "-op = 'eq', \n"
      output += '          '
      output += "-#{attr['name']}#{spacer(attr['name'].size, largest)}= self->#{attr['name']}, \n"
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

