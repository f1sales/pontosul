require "pontosul/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Pontosul
  class Error < StandardError; end
  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        },
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Telefone|Portas|Km|Combustivel|Ano|Modelo|Cambio|Versao|Preco|Celular|Origem|Nome|Email|Site|Mensagem|Marca).*?:/, false)

      {
        source: {
          name: F1SalesCustom::Email::Source.all[0][:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: "#{parsed_email['marca']} #{parsed_email['modelo']} #{parsed_email['ano']}",
        message: (parsed_email['mensagem']).gsub("\n", ' ').strip,
        description: "Preço #{parsed_email['preco']} #{parsed_email['cambio']} #{parsed_email['combustivel']}",
      }
    end
  end
end
