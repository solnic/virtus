$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))

# original code by Ashley Moran:
# http://aviewfromafar.net/2007/11/1/rake-task-for-heckling-your-specs

begin
  require 'pathname'
  require 'backports'
  require 'active_support/inflector'
  require 'heckle'
  require 'mspec'
  require 'mspec/utils/name_map'

  SKIP_METHODS = %w[ blank_slate_method_added ].freeze

  class NameMap
    def file_name(method, constant)
      map  = MAP[method]
      name = if map
        map[constant] || map[:default]
      else
        method.gsub(/[?!=]\z/, '')
      end
      "#{name}_spec.rb"
    end
  end

  desc 'Heckle each module and class'
  task :heckle => :rcov do
    unless Ruby2Ruby::VERSION == '1.2.2'
      raise "ruby2ruby version #{Ruby2Ruby::VERSION} may not work properly, 1.2.2 *only* is recommended for use with heckle"
    end

    require 'virtus'

    root_module_regexp = Regexp.union(
      'Virtus'
    )

    spec_dir = Pathname('spec/unit')

    NameMap::MAP.each do |op, method|
      next if method.kind_of?(Hash)
      NameMap::MAP[op] = { :default => method }
    end

    aliases = Hash.new { |h,mod| h[mod] = Hash.new { |h,method| h[method] = method } }
    map     = NameMap.new

    heckle_caught_modules = Hash.new { |hash, key| hash[key] = [] }
    unhandled_mutations = 0

    ObjectSpace.each_object(Module) do |mod|
      next unless mod.name =~ /\A#{root_module_regexp}(?::|\z)/

      spec_prefix = spec_dir.join(mod.name.underscore)

      specs = []

      # get the public class methods
      metaclass  = class << mod; self end
      ancestors  = metaclass.ancestors

      spec_class_methods = mod.singleton_methods(false)

      spec_class_methods.reject! do |method|
        %w[ yaml_new yaml_tag_subclasses? included nesting constants ].include?(method.to_s)
      end

      if mod.ancestors.include?(Singleton)
        spec_class_methods.reject! { |method| method.to_s == 'instance' }
      end

      # get the protected and private class methods
      other_class_methods = metaclass.protected_instance_methods(false) |
                            metaclass.private_instance_methods(false)

      ancestors.each do |ancestor|
        other_class_methods -= ancestor.protected_instance_methods(false) |
                               ancestor.private_instance_methods(false)
      end

      other_class_methods.reject! do |method|
        method.to_s == 'allocate' || SKIP_METHODS.include?(method.to_s)
      end

      other_class_methods.reject! do |method|
        next unless spec_class_methods.any? { |specced| specced.to_s == $1 }

        spec_class_methods << method
      end

      # get the instances methods
      spec_methods = mod.public_instance_methods(false)

      other_methods = mod.protected_instance_methods(false) |
                      mod.private_instance_methods(false)

      other_methods.reject! do |method|
        next unless spec_methods.any? { |specced| specced.to_s == $1 }

        spec_methods << method
      end

      # map the class methods to spec files
      spec_class_methods.each do |method|
        method = aliases[mod.name][method]
        next if SKIP_METHODS.include?(method.to_s)

        spec_file = spec_prefix.join('class_methods').join(map.file_name(method, mod.name))

        unless spec_file.file?
          raise "No spec file #{spec_file} for #{mod}.#{method}"
          next
        end

        specs << [ ".#{method}", [ spec_file ] ]
      end

      # map the instance methods to spec files
      spec_methods.each do |method|
        method = aliases[mod.name][method]
        next if SKIP_METHODS.include?(method.to_s)

        spec_file = spec_prefix.join(map.file_name(method, mod.name))

        unless spec_file.file?
          raise "No spec file #{spec_file} for #{mod}##{method}"
          next
        end

        specs << [ "##{method}", [ spec_file ] ]
      end

      # non-public methods are considered covered if they can be mutated
      # and any spec fails for the current or descendant modules
      other_methods.each do |method|
        descedant_specs = []

        ObjectSpace.each_object(Module) do |descedant|
          next unless descedant.name =~ /\A#{root_module_regexp}(?::|\z)/ && mod >= descedant
          descedant_spec_prefix = spec_dir.join(descedant.name.underscore)
          descedant_specs << descedant_spec_prefix

          if method.to_s == 'initialize'
            descedant_specs.concat(Pathname.glob(descedant_spec_prefix.join('class_methods/new_spec.rb')))
          end
        end

        specs << [ "##{method}", descedant_specs ]
      end

      other_class_methods.each do |method|
        descedant_specs = []

        ObjectSpace.each_object(Module) do |descedant|
          next unless descedant.name =~ /\A#{root_module_regexp}(?::|\z)/ && mod >= descedant
          descedant_specs << spec_dir.join(descedant.name.underscore).join('class_methods')
        end

        specs << [ ".#{method}", descedant_specs ]
      end

      specs.sort.each do |(method, spec_files)|
        puts "Heckling #{mod}#{method}"
        IO.popen("spec #{spec_files.join(' ')} --heckle '#{mod}#{method}'") do |pipe|
          while line = pipe.gets
            case line = line.chomp
              when "The following mutations didn't cause test failures:"
                heckle_caught_modules[mod.name] << method
              when '+++ mutation'
                unhandled_mutations += 1
            end
          end
        end
      end
    end

    if unhandled_mutations > 0
      error_message_lines = [ "*************\n" ]

      error_message_lines << "Heckle found #{unhandled_mutations} " \
        "mutation#{"s" unless unhandled_mutations == 1} " \
        "that didn't cause spec violations\n"

      heckle_caught_modules.each do |mod, methods|
        error_message_lines << "#{mod} contains the following " \
          'poorly-specified methods:'
        methods.each do |method|
          error_message_lines << " - #{method}"
        end
        error_message_lines << ''
      end

      error_message_lines << 'Get your act together and come back ' \
        'when your specs are doing their job!'

      raise error_message_lines.join("\n")
    else
      puts 'Well done! Your code withstood a heckling.'
    end
  end
rescue LoadError
  task :heckle do
    abort 'Heckle or mspec is not available. In order to run heckle, you must: gem install heckle mspec'
  end
end
