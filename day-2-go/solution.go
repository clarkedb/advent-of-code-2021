package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"sync"
)

func main() {
	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		defer wg.Done()
		part1()
	}()
	go func() {
		defer wg.Done()
		part2()
	}()

	wg.Wait()
}

func part1() {
	file, err := os.Open("./input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	x := 0
	y := 0

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		directive := strings.Split(scanner.Text(), " ")
		change, _ := strconv.Atoi(directive[1])
		switch directive[0] {
		case "forward":
			x += change
		case "up":
			y -= change
		case "down":
			y += change
		}
	}

	log.Println(fmt.Sprintf("Part1 - x: %d, y: %d, product: %d", x, y, x*y))
}

func part2() {
	file, err := os.Open("./input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	x := 0
	y := 0
	aim := 0

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		directive := strings.Split(scanner.Text(), " ")
		change, _ := strconv.Atoi(directive[1])
		switch directive[0] {
		case "forward":
			x += change
			y += aim * change
		case "up":
			aim -= change
		case "down":
			aim += change
		}
	}

	log.Println(fmt.Sprintf("Part2 - x: %d, y: %d, product: %d", x, y, x*y))
}
