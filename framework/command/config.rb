module STARMAN
  module Command
    class Config
      def self.accepted_options
        {}
      end

      def self.run
        editor = 'vim'
        system "#{editor} -c 'set filetype=ruby' #{CommandLine.options[:config].value}"
      end
    end
  end
end
