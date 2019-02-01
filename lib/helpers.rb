module Helpers


  # Custom Type Helpers

  def declare_attributes(attributes, largest=@largest_name, largest_default=@largest_default)
    output = ''
    last = attributes.size.to_i
    loop_count = 0
    attributes.each do |attr|
      loop_count += 1
      output += '        ' if loop_count > 1
      output += declare_attribute(attr, largest, largest_default)
      output += "\n" if last > loop_count # \n must be in double quotes
    end
    output
  end

  def declare_attribute(attr, largest, largest_default)
    output =  "'#{attr['name']}' "
    output += spacer(attr['name'].size, largest)
    if attr['type'] == 'integer'
      if attr['default'].blank?
        output += '= 0, '
        output += spacer(1, largest_default)
      else
        output += "= #{attr['default']}, "
        output += spacer(attr['default'].size, largest_default)
      end
    elsif attr['type'] == 'boolean'
      if attr['default'].blank?
        output += '= false, '
        output += spacer(5, largest_default)
      else
        output += "= #{attr['default']}, "
        output += spacer(attr['default'].size, largest_default)
      end
    else # string
      if attr['default'].blank?
        output += "= '', "
        output += spacer(2, largest_default)
      else
        output += "= '#{attr['default']}', "
        output += spacer(attr['default'].size + 2, largest_default)
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

  def inline_params(attributes, largest=@largest_name, include_operater=true, include_id=true)
    output = ''
    loop_count = 0
    skip = false
    attributes.each do |attr|
      skip = true if include_id == false && attr['name'] == 'id'
      unless include_id == false && attr['name'] == 'id'
        loop_count += 1
        output += '          ' if loop_count > 1
        if(include_operater)
          output += "-op = 'eq', "
          output += '          '
        end
        output += "'#{attr['name']}'#{spacer(attr['name'].size, largest)}= self->#{attr['name']}, \n"
      end
      skip = false
    end
    output
  end

  # Plural File Methods

  def find_by_tags(attributes)
    output = ''
    loop_count = 0
    attributes.each do |attr|
      unless attr['find_by'].blank?
        loop_count += 1
        output += '      ' if loop_count > 1
        output += find_by_tag(attr)
      end
    end
    output
  end

  def find_by_tag(attr)
    output  = "define_tag('find_by_#{attr['name']}', -required='#{attr['name']}', -optional='limit');\n"
    output += "        local_defined('limit') && #limit ? self->'limit'=#limit;\n"
    output += "        self->query('#{attr['name']}', -values=##{attr['name']}"
    output += ", -operator=##{attr['operator']}" if !attr['operator'].blank? && attr['operator'] != 'eq'
    output += ");\n"
    output += "      /define_tag;\n\n"
    output
  end

  # View Helpers

  def display_attributes(attributes)

  end

  def display_attributes(attributes)
    output = ''
    output += "<ul class='#{@singular_css_class}-attributes'>\n"
    attributes.each do |attr|
      output += '    '
      output += display_attribute(attr)
    end
    output += "    </ul>\n"
    output
  end

  def display_attribute(attr)
    output = ''
    output = '<li class="' + @singular_css_class + '-attribute ' + @singular_css_class + '-attribute-' + attr['name'].gsub("_", "-").downcase + '">' + "\n"
    output += '      '
    output += "<strong class='#{@singular_css_class}-attribute-title'>#{attr['name']}:</strong>\n"
    output += '      '
    output += "<span class='#{@singular_css_class}-#{attr['name'].gsub("_", "-").downcase}'>[self->#{attr['name']}]</span>\n"
    output += "    </li>\n"
    output
  end


  # Helper Utilities

  def spacer(current, largest)
    spaces = ''
    x = largest.to_i - current.to_i
    while x >= 0
      spaces += ' '
      x = x - 1
    end
    spaces
  end

end

