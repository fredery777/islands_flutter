import 'dart:core';


class Util {
  int numIslands(List<List<int>> islandGrid)
  {
    int h = islandGrid.length;
    if (h == 0) {
      return 0;
    }
    int l = islandGrid[0].length;
    int result = 0;
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < l; j++) {
        if (islandGrid[i][j] == 1) {
          DFS(islandGrid, i, j);
          result++;
        }
      }
    }
    return result;
  }

  void DFS(List<List<int>> islandGrid, int row, int col)
  {
    int H = islandGrid.length;
    int L = islandGrid[0].length;
    if (((((row < 0) || (col < 0)) || (row >= H)) || (col >= L)) || (islandGrid[row][col] != 1)) {
      return;
    }
    islandGrid[row][col] = 0;
    DFS(islandGrid, row + 1, col);
    DFS(islandGrid, row - 1, col);
    DFS(islandGrid, row, col + 1);
    DFS(islandGrid, row, col - 1);
  }



  ///Other
///
  static bool canEnterCell(List<List<int>> matrix, List<List<bool>> isVisited, int curRow, int curCol)
  {
    int nRows = matrix.length;
    int nCols = matrix[0].length;
    if ((((((curRow < 0) || (curRow >= nRows)) || (curCol < 0)) || (curCol >= nCols)) || isVisited[curRow][curCol]) || (matrix[curRow][curCol] == 0)) {
      return false;
    }
    return true;
  }

  static void expandSearch(List<List<int>> matrix, List<List<bool>> isVisited, int curRow, int curCol)
  {
    int nRows = matrix.length;
    int nCols = matrix[0].length;
    isVisited[curRow][curCol] = true;
    for (int i = (-1); i <= 1; (++i)) {
      for (int j = (-1); j <= 1; (++j)) {
        bool isSafeCell = canEnterCell(matrix, isVisited, curRow + i, curCol + j);
        if (isSafeCell) {
          expandSearch(matrix, isVisited, curRow + i, curCol + j);
        }
      }
    }
  }

   int findIslands(List<List<int>> matrix)
  {
    int nRows = matrix.length;
    int nCols = matrix[0].length;

    List<List<bool>> isVisited  = List.generate(nRows, (i) => List.generate(nCols, (j) => true, growable: false), growable: false);

    int i;
    int j;
    for ((i = 0); i < nRows; (++i)) {
      for ((j = 0); j < nCols; (++j)) {
        isVisited[i][j] = false;
      }
    }
    int count = 0;
    for ((i = 0); i < nRows; (++i)) {
      for ((j = 0); j < nCols; (++j)) {
        if ((matrix[i][j] == 1) && (!isVisited[i][j])) {
          expandSearch(matrix, isVisited, i, j);
          ++count;
        }
      }
    }
    return count;
  }

}