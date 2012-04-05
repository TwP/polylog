
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'spec:run'
task 'gem:release' => 'spec:run'


Bones {
  name     'rall'
  authors  'Tim Pease'
  email    'tim.pease@gmail.com'
  url      'http://rubygems.org/gems/rall'

  spec.opts << '--color' << '--format documentation'

  use_gmail

  depend_on  'bones-rspec',  :development => true
  depend_on  'bones-git',    :development => true
}

