#File: Rakefile
#Usage: rake

#Define tasks

desc "Installation"
task :default => [:gems] do
  puts "Darts proyect installation has finish!"
end

desc "Install gems "
task :gems do
  list=['haml', 'rspec', 'shoes', 'rainbow']
  list.each { |name| system("gem install #{name}") } 
end

desc "Update this project"
task :update do
  system("git pull")
end

desc "Clean output dir"
task :clean do
  system("rm output/*")
end

desc "Open GUI"
task :gui do
  e = ENV.to_h
  system("#{e["HOME"]}/.shoes/federales/shoes lib/gui/prueba1.rb&")
end
