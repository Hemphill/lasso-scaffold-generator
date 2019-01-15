#$LOAD_PATH << './lib'

require 'thor'
require 'action_view'
require 'active_support'
require 'active_support/core_ext'
require 'yaml'
require_relative 'lib/helpers.rb'
# require 'optparse'
# require 'commandline/optionparser'


class ScaffoldGeneratorCLI < Thor
  include Thor::Actions
  include ActionView::Helpers::TextHelper
  include Helpers
  #include CommandLine
  
  #include ActiveSupport::Inflector

  attr_accessor :name
  #class_option :verbose, type: :boolean, default: true

  def self.source_root
    File.dirname(__FILE__)
  end
     
  desc 'scaffold NAME', 'Creates a file structure & base set of files for Lasso Modules.'
  method_option :namespace, type: :string, default: 'grocery', aliases: '-n'
  method_option :help, type: :boolean, default: false
  def scaffold(name=nil)
    if options[:help]
      exec('ruby ./generator.rb help scaffold')
    elsif name.nil?
      puts 'ERROR: Name is required, but was left blank. Please try again and supply a name for your Lasso Module.'
    else
      set_supporting_data(name)
      directory "source_files", "output/#{@plural_name}", :exclude_pattern => /.DS_Store/
    end
  end

  no_commands {
    desc nil, 'Used for creating custom file names.'
    # Used for creating custom file names.
    # Must be a public method or the directory method won't have access to it.
    def singular_name
      @singular_name
    end

    desc nil, 'Used for creating custom file names.'
    # Must be a public method or the directory method won't have access to it.
    def plural_name
      @plural_name
    end
  }
  
  private
  
  def set_supporting_data(name)
    @namespace = options[:namespace]
    @namespace += '_' unless @namespace.end_with?('_')
    @singular_name = name
    @plural_name = ActiveSupport::Inflector.pluralize(name)
    @attributes = YAML.load(File.read("data/#{@singular_name}_attributes.yml"))
    # Largest Name
    names = []
    @attributes.each do |attr|
      names << attr['name']
    end
    @largest_name = largest(names, 10)
    # Largest Default
    defaults = []
    @attributes.each do |attr|
      if attr['type'] == 'integer'
        defaults << '0' if attr['default'].blank?
        defaults << "#{attr['default']}" if !attr['default'].blank?
      elsif attr['type'] == 'boolean'
        defaults << 'false' if attr['default'].blank?
        defaults << "#{attr['default']}" if !attr['default'].blank?
      else # string
        defaults << "''" if attr['default'].blank?
        defaults << "'#{attr['default']}'" if !attr['default'].blank?
      end
    end
    @largest_default = largest(defaults, 5)
  end
  
  def largest(items, min)
    size = 0
    items.each do |item|
      size = item.size if item.size > size
    end
    size = min if !min.blank? && size < min
    size
  end
  
end

ScaffoldGeneratorCLI.start(ARGV)
