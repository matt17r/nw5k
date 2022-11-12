class Person < ApplicationRecord
  after_initialize :init
  before_save :downcase_email

  has_many :results
  has_many :volunteers

  validates :name, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true

  has_secure_password
  has_secure_token :remember_token

  def to_s
    "#{emoji} #{nickname}"
  end

  def reverse_chronological_results
    self.results.joins(:event).order(date: :desc)
  end

  def reverse_chronological_volunteers
    self.volunteers.joins(:event).order(date: :desc)
  end

  private

  def init
    animal = random_animal
    adjective = alliterative_adjective(animal[:name].first)

    self.email ||= "#{animal[:name]}@local"
    self.emoji ||= animal[:emoji]
    self.nickname ||= "#{adjective} #{animal[:name]}"
    self.password ||= SecureRandom.hex
  end

  def downcase_email
    self.email = email.downcase
  end

  def random_animal
    [
      {:name=>"Ant", :emoji=>"🐜"},
      {:name=>"Badger", :emoji=>"🦡"},
      {:name=>"Bat", :emoji=>"🦇"},
      {:name=>"Bear", :emoji=>"🐻"},
      {:name=>"Beaver", :emoji=>"🦫"},
      {:name=>"Bee", :emoji=>"🐝"},
      {:name=>"Blowfish", :emoji=>"🐡"},
      {:name=>"Boar", :emoji=>"🐗"},
      {:name=>"Bug", :emoji=>"🐛"},
      {:name=>"Butterfly", :emoji=>"🦋"},
      {:name=>"Camel", :emoji=>"🐪"},
      {:name=>"Cat", :emoji=>"🐈"},
      {:name=>"Chicken", :emoji=>"🐥"},
      {:name=>"Chipmunk", :emoji=>"🐿"},
      {:name=>"Cow", :emoji=>"🐄"},
      {:name=>"Crab", :emoji=>"🦀"},
      {:name=>"Cricket", :emoji=>"🦗"},
      {:name=>"Crocodile", :emoji=>"🐊"},
      {:name=>"Deer", :emoji=>"🦌"},
      {:name=>"Dog", :emoji=>"🐶"},
      {:name=>"Dolphin", :emoji=>"🐬"},
      {:name=>"Dove", :emoji=>"🕊"},
      {:name=>"Duck", :emoji=>"🦆"},
      {:name=>"Eagle", :emoji=>"🦅"},
      {:name=>"Elephant", :emoji=>"🐘"},
      {:name=>"Ewe", :emoji=>"🐑"},
      {:name=>"Fish", :emoji=>"🐠"},
      {:name=>"Flamingo", :emoji=>"🦩"},
      {:name=>"Fox", :emoji=>"🦊"},
      {:name=>"Frog", :emoji=>"🐸"},
      {:name=>"Giraffe", :emoji=>"🦒"},
      {:name=>"Goat", :emoji=>"🐐"},
      {:name=>"Gorilla", :emoji=>"🦍"},
      {:name=>"Hamster", :emoji=>"🐹"},
      {:name=>"Hedgehog", :emoji=>"🦔"},
      {:name=>"Hippo", :emoji=>"🦛"},
      {:name=>"Horse", :emoji=>"🐎"},
      {:name=>"Ibex", :emoji=>"🐐"},
      {:name=>"Jackrabbit", :emoji=>"🐰"},
      {:name=>"Kangaroo", :emoji=>"🦘"},
      {:name=>"Koala", :emoji=>"🐨"},
      {:name=>"Lady Beetle", :emoji=>"🐞"},
      {:name=>"Leopard", :emoji=>"🐆"},
      {:name=>"Lion", :emoji=>"🦁"},
      {:name=>"Lizard", :emoji=>"🦎"},
      {:name=>"Llama", :emoji=>"🦙"},
      {:name=>"Lobster", :emoji=>"🦞"},
      {:name=>"Monkey", :emoji=>"🐒"},
      {:name=>"Mosquito", :emoji=>"🦟"},
      {:name=>"Mouse", :emoji=>"🐁"},
      {:name=>"Nightingale", :emoji=>"🐦"},
      {:name=>"Octopus", :emoji=>"🐙"},
      {:name=>"Otter", :emoji=>"🦦"},
      {:name=>"Owl", :emoji=>"🦉"},
      {:name=>"Ox", :emoji=>"🐂"},
      {:name=>"Panda", :emoji=>"🐼"},
      {:name=>"Parrot", :emoji=>"🦜"},
      {:name=>"Peacock", :emoji=>"🦚"},
      {:name=>"Penguin", :emoji=>"🐧"},
      {:name=>"Pig", :emoji=>"🐷"},
      {:name=>"Quail", :emoji=>"🐦"},
      {:name=>"Rabbit", :emoji=>"🐇"},
      {:name=>"Raccoon", :emoji=>"🦝"},
      {:name=>"Ram", :emoji=>"🐏"},
      {:name=>"Rhino", :emoji=>"🦏"},
      {:name=>"Rooster", :emoji=>"🐓"},
      {:name=>"Scorpion", :emoji=>"🦂"},
      {:name=>"Shark", :emoji=>"🦈"},
      {:name=>"Shrimp", :emoji=>"🦐"},
      {:name=>"Skunk", :emoji=>"🦨"},
      {:name=>"Sloth", :emoji=>"🦥"},
      {:name=>"Snail", :emoji=>"🐌"},
      {:name=>"Snake", :emoji=>"🐍"},
      {:name=>"Spider", :emoji=>"🕷"},
      {:name=>"Squid", :emoji=>"🦑"},
      {:name=>"Swan", :emoji=>"🦢"},
      {:name=>"Tiger", :emoji=>"🐯"},
      {:name=>"Turkey", :emoji=>"🦃"},
      {:name=>"Turtle", :emoji=>"🐢"},
      {:name=>"Ural Owl", :emoji=>"🦉"},
      {:name=>"Viper", :emoji=>"🐍"},
      {:name=>"Water Buffalo", :emoji=>"🐃"},
      {:name=>"Whale", :emoji=>"🐋"},
      {:name=>"Wolf", :emoji=>"🐺"},
      {:name=>"Yak", :emoji=>"🐃"},
      {:name=>"Zebra", :emoji=>"🦓"}
    ].sample
  end

  def alliterative_adjective(starting_letter)
    adjectives = {
      A: %w(Abundant Adaptable Adorable Adored Adventurous Affable Affectionate Agreeable Allowing Altruistic Amazing Ambitious Amiable Amicable Amusing Angelic Appreciated Appreciative Authentic Aware Awesome),
      B: %w(Balanced Beautiful Beloved Best Blessed Blissful Blithesome Bold Brave Breathtaking Bright Brilliant Broad\ Minded),
      C: %w(Calm Capable Careful Caring Centered Champion Charismatic Charming Cheerful Cherished Comfortable Communicative Compassionate Confident Conscientious Considerate Content Convivial Courageous Courteous Creative Cute),
      D: %w(Daring Dazzled Decisive Dedicated Delightful Determined Diligent Diplomatic Discreet Divine Dynamic),
      E: %w(Eager Easygoing Emotional Empathetic Empowered Enchanted Endless Energetic Energized Enlightened Enlivened Enthusiastic Eternal Excellent Excited Exhilarated Expanded Exquisite Extraordinary Exuberant),
      F: %w(Fabulous Fair\ Minded Faithful Fantastic Favorable Fearless Flourishing Flowing Focused Forceful Forgiving Fortuitous Frank Free Free\ Spirited Friendly Fulfilled Fun Fun\ Loving Funny),
      G: %w(Generous Genial Genius Gentle Genuine Giving Glad Glorious Glowing Goddess Good Good Health Goodness Graceful Gracious Grateful Great Gregarious Grounded),
      H: %w(Happy Happy\ Hearted Hard\ Working Harmonious Healthy Heartfull Heartwarming Heaven Helpful High\ Spirited Holy Honest Hopeful Humorous),
      I: %w(Illuminated Imaginative Impartial Incomparable Incredible Independent Ineffable Innovative Inspirational Inspired Intellectual Intelligent Intuitive Inventive Invigorated Involved Irresistible),
      J: %w(Jazzed Jolly Jovial Joyful Joyous Jubilant Juicy Just Juvenescent),
      K: %w(Kind Kind\ Hearted Kissable Knowingly Knowledgeable),
      L: %w(Lively Lovable Loved Lovely Loving Loyal Lucky Luxurious),
      M: %w(Magical Magnificent Marvelous Memorable Mindful Miracle Miraculous Mirthful Modest),
      N: %w(Neat Nice Nirvana Noble Nourished Nurtured),
      O: %w(Open Open\ Hearted Open\ Minded Optimistic Opulent Original Outstanding),
      P: %w(Passionate Patient Peaceful Perfect Persistent Philosophical Pioneering Placid Playful Plucky Polite Positive Powerful Practical Precious Pro\ Active Propitious Prosperous),
      Q: %w(Quick\ Witted Quiet),
      R: %w(Radiant Rational Ready Receptive Refreshed Rejuvenated Relaxed Reliable Relieved Remarkable Renewed Reserved Resilient Resourceful Rich Romantic),
      S: %w(Sacred Safe Satisfied Secured Self\ Accepting Self\ Confident Self\ Disciplined Self\ Loving Sensational Sensible Sensitive Serene Shining Shy Sincere Smart Sociable Soulful Spectacular Splendid Stellar Straightforward Strong Stupendous Successful Super Sustained Sympathetic),
      T: %w(Thankful Thoughtful Thrilled Thriving Tidy Tough Tranquil Triumphant Trusting),
      U: %w(Ultimate Unassuming Unbelievable Understanding Unique Unlimited Unreal Uplifted),
      V: %w(Valuable Versatile Vibrant Victorious Vivacious),
      W: %w(Warm Warmhearted Wealthy Welcomed Whole Wholeheartedly Willing Wise Witty Wonderful Wondrous Worthy),
      Y: %w(Yawning Yellow Yielding Young\ At\ Heart Youthful),
      Z: %w(Zany Zappy Zestful Zingy),
    }
    return adjectives[starting_letter.to_sym]&.sample
  end
end
