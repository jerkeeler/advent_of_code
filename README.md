# Advent of Code

Repo for my [Advent of Code](https://adventofcode.com) solutions. Currently this is just for 2024.

Usage guide:

```bash
# Install Ruby 3.3.X
# Install all gems
bundle Install

# Copy .env.example to .env and fill out session with your session token

# Run a given day with
bundle exec ruby main.rb DAY
# For example, to run all of day 1
bundle exec ruby main.rb 1
# The script automatically pulls your correct input from advent of code using your session token

# To run for a specific part add -p, for example to run day 1 part 1 only
bundle exec ruby main.rb 1 -p 1

# To run for the example input add -e
bundle exec ruby main.rb 1 -e
```
