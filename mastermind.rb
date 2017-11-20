def plural?(number, word)
    number == 1 ? "#{number} #{word}" : "#{number} #{word}s"
end

def quit?
  puts "PLay again? Y/N"
  answer = gets.chomp.downcase
  $quit = true if answer == "n"
end

def score(code, guess)
  guess_array = []
  guess.each_char do |x|
    guess_array << x.to_i
  end

  code_copy = []
  code.each_char do |x|
    code_copy << x.to_i
  end
  if code_copy == guess_array
    correct = 4
    match = 0
  else
    counter = 0
    correct = 0
    delete_list =[]
    guess_array.each do |x|
      if x == code_copy[counter]
        correct += 1
        delete_list << x
      end
      counter += 1
    end

    delete_list.each do |del|
      guess_array.delete_at(guess_array.index(del))
    end
    delete_list.each do |del|
      code_copy.delete_at(code_copy.index(del))
    end

    counter = 0
    match = 0
    while counter < guess_array.length do
      if code_copy.index(guess_array[counter])
        match += 1
        code_copy.delete_at(code_copy.index(guess_array[counter]))
        guess_array.delete_at(counter)
      else
        counter += 1
      end
    end
    guess_array.each do |x|
      if code_copy.index(x)
        match += 1
        guess_array.delete_at(guess_array.index(x))
        code_copy.delete_at(code_copy.index(x))
      end
    end
  end
  [correct, match]
end

until $quit
  win = false
  puts "Welcome to Mastermind! Would you like to 1) set or 2) guess the code?"
  set_get = gets.chomp.to_i
  unless set_get == 1 || set_get == 2
    puts "Please enter 1 or 2."
    set_get = gets.chomp.to_i
  end
  #Set the code (player or computer)
  if set_get == 1 then
    puts "Choose a 4-digit code using the numbers 0-5."
    code = gets.chomp
    if code.length == 4
    else
      puts "Invalid input. Choose a 4-digit code using the numbers 0-5."
      code = gets.chomp
    end
  else
    Kernel.srand
    code = ""
    4.times do
      code << rand(6).to_s
    end
    puts code
    puts "Guess the code (4 numbers from 0-5)."
  end

  guess_count = 0
  prev_guesses = []

  guess_set = []
  (0..5).each do |w|
    (0..5).each do |x|
      (0..5).each do |y|
        (0..5).each do |z|
          guess_set << w.to_s + x.to_s + y.to_s + z.to_s
        end
      end
    end
  end

  until win || guess_count >= 12
    if guess_count > 0
      puts "\nPrevious guesses and results:"
      puts prev_guesses
    end

    if set_get == 1

      if guess_count == 0
        guess = "0011"
      else
        guess = guess_set[rand(guess_set.length)]
      end
    else
      print "Your guess: "
      guess = gets.chomp
    end
    guess_score = score(code,guess)
    i = 0
    while i < guess_set.length do
      if guess_score != score(guess, guess_set[i])
        guess_set.delete_at(i)
      else
        i += 1
      end
    end
    correct = guess_score[0]
    match = guess_score[1]
    if correct == 4 then
      win = true
    else
      puts "#{plural?(correct,"number")} in the correct position."
      puts "#{plural?(match,"other number")} correct."
    end
    prev_guesses <<  "#{guess} (#{correct},#{match})"
    guess_count += 1
  end

  if win
    if set_get == 1 then
      puts "The computer guessed your code in #{plural?(guess_count,"turn")}."
    else
      puts "Congratulations, you have won in #{plural?(guess_count,"turn")}!"
    end
    quit?
  else
    if set_get == 1 then
      puts "Congratulations! The computer failed to guess your code!"
    else
      puts "You ran out of turns! The code was #{code}. Better luck next time!"
    end
    quit?
  end
end
