require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is from website' do
    let(:email){
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.net'],
      email.subject = 'Novo Lead Black November!',
      email.body = "Nome: Breno Jr\nTelefone: 12 981257780\nEmail: claudiamariabb7@gmail.com\nQual é o veículo do seu interesse?: BMW 335i 2015\nQual é sua ideia de negocio?: À vista\nQual o valor de entrada:: R$ 50.000 a R$ 60.000\n\n---\n\nDate: Novembro 18, 2021\nTime: 6:21 pm\nPage URL: http://pontosulautomoveis.com.br/cadastre-se/\nUser Agent: Mozilla/5.0 (Linux; Android 10; Redmi Note 8)\nAppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Mobile\nSafari/537.36\nRemote IP: 179.246.222.82\nPowered by: Elementor"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead reach as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Breno Jr')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('claudiamariabb7@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('12981257780')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('BMW 335i 2015')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('À vista - R$ 50.000 a R$ 60.000')
    end
  end
end
