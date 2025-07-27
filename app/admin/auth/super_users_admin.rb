Trestle.resource(:super_users, model: SuperUser, scope: Auth) do
  menu do
    group :configuration, priority: :last do
      item :super_users, icon: "fas fa-users"
    end
  end

  table do
    column :avatar, header: false do |super_user|
      avatar_for(super_user)
    end
    column :email, link: true
    column :name
    actions do |a|
      a.delete unless a.instance == current_user
    end
  end

  form do |super_user|
    text_field :email

    row do
      col(sm: 6) { text_field :name }
    end

    row do
      col(sm: 6) { password_field :password }
      col(sm: 6) { password_field :password_confirmation }
    end
  end
end
