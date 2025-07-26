namespace :rubocop do
  desc 'Run RuboCop'
  task :run do
    sh 'bundle exec rubocop'
  end

  desc 'Run RuboCop with auto-correct'
  task :autocorrect do
    sh 'bundle exec rubocop -a'
  end

  desc 'Run RuboCop with auto-correct and display offenses'
  task :autocorrect_and_display do
    sh 'bundle exec rubocop -A'
  end
end
