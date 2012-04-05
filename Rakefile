
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'rall'
  authors  'Tim Pease'
  email  'tim.pease@gmail.com'
  url      'FIXME (project homepage)'
  ignore_file  '.gitignore'
}

