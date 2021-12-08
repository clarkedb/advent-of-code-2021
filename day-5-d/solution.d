import std.algorithm : map;
import std.algorithm.searching : count;
import std.array : join;
import std.conv : to;
import std.format : format, formattedRead;
import std.math.algebraic : abs;
import std.range : iota;
import std.stdio : File, writeln;

string gridDisplay(int[][] grid)
{
  return grid.map!((row =>
      row.map!(cell => cell == 0 ? "." : to!string(cell)).join(" ")
  )).join("\n");
}

void main(string[] args)
{
  if (args.length < 2)
  {
    throw new Exception("No input file provided");
  }
  auto f = File(args[1]);

  bool parseDiagonals = args.length >= 3;
  bool displayGrid = args.length >= 4;
  int[][][] pairs;
  int xMax, yMax;

  foreach (line; f.byLine)
  {
    int x1, x2, y1, y2;
    formattedRead(line, "%d,%d -> %d,%d", x1, y1, x2, y2);
    if ((x1 == x2) || (y1 == y2) || (parseDiagonals && (abs(x1 - x2) == abs(y1 - y2))))
    {
      pairs ~= [[x1, y1], [x2, y2]];
      if (x1 > xMax)
        xMax = x1;
      if (x2 > xMax)
        xMax = x2;
      if (y1 > yMax)
        yMax = y1;
      if (y2 > yMax)
        yMax = y2;
    }
  }
  f.close();

  int[][] grid = new int[][](xMax + 1, yMax + 1);

  foreach (pair; pairs)
  {
    int[2] start = pair[0];
    int[2] target = pair[1];
    int startX = start[0];
    int startY = start[1];
    int targetX = target[0];
    int targetY = target[1];
    if (startX == targetX)
    {
      int begin = startY < targetY ? startY : targetY;
      int end = startY < targetY ? targetY + 1 : startY + 1;
      foreach (y; iota(begin, end))
      {
        grid[startX][y] += 1;
      }
    }
    else if (startY == targetY)
    {
      int begin = startX < targetX ? startX : targetX;
      int end = startX < targetX ? targetX + 1 : startX + 1;
      foreach (x; iota(begin, end))
      {
        grid[x][startY] += 1;
      }
    }
    else if (parseDiagonals && (abs(startX - targetX) == abs(startY - targetY)))
    {
      int xDelta = startX < targetX ? 1 : -1;
      int yDelta = startY < targetY ? 1 : -1;
      int n = abs(startX - targetX);
      for(int i = 0; i <= n; i++) {
        int x = startX + (xDelta * i);
        int y = startY + (yDelta * i);
        grid[x][y] += 1;
      }
    }
    else
    {
      continue;
    }
  }

  const int threshold = 2;
  int overlap_count = 0;
  foreach (row; grid)
  {
    overlap_count += count!("a >= b")(row, threshold);
  }

  writeln("Overlap Count: ", overlap_count);
  if (displayGrid)
    writeln(gridDisplay(grid));
}
