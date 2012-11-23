require 'savon'
require 'i18n'
require 'savon_xml_override'
require 'tax_cloud/version'
require 'tax_cloud/errors'
require 'tax_cloud/transaction'
require 'tax_cloud/address'
require 'tax_cloud/cart_item'
require 'tax_cloud/tax_codes'
require 'tax_cloud/configuration'
require 'hash'

I18n.load_path << File.join(File.dirname(__FILE__), "config", "locales", "en.yml")

# TaxCloud is a web service to calculate and track sales tax for your ecommerce platform. Integration is easy to use.
# For information on configuring and using the TaxCloud API, look at the <tt>README</tt> file.
module TaxCloud
  # WSDL location for TaxCloud
  WSDL_URL = 'https://api.taxcloud.net/1.0/?wsdl'
  # TaxCloud API version
  API_VERSION = '1.0'

  class << self
    attr_accessor :configuration

    # Configure the variables
    def configure
      self.configuration ||= Configuration.new
      yield configuration
    end

    # Reset configuration
    def reset!
      self.configuration = nil
    end

    # Method to define and retrieve the SOAP methods
    def client
      check_configuration!
      @@client ||= Savon::Client.new do
        wsdl.document = TaxCloud::WSDL_URL
      end
    end

    # Authorization hash to use with all SOAP requests
    def auth_params
      {
        'apiLoginID' => configuration.api_login_id,
        'apiKey' => configuration.api_key
      }
    end

    private

      def check_configuration!
        raise TaxCloud::Errors::MissingConfig.new unless self.configuration
        self.configuration.check!
      end

  end

end
