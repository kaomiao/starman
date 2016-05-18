module STARMAN
  class Package
    include PackageDSL
    include PackageParams
    include PackageDefaultMethods
    include System::Command

    extend Forwardable
    def_delegators :@latest, :homepage, :url, :mirror, :sha256, :version
    def_delegators :@latest, :filename, :options, :dependencies

    attr_reader :latest, :history

    def initialize
      name = self.class.name.split('::').last
      @latest = eval("@@#{name}_latest")
      @history = eval("defined? @@#{name}_history") ? eval("@@#{name}_history") : {}
    end

    def name
      @name ||= self.class.name.downcase.split('::').last
    end
  end
end
