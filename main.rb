=begin

[Rubyでのゲッターとセッターについて \- Qiita](https://qiita.com/katsutakashima/items/fff67799614c40ba5520)

クラス外からは基本的にインスタンスを取得・変更することは不可
それを可能にするのが、ゲッター・セッター

=end

class Brave
  # attr_readerの記述でゲッターを省略することができる
  attr_reader :name, :offense, :defense
  attr_accessor :hp

  # 必殺技を使う時は攻撃力が1.5倍。その定数。
  SPECIAL_ATTACK_CONSTANT = 1.5

  # initializeメソッドを活用する
  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
  end

  def attack(monster)
    puts "#{@name}の攻撃"

    # 必殺技か通常攻撃か判定するロジック
    attack_num = rand(4)

    if attack_num == 0
      puts "必殺技"
      damage = caluculate_special_attack - monster.defense
    else
      puts "通常攻撃"
      damage = @offense - monster.defense    
    end

    monster.hp -= damage

    # ダメージ + 残りHPの表示
    puts "#{monster.name}は#{damage}のダメージを受けた"
    puts "#{monster.name}の残りHPは#{monster.hp}だ"
  end

  def caluculate_special_attack
    @offense * SPECIAL_ATTACK_CONSTANT
  end

end

class Monster
  attr_reader :offense, :defense
  attr_accessor :name, :hp

  # 必殺技を使う時は攻撃力が1.5倍。その定数。
  POWER_UP_RATE = 1.5

  # 初期HPの半分の値を計算する定数。
  CALC_HALF_HP = 0.5

  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]

    # モンスターが変身したか判定するフラグ
    @transform_flag = false

    # 変身する際の閾値（トリガー）を計算
    @trigger_of_transform = params[:hp] * CALC_HALF_HP
  end

  def attack(brave)
    # HPが半分以下、かつモンスター変身判定フラグがflaseの場合
    if @hp <= @trigger_of_transform && @transform_flag == false
      # モンスターを変身させるため、trueとする
      @transform_flag = true
      # 変身メッセージ出力 + 攻撃力1.5倍 + 名前ドラゴン にするメソッドを実行
      transform
    end

    puts "#{@name}の攻撃"

    damage = @offense - brave.defense
    brave.hp -= damage

    # ダメージ + 残りHPの表示
    puts "#{brave.name}は#{damage}のダメージを受けた"
    puts "#{brave.name}の残りHPは#{brave.hp}だ"
  end

  def caluculate_special_attack
    @offense * SPECIAL_ATTACK_CONSTANT
  end

  private

  def transform
    transform_name = "ドラゴン"

    puts <<~EOS
    #{@name}は怒っている
    #{@name}は#{transform_name}に変身した
    EOS

    @offense *= POWER_UP_RATE
    @name = transform_name
  end

end

brave = Brave.new(name: "テリー", hp: 500, offense: 150, defense: 100)

monster = Monster.new(name: "スライム", hp: 250, offense: 200, defense: 100)

brave.attack(monster)



# puts <<~TEXT
# NAME: #{brave.name}
# HP: #{brave.hp}
# OFFENSE: #{brave.offense}
# DEFENSE: #{brave.defense}
# TEXT

# brave.hp -= 30

# damage = brave.offense - monster.defense

# puts damage
# puts monster.hp - damage

# puts "#{brave.name}はダメージを受けた!　残りHPは#{brave.hp}だ"
