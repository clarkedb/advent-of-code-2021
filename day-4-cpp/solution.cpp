#include <stdio.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <string>
#include <vector>

using namespace std;

// splits on a string on a given char
vector<string> split(string str, char ch) {
  stringstream ss(str);
  vector<string> output;

  while(ss.good()) {
      string substr;
      ss >> ws; // ignore prepended whitespace
      getline(ss, substr, ch);
      output.push_back(substr);
  }

  return output;
}

class Board {
  private:
    bool bingo;
    size_t dim;
    vector<unsigned int> row_totals;
    vector<unsigned int> col_totals;
    vector<vector<string>> rows;
    map<string, pair<int, int>> coordinates;
    map<string, bool> marked;

  public:
    Board(vector<vector<string>> _rows) {
      rows = _rows;
      dim = rows.size();
      bingo = false;

      // build coordinate and marked maps
      for (size_t i = 0; i < dim; i++) {
        for (size_t j = 0; j < dim; j++) {
          string number = rows[i][j];
          pair<int, int> coords = pair<int, int>(i, j);
          coordinates.insert(pair<string, pair<int, int>>(number, coords));
          marked.insert(pair<string, bool>(number, false));
        }
      }

      // initialize all totals at 0
      row_totals = vector<unsigned int>(dim, 0);
      col_totals = vector<unsigned int>(dim, 0);
    }

    bool has_bingo(void) {
      return bingo;
    }

    void set_bingo(bool got_bingo) {
      bingo = got_bingo;
    }

    // return true if calling number gives bingo
    bool call(string value) {
      if (!coordinates.count(value)) {
        return false;
      }

      pair<int, int> coords = coordinates[value];
      row_totals[coords.first] += 1;
      col_totals[coords.second] += 1;
      marked[value] = true;

      bool bingo = (row_totals[coords.first] == dim) || (col_totals[coords.second] == dim);
      return bingo;
    }

    // compute the score of the board
    unsigned int score(int multiplier) {
      unsigned int sum = 0;

      for (auto const& [cell, marked_status] : marked) {
        if (!marked_status) {
          int cell_value = stoi(cell);
          sum += cell_value;
        }
      }

      unsigned int final_score = sum * multiplier;
      return final_score;
    }

    string str(void) {
      stringstream ss;
      for (vector<string> row: rows) {
        for (string cell: row) {
          ss << cell << "[";
          if (marked[cell]) {
            ss << "X";
          }
          ss << "] ";
        }
        ss << '\n';
      }
      return ss.str();
    }
};

int main (int argc, char *argv[]) {
  if (argc < 2) {
    cerr << "No file was provided for input";
    return 1;
  }
  ifstream in(argv[1]);
  if (!in) {
		cerr << "Unable to open " << argv[1] << " for input";
		return 1;
	}

  bool find_first_bingo = argc != 3;

  // get calling numbers
  string line;
  getline(in, line);
  vector<string> calling_numbers = split(line, ',');
  getline(in, line); // blank line before boards

  // get bingo boards
  vector<Board> boards;
  while (!in.eof()) {
    vector<vector<string>> rows;
    while (getline(in, line) && line != "") {
      vector<string> row = split(line, ' ');
      rows.push_back(row);
    }
    Board board = Board(rows);
    boards.push_back(board);
  }

  // play until a board gets bingo or all boards get bingo
  const size_t board_count = boards.size();
  unsigned int bingo_count = 0;
  for(string number: calling_numbers) {
    for (Board& board: boards) {
      if (board.has_bingo()) {
        continue;
      }

      bool bingo = board.call(number);
      if (bingo) {
        bingo_count++;
        board.set_bingo(bingo);
        if (find_first_bingo ^ (bingo_count == board_count)) {
          cout << "BINGO! (" << number << ")\n";
          cout << board.str() << '\n';
          cout << board.score(stoi(number)) << '\n';
          return 0;
        }
      }
    }
  }

  if (find_first_bingo) {
    cout << "No winner\n";
  } else {
    cout << "Not all boards get bingo\n";
  }

  return 0;
}
