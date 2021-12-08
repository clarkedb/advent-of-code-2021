# solution.jl

function main()
  if (length(ARGS) < 1)
    println("No input file provided")
    exit(1)
  end

  if (length(ARGS) < 2)
    println("No number of days was provided")
    exit(1)
  end

  verbose = length(ARGS) == 3
  n = parse(Int64, ARGS[2])
  f = open(ARGS[1]) 
  input = readline(f)
  close(f)

  simulate(input, n, verbose)
end

function simulate(input, n, verbose = false)
  initial = map(x -> parse(Int64, x), split(input, ","))
  lampfish = Dict(map(x -> [x, count(a -> a == x, initial)], [0:8;]))
  
  for i = 1:n
    iterate(lampfish)
    if (verbose)
      println("After $i days: $lampfish")
    end
  end

  final_population = sum(values(lampfish))
  println("Final population: ", final_population)
end

function iterate(fish)
  zeros = fish[0]
  fish[0] = 0
  for i in 1:8
    fish[i-1] = fish[i]
  end
  fish[8] = zeros
  fish[6] += zeros
end

main()
