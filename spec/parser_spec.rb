require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is from website' do
    let(:email){
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org'],
      email.subject = 'Formulário de Proposta de Veículo',
      email.body = "\n\nFormulário de Proposta de Veículo Nome Completo: Alexandre Santos da Silva \n Email: alexandre2130@hotmail.com \n Telefone: (13) 9741-66505 \n Celular: (13) 9741-66505 \n Tipo de Contato: Qualquer meio \n Mensagem: Bom dia pergunta esse Vectra e 2.4 16 válvula elite correto  pq no anúncio está 2.0  elite . Esse carro teria condições de financiamento 100 %  e quanto ficaria  e as condições  aguardo seu retorno . \n Marca: CHEVROLET \n Modelo: VECTRA \n Ano: 2008/2009 \n Versao: 2.0 MPFI ELITE 8V 140CV FLEX 4P AUTOMÁTICO \n Preco: 25.900,00 \n Cambio: Automático \n Portas: 4 \n Combustivel: Gasolina e álcool \n Km: 91.400 \n Final da Placa: 2 \n Opcionais: Air bag duplo, Ar condicionado, Ar quente, Banco bi-partido, Banco do motorista com ajuste de altura, Bancos de couro, Computador de bordo, Desembaçador traseiro, Direção hidráulica, Farol de neblina, Pára-choques na cor do veículo, Porta-copos, Rádio, Retrovisores elétricos, Rodas de liga leve, Travas elétricas, Vidros elétricos, Volante com Regulagem de Altura \n Observacoes Adicionais: GRANDE OPORTUNIDADE DE NEGOCIO!!! VERIFIQUE NOSSAS CONDIÇÕES ESPECIAIS DE FINANCIAMENTO PARA ESSE VEÍCULO! CONCESSIONARIA AUDI CENTER SANTOS Oferecemos seminovos Premium com qualidade e procedência!!! Aceitamos seu carro como parte no pagamento! Venha conhecer nossa Loja!!! Rua Brás Cubas, 340 - Vila Nova Santos / SP"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead reach as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Alexandre Santos da Silva')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('alexandre2130@hotmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('13974166505')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Bom dia pergunta esse Vectra e 2.4 16 válvula elite correto  pq no anúncio está 2.0  elite . Esse carro teria condições de financiamento 100 %  e quanto ficaria  e as condições  aguardo seu retorno .')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('CHEVROLET VECTRA 2008/2009')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('Preço 25.900,00 Automático Gasolina e álcool')
    end

  end
end
