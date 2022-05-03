namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando banco de dados...") {%x(rails db:drop)}
      show_spinner("Criando banco de dados...") {%x(rails db:create)}
      show_spinner("Migrando banco de dados...") {%x(rails db:migrate)}
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
      
    else 
      puts "Você não está no ambiente de desenvolvimento!"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins =
      [
        {
          description: "Bitcoin", 
          acronym: "BTC", 
          url_image: "https://logodownload.org/wp-content/uploads/2017/06/bitcoin-logo-5-1.png",
          mining_type: MiningType.find_by(acronym: 'PoW')
        },
        {
          description: "Ethereum",
          acronym: "ETH", 
          url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1027.png",
          mining_type: MiningType.find_by(acronym: 'PoW')
        },
        {
          description: "Dash", 
          acronym: "DASH", 
          url_image: "https://www.pngkit.com/png/detail/135-1353048_dash-icon-dash-coin-logo-png.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "Iota", 
          acronym: "IOT", 
          url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1720.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "ZCash", 
          acronym: "ZEC", 
          url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1437.png",
          mining_type: MiningType.all.sample
        }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = 
      [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]
      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private
  def show_spinner(msg_start, msg_end="Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield 
    spinner.success("#{msg_end}")
  end

end
