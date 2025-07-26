namespace :docker do
  desc 'Build the Docker image'
  task :build do
    sh 'docker build -t swift-tail .'
  end

  desc 'Run the Docker container'
  task :run do
    sh 'docker run -p 3000:3000 swift-tail'
  end

  desc 'Stop the Docker container'
  task :stop do
    sh 'docker stop $(docker ps -q --filter ancestor=swift-tail)'
  end

  desc 'Remove the Docker image'
  task :remove do
    sh 'docker rmi swift-tail'
  end
end
