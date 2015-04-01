class User < ActiveRecord::Base
  has_many :events, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :recoverable, :validatable
  # :lockable, :timeoutable
  devise :database_authenticatable, :trackable, :rememberable, :omniauthable

  def self.find_for_oauth(auth, signed_in_resource = nil)

    is_new_user = false

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user
    
    # Create the user if needed
    if user.nil?

      # Get the existing user by email
      email = auth.info.email ? auth.info.email : "#{auth.uid}@#{auth.provider}.com" 
      user = User.where(:email => email).first_or_initialize

      is_new_user = user.id ? true : false
      
      # Update or create the user in database
      user.update_attributes(
        id_facebook: auth.uid,
        email: email,
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        city: auth.extra.raw_info.location,
        gender: auth.extra.raw_info.gender,
        birthday: auth.extra.raw_info.birthday, # Date.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y"),
        #username: auth.info.nickname || auth.uid,
        password: Devise.friendly_token[0,20]
      )
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    
    return user, is_new_user
  end  
  
  # Récupère la liste des utilisateurs, triés par ordre de contribution descendant
  # limit    limite à N utilisateurs la liste
  def self.get_users_with_contributions_counter(limit=nil)
    self.query_contributions_counter_user(nil, limit)
  end
  
  # Récupère un utilisateur avec son nb de contribution
  # user_id    ID de l'utilisateur
  def self.get_user_with_contribution_counter(user_id)
    self.query_contributions_counter_user(user_id)
  end
  
  private
  
  # Récupère un ou N utilisateurs dans la BD, en calculant pour chacun leur total de contributions, et les triant par nb contribution descendant
  # user_id    ID d'un utilisateur spécifique à récupérer
  # limit      nombre maximum N d'utilisateurs à récupérer
  # retour     1 ou N utilisateur suivant les paramètres
  def self.query_contributions_counter_user(user_id=nil, limit=nil)
    # A faire avec ActiveRecord!
    #self.joins(:events).select('users.*, COUNT(events.id) AS contributions_counter').group('users.id').order('contributions_counter DESC').order(:first_name).order(:last_name)

    query = self.select('users.*, COUNT(events.id) AS contributions_counter')
        .joins('LEFT JOIN events ON events.user_id = users.id AND events.is_published = True')
        .group('users.id')
        .order('contributions_counter DESC, first_name ASC, last_name ASC')

    if not user_id.nil?
      query = query.where('users.id = ?', user_id).take
    end
    
    if not limit.nil?
      query = query.limit(limit)
    end
    
    query
  end

end
