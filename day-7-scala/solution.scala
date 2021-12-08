import scala.io.Source

object Solution {
  def linearCost(x: Int, target: Int): Int = {
    return (x - target).abs
  }

  def quadraticCost(x: Int, target: Int): Int = {
    val n = linearCost(x, target)
    return (n * (n + 1) / 2)
  }

  def main(args: Array[String]) = {
    val filename = args(0)
    val linear = args.length >= 2 && args(1) == "linear"
    val input = Source.fromFile(filename).getLines.next()
    val data = input.split(",").map(_.toInt).sortWith(_ < _)

    if (linear) {
      val target = data(data.length / 2) // median
      val cost = data.map(x => linearCost(x, target)).sum
      println(f"target x: $target%d")
      println(f"fuel cost: $cost%d")
    } else {
      var minCost = Int.MaxValue
      var target = 0
      for (i <- Range(data(0), data.last + 1, 1)) {
        val cost = data.map(x => quadraticCost(x, i)).sum
        if (cost < minCost) {
          minCost = cost
          target = i
        }
      }
      println(f"target x: $target%d")
      println(f"fuel cost: $minCost%d")
    }
  }
}
