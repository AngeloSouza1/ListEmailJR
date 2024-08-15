user = User.find_or_create_by!(email: 'user@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

contacts_data = [
  { name: 'buscaterra', email: 'contato@buscaterra.com.br' },
  { name: 'agesbioactive', email: 'contato@agesbioactive.com' },
  { name: 'codecoast', email: 'hello@codecoast.io' },
  { name: 'controllepro', email: 'contato@controllepro.com.br' },
  { name: 'cliqueretire', email: 'contato@cliqueretire.com.br' },
  { name: 'computerscience', email: 'atendimento@computerscience.com.br' },
  { name: 'genedeyeba', email: 'suporte@genedeyeba.com' },
  { name: 'gatinfosec', email: 'contato@gatinfosec.com' },
  { name: 'mixreality', email: 'contato@mixreality.com.br' },
  { name: 'ivoservices', email: 'contato@ivoservices.com' },
  { name: 'synergiaconsultoria', email: 'contato@synergiaconsultoria.com.br' },
  { name: 'eicon', email: 'info@eicon.com.br' },
  { name: 'kikker', email: 'contato@kikker.com.br' },
  { name: 'kria', email: 'contato@kria.vc' },
  { name: 'libercapital', email: 'contato@libercapital.com.br' },
  { name: 'cashway', email: 'contato@cashway.io' }
]

contacts_data.each do |contact_data|
  Contact.find_or_create_by!(contact_data.merge(user: user))
end

puts "BANCO SEED POPULADO COM SUCESSO!"
