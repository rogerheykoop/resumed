puts "********Seeding Data Start************"

admin = User.create(
       :email => 'systemadmin@superpowers.com', :password => 'superadmin', 
       :password_confirmation => 'superadmin') 

if admin.errors.blank?
    admin.add_role :admin # add_role is method defined by rolify gem
    puts "***admin role assigned to Email #{admin.email} Password #{admin.password}***"
else
    puts "admin user failed to create due to below reasons:"
    admin.errors.each do |x, y|
       puts"#{x} #{y}" # x will be the field name and y will be the error on it
     end
end

puts "********Seeding Data End************"
