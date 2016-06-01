module STARMAN
  module Command
    class Shell
      def self.accepted_options
        {
          :'update-config' => OptionSpec.new(
            desc: 'Update the shell configuration file.',
            accept_value: { boolean: false }
          ),
          :'compiler-set' => OptionSpec.new(
            desc: 'Choose which compiler set to be active.',
            accept_value: { integer: -1 }
          )
        }
      end

      def self.run
        if CommandLine.options[:'compiler-set'].value == -1
          CommandLine.options[:'compiler-set'].check ConfigStore.defaults[:compiler_set_index]
        end
        CompilerStore.set_active_compiler_set CommandLine.options[:'compiler-set'].value
        System::Shell.reset_rc_file
        if CommandLine.options[:'update-config'].value
          DirtyWorks.handle_absent_compiler PackageLoader.installed_packages
          DirtyWorks.remove_slave_packages PackageLoader.installed_packages
          FileUtils.rm_f System::Shell.rc_file
          FileUtils.touch System::Shell.rc_file
          PackageLoader.installed_packages.each_value do |package|
            if not Dir.exist? package.prefix
              CLI.report_warning "Package #{CLI.red package.name} wasn't installed by the current options.\n" +
                "Possible options:\n#{Package.print_options(package, indent: 2).chomp}"
            end
            System::Shell.prepend 'PATH', package.bin, separator: ':', system: true if Dir.exist? package.bin
            System::Shell.prepend OS.ld_library_path, package.lib, separator: ':', system: true if Dir.exist? package.lib and not package.has_label? :system_conflict
            System::Shell.prepend 'PKG_CONFIG_PATH', package.pkg_config, separator: ':', system: true if Dir.exist? package.pkg_config
            System::Shell.set "#{package.name.to_s.upcase}_ROOT", package.prefix
            package.export_env.each do |key, value|
              System::Shell.set key, value
            end
          end
          System::Shell.set 'PS1', '\e[0;34m\u\e[m@\e[0;32mstarman\e[m \W$ '
          System::Shell.set 'CLICOLOR', 'xterm-color'
        else
          system "source #{System::Shell.rc_file} && sh"
        end
      end
    end
  end
end