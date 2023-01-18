final int myRows = 8;
final int myColumns = 10;
final int myWidth = 1000;
final int myHeight = 1000;
float boardW;
float boardH;
float marginX, marginY; //margens do tabuleiro
float sColumns, sRows; //espaço entre colunas e linhas
int mColumns, mRows; //coluna e linha onde se encontra o rato
final float boardsize = 0.8;


final int delay = 1000;
int t1 = 0;
int Position;
int colors = 0;

color[] myColor = {color(0, 125, 0), color(0, 128, 0), color(255, 99,71), color(64, 224, 208)};
color windowColor = color (0, 139, 139);

int [][] board;
int [][] clearboard;

//----------------------------------------------------------------------------------

void setup(){
  board = new int [myRows][myColumns];
  clearboard = new int[myRows][myColumns];
  marginX = (1-boardsize)*0.5*width;
  marginY = (1-boardsize)*0.5*height;
  boardW = myWidth * boardsize;
  boardH = myHeight * boardsize;
  sColumns = boardW / myColumns;
  sRows = boardH / myRows;
  colors = int(random(1,4));

}


int countWhile(int[][] m, int Rows, int Columns, int x, int r, int c, int dv, int dh){
  int result = 0;
  while(c >= 0 && c < Columns && r >= 0 && r < Rows && m[r][c] == x){
     c += dh;
     r += dv;
     result++;
  }
  return result;
}

void Matrix(int Rows, int Columns){
  fill(255);
  stroke(50);
  strokeWeight(3);
  for(int i=0; i<=Rows; i++)//8
    line(marginX, sRows * i + marginX, boardH + marginX, sRows * i + marginX);
  for(int i=0; i<=Columns; i++) //10
    line(sColumns * i + marginY, marginY, sColumns * i + marginY, boardW + marginY);
}


//Criar as bolas
void Balls(int Rows, int Columns){
 for(int r = 0; r < Rows;r++){
   for(int c= 0; c < Columns; c++){
     if(board[r][c] != 0){
       ellipseMode(CORNER);
       strokeWeight(3);
       fill(myColor[board[r][c]]);
       ellipse(c*sColumns+marginX, r*sRows+marginY, sColumns, sRows);
     }
    }
  }
}

int Cell(int x, int y){
  int colunm = int((x-marginX)/sColumns);
  int row = int((y-marginY)/sRows);
  int result = row*myColumns + colunm;
  println(colunm, row);
  return result;
}

void five_balls(int r, int c, int n, int dv, int dh){
 for(int i = 0; i < n; i++)
   clearboard[r+i*dv][c+i*dh] = 1;
}

//contar o numero de bolas 
void count_balls(){
  for(int r = 0; r < myRows; r++){
   for(int c = 0; c < myColumns; c++){
    int vertical = countWhile(board, myRows, myColumns, board[r][c], r, c, 1, 0);
    int horizontal = countWhile(board, myRows, myColumns, board[r][c], r, c, 0, 1);
    int diagonal1 = countWhile(board, myRows, myColumns, board[r][c], r, c, 1, -1);
    int diagonal2 = countWhile(board, myRows, myColumns, board[r][c], r, c, 1, 1);
    if(vertical >= 5)
      five_balls(r, c, vertical, 1, 0);
    else if(horizontal >= 5)
      five_balls(r, c, horizontal, 0, 1);
    else if(diagonal1 >= 5)
      five_balls(r, c, diagonal2, 1, -1);
    else if(diagonal2 >= 5)
      five_balls(r, c, diagonal2, 1, 1);
   }  
 }
 clean_balls();
}
  
//quando se forma 5 bolas juntas
void clean_balls(){
  for(int r = 0; r < myRows; r++){
   for(int c = 0; c < myColumns; c++){
     if(clearboard[r][c] == 1)
      board[r][c] = 0; 
   }
  }
   clear_board();
}

void clear_board(){
  for(int r = 0; r < myRows; r++){
   for(int c = 0; c < myColumns; c++){
    clearboard[r][c] = 0; 
   }
  }
}

//Contar o nr de quadrados vazios
int CountEmpty(){
 int result = 0;
 for(int r = 0; r < myRows; r++)
   for(int c = 0; c < myColumns; c++)
     if(board[r][c] == 0)
     result ++;
  return result;
}

//guardar as coordenadas dos quadrados vazios
int[] SquaresEmpty(){
 int a[] = new int[CountEmpty()];
 int result = 0;
 for(int r = 0; r < myRows; r++)
   for(int c = 0; c < myColumns; c++)
     if(board[r][c] == 0)
       a[result++] = r*myColumns+c;
 return a;
}



//  Created by Pedro Guerreiro on 01/11/2018.
//  Copyright Â© 2018 Pedro Guerreiro. All rights reserved.
void ints_exchange(int a[], int x, int y){
 int m = a[x];
 a[x] = a[y];
 a[y] = m;
}

void ColoresRandom(int a[]){
 int n = a.length;
 for(int i = 0; i < n-1; i++)
   ints_exchange(a, i, i+int(random(n-1-i)));
}

void BallsRandom(){
 int a[] = SquaresEmpty();
 ColoresRandom(a);
 int n = 0;
 while(a.length!=0 && n < 3){
  for(int r = 0; r < myRows; r++){
   for(int c = 0; c < myColumns; c++){
    if(n < a.length)
      if(a[n]==(r*myColumns+c) && n < 3){
       board[r][c] = colors;
       colors = int(random(1,4));
      }
   }
  }
  n++;
 }
}

void settings(){
  size(myWidth, myHeight);
}

void draw(){
  background(windowColor);
  Matrix(myRows, myColumns);
  Balls(myRows, myColumns);
  //if(millis() >= t1 + delay)
    //update();
}

/*void update(){
  count_balls();
}*/

void mouseClicked(){
  
  Position = Cell(mouseX, mouseY);
  frameRate(60);
  BallsRandom();
}
