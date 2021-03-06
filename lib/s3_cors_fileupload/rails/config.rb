require 'yaml'

module S3CorsFileupload
  module Config
    class MissingOptionError < RuntimeError; end

    # this allows us to lazily instantiate the configuration by reading it in when it needs to be accessed
    class << self
      # if a method is called on the class, attempt to look it up in the config array
      def method_missing(meth, *args, &block)
        if args.empty? && block.nil?
          config[meth.to_s]
        else
          super
        end
      end

      def file_path
        @file_path ||= ::Rails.root.join('config', 'amazon_s3.yml')
      end

      private

      def config
        @config ||= YAML.load(ERB.new(File.read(self.file_path)).result)[::Rails.env]
      rescue
        warn('WARNING: s3_cors_fileupload gem was unable to locate a configuration file in config/amazon_s3.yml and may not ' +
             'be able to function properly.  Please run `rails generate s3_cors_upload:install` before proceeding.')
        {}
      end
    end
  end
end
