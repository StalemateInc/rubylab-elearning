# frozen_string_literal: true

# Create users with profiles
start_time = Time.now

1000.times do |n|
  user = User.create(email: "#{[*('A'..'Z')].sample(9).join}@mail.com",
    password: '111111', password_confirmation: '111111', confirmed_at: Time.now) 
  user.update(admin: true) if rand(2) == 1 ? true : false
  if user
    Profile.create(user_id: user.id, name: "#{[*('A'..'Z')].sample(7).join}",
      nickname: "#{[*('A'..'Z')].sample(7).join}",
      surname: "#{[*('A'..'Z')].sample(7).join}" )
  end
end 

p 'Create users with profiles'

# Create organizations

filename = './storage/wizzard.txt'
line_num = 0
File.open(filename).each do |line|
  user = User.find_by(id: rand(User.first.id...User.last.id))
  if user
    user.organizations.create(name: "#{line.split.first(2).join(" ")}#{[*('A'..'Z')].sample(8).join}",
    description: "#{line}")
  end
end

p 'Create organizations'

# Create JoinRequests pending

3.times do 
  Organization.ids.each do |n|
    user = rand(User.first.id...User.last.id) 
    JoinRequest.create(user_id: user, organization_id: n) if user
  end
end

p 'Create JoinRequests pending'

# Create Membership

3.times do 
  Organization.ids.each do |n|
    user = rand(User.first.id...User.last.id) 
    Membership.create(user_id: user, organization_id: n) if user
  end
end

p 'Create Membership'

# Create courses

1000.times do |n|
  adj = ["small", "tasty", "angry", "scared", "tired", "hot", "hungry", "big", "cold", "dirty", "good", "bad", "important", "unusual", "cheerful", "valuable", "funny", "clean", "upset", "unpleasant", "interesting", "sure", "sad", "difficult", "thin", "strange"]
  languages = [ "Action Script", "C++/CLI", "C++", "ColdFusion", "D", "Delphi", "Dylan", "Eiffel", "Game Maker Language (GML)", "Groovy", "Haxe", "Io", "Java", "JavaScript", "MC#", "Object Pascal", "Objective-C", "Perl", "PHP", "Pike", "Python", "Ruby", "Self", "Simula", "Smalltalk", "Swift", "Vala", "Visual Basic", "Visual DataFlex", "Zonnon", "Ada", "Активный Оберон", "Компонентный Паскаль", "Модула-3", "Оберон-2", "GNU bc", "Euphoria", "Limbo", "Lua", "Maple", "MATLAB", "Occam", "PureBasic", "Scilab", "Активный Оберон", "Алгол", "Би", "КОБОЛ", "Модула-2", "Модула-3", "Оберон", "Паскаль", "РАПИРА", "Си", "Golan" ]
  difficulties = %i[unspecified novice intermediate advanced professional]
  status = %i[drafted published ]
  user = User.find_by(id: rand(User.first.id...User.last.id))
  organization = Organization.find_by(id: rand(Organization.first.id...Organization.last.id))
  owner = rand(2) == 1 ? user : organization
  course = Course.create(name: "#{adj[rand(0...adj.length)]} #{languages[rand(0...languages.length)]}",
    duration: rand(10... 1000), description:
    "A programming language is a formal language, which comprises a set of instructions that produce various kinds of output.",
    difficulty: difficulties[rand(0...difficulties.length)],
    status: status[rand(0...status.length)],
    visibility: 'everyone')
  Ownership.create(course_id: course.id, ownable_id: owner.id, ownable_type: owner.class.to_s)
end
Ownership.pluck(:course_id).each do |course| 
  unless Course.find_by(id: course)
    o = Ownership.find_by(course_id: course)
    o.delete
  end
end

p 'Create courses'

p "#{(Time.now - start_time)/60}"

# File.open('./storage/users.csv', "w") do |f|
#   100.times do
#     f.write "#{[*('A'..'Z')].sample(9).join}@mail.com \n"
#   end
# end