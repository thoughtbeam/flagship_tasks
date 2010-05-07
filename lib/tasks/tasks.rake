def disp_errors(errors)
  puts errors.count.to_s + "error(s) prevented the update:"
  errors.full_messages.each do |msg|
    puts msg
  end
end

namespace :tasks do
  desc "Reset a user's password. Prompts for username." 
  task :repass => :environment do
    print "Enter Username: "
    input = STDIN.gets
    u = User.find_by_username(input.chomp)
    if u.nil?
      puts 'User not found.'
    else
      print "Enter new password: "
      pw = STDIN.gets
      print "Confirm new password: "
      pwc = STDIN.gets

      if pw.chomp.blank?
        puts "No password provided!"
      else
        u.update_attributes(:password => pw.chomp, :password_confirmation => pwc.chomp)
        if u.save && !u.errors.any?
          puts "Password updated!"
        else
          disp_errors(u.errors)
        end
      end
    end
  end # end repass task

  desc "Make a user an admin. Prompts for username"
  task :make_admin => :environment do
    print "Enter Username: "
    input = STDIN.gets
    u = User.find_by_username(input.chomp)
    if u.nil?
      puts 'User not found.'
    else
      print "Make #{u.name} an admin? [Y/n]: "
      pw = STDIN.gets

      if pw.chomp.downcase == 'y'
        u.update_attributes(:is_admin => true)

        if u.save && !u.errors.any?
          puts "User promoted!"
        else
          disp_errors(u.errors)
        end
      else
        puts "No? Okay. Goodbye!"
      end
    end
  end # end make_admin task
end


  
