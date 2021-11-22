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
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Nome|Telefone|Email|Qual é o veículo do seu interesse?|Qual é sua ideia de negocio?|Qual o valor de entrada:|Date).*?:/,false)
      entry_value = parsed_email['qual_o_valor_de_entrada'].split("\n").first

      {
        source: {
          name: F1SalesCustom::Email::Source.all[0][:name]
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: parsed_email['qual__o_veculo_do_seu_interesse'],
        description: "#{parsed_email['qual__sua_ideia_de_negocio']} - #{entry_value}"
      }
    end
  end
end
