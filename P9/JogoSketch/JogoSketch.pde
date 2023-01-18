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
int touch = 0;
int mark = 0;

color[] myColor = {color(0, 125, 0), color(0, 128, 0), color(255, 99,71), color(64, 224, 208)};
color windowColor = color (0, 139, 139);

int [][] board;
int [][] clearboard;
int[][]distance;
int[] mouse;

//----------------------------------------------------------------------------------

void setup(){
  board = new int [myRows][myColumns];
  clearboard = new int[myRows][myColumns];
  distance = new int [myRows][myColumns];
  mouse = new int[8];
  marginX = (1-boardsize)*0.5*width;
  marginY = (1-boardsize)*0.5*height;
  boardW = myWidth * boardsize;
  boardH = myHeight * boardsize;
  sColumns = boardW / myColumns;
  sRows = boardH / myRows;
  colors = int(random(1,4));
  MatrixUpdate(distance, -1);

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

 void MatrixUpdate(int[][]m, int x){
    for(int r = 0; r < myRows; r++)
      for(int c = 0; c < myColumns; c++)
        m[r][c] = x;
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
 clearboard_balls();
}
  
//quando se forma 5 bolas juntas
void clearboard_balls(){
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

int getclearboard(int[] a,int [][]m,int rows,int columns)
{
 int result=0;
 for(int i=0;i<columns*rows;i++)
   if(m[i/columns][i%columns]==0){
     a[result]=i;
     result++;
   }
 return result;
}
//DISTANCE------------------------------------------


void North(int[][]m, int[][]d, int r, int c, int x){
  if(r>0 && d[r-1][c] == -1 && m[r-1][c] == 0)
    d[r-1][c] = x+1;
}

void South(int[][]m, int[][]d, int r, int c, int x){
  if(r < myRows - 1 && d[r+1][c] == -1 && m[r+1][c] == 0)
    d[r+1][c] = x+1;
}

void Este(int[][]m, int[][]d, int r, int c, int x){
  if(c < myColumns -1 && d[r][c+1] == -1 && m[r][c+1] == 0)
    d[r][c+1] = x+1;
}

void NE(int[][]m, int[][]d, int r, int c, int x){
  if(r > 0 && c < myColumns -1 && d[r-1][c+1] == -1 && m[r-1][c+1] == 0)
    d[r-1][c+1] = x+1;
}

void SE(int[][]m, int[][]d, int r, int c, int x){
  if(r < myRows -1 && c < myColumns -1 && d[r+1][c+1] == -1 && m[r+1][c+1] == 0)
    d[r+1][c+1] = x+1;
}

void West(int[][]m, int[][]d, int r, int c, int x){
  if(c > 0 && d[r][c-1] == -1 && m[r][c-1] == 0)
    d[r][c-1] = x+1;
}

void NW(int[][]m, int[][]d, int r, int c, int x){
  if(r > 0 && c > 0 && d[r-1][c-1] == -1 && m[r-1][c-1] == 0)
    d[r-1][c-1] = x+1;
}

void SW (int[][]m, int[][]d, int r, int c, int x){
  if(r < myRows -1 && c > 0 && d[r+1][c-1] == -1 && m[r+1][c-1] == 0)
    d[r+1][c-1] = x+1;
}

//Calcular todas as distancias na vertical, horizontal e diagonal
void allDistances(int[][]m, int Rows, int Columns, int r, int c, int[][]d){
  d[r][c] = 0;
  int x = 0;
  int loop = 0;
  while(loop < Rows * Columns){
    for(int i = 0; i < Rows; i++){
     for(int j = 0; j < Columns; j++){
       if(d[i][j]==x){
        North(m, d, i, j, x);
        South(m, d, i, j, x); 
        Este(m, d, i, j, x);
        NE(m, d, i, j, x);
        SE(m, d, i, j, x);
        West(m, d, i, j, x); 
        NW(m, d, i, j, x);
        SW(m, d, i, j, x);
       }
     }
    }
    loop++;
    x++;
  }
}

void NDistance(int[][]d, int r, int c){
  if(r > 0)
    mouse[0] = d[r-1][c];
  else
    mouse[0] = 9999;
}

void SDistance(int[][]d, int r, int c){
  if(r < myRows -1)
    mouse[1] = d[r+1][c];
  else
    mouse[1] = 9999;
}

void EDistance(int[][]d, int r, int c){
  if(c < myColumns -1)
    mouse[2] = d[r][c+1];
  else
    mouse[2] = 9999;
}

void NEDistance(int[][]d, int r, int c){
  if(r > 0 && c < myColumns -1)
    mouse[3] = d[r-1][c+1];
  else
    mouse[3] = 9999;
}

void SEDistance(int[][]d, int r, int c){
  if(r < myRows -1 && c < myColumns -1)
    mouse[4] = d[r+1][c+1];
  else
    mouse[4] = 9999;
}

void WDistance(int[][]d, int r, int c){
  if(c > 0)
    mouse[5] = d[r][c-1];
  else
    mouse[5] = 9999;
}

void NWDistance(int[][]d, int r, int c){
  if(r > 0 && c > 0)
    mouse[6] = d[r-1][c-1];
  else
    mouse[6] = 9999;
}

void SWDistance(int[][]d, int r, int c){
  if(r < myRows -1 && c > 0)
    mouse[7] = d[r+1][c-1];
  else
    mouse[7] = 9999;
}

void shortestPath(int[][]d, int r, int c, int[][]p){
  int ActualBall = d[r][c];//Bola clicada para saber as distancias
  while(ActualBall > 0){
    p[r][c] = 1;
    int Direction = -1;
    NDistance(d, r, c);
    SDistance(d, r, c);
    EDistance(d, r, c);
    NEDistance(d, r, c);
    SEDistance(d, r, c);
    WDistance(d, r, c);
    NWDistance(d, r, c);
    SWDistance(d, r, c);
    for(int i = 0; i < 8; i++){
     if(ActualBall > mouse[i] && mouse[i] >=0){
      ActualBall = mouse[i];
      Direction = i;
     }
    }
    if(ActualBall != 0){
     if(Direction == -1)
       p[r][c] = 1;
     if(Direction == 0) //North
       p[r--][c] = ActualBall+1;
     if(Direction == 1) //South
       p[r++][c] = ActualBall+1;
     if(Direction == 2) //Este
       p[r][c++] = ActualBall+1;
     if(Direction == 3) // NE
       p[r--][c++] = ActualBall+1;
     if(Direction == 4) //SE
       p[r++][c++] = ActualBall+1;
     if(Direction == 5) //West
       p[r][c--] = ActualBall+1;
     if(Direction == 6) //NW
       p[r--][c--] = ActualBall+1;
     if(Direction == 7) //SW
       p[r++][c--] = ActualBall+1;
   }
  }
}


//_---------------------------------------------------------------------

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
       board[r][c] = colors;
         colors = int(random(1,4));
       board[r][c] = colors;
         colors = int(random(1,4));
       board[r][c] = colors;
         colors = int(random(1,4));
      }
   }
  }
  n++;
 }
}

//NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN

void settings(){
  size(myWidth, myHeight);
}

void draw(){
  background(windowColor);
  Matrix(myRows, myColumns);
  Balls(myRows, myColumns);
  if(millis() >= t1 + delay)
    update();
    if(touch == 1)
      allDistances(board, myRows, myColumns, Position/myColumns, Position % myColumns, distance);
}

void update(){
  count_balls();
}

void mouseClicked(){
  touch = 1;
  Position = Cell(mouseX, mouseY);
  t1 = millis();
  if(board[Position / myColumns][Position%myColumns] == 0 && distance[Position / myColumns][Position % myColumns] != -1){
    board[Position / myColumns][Position%myColumns] = mark;
    BallsRandom();
    if(board[mouse[0]/myColumns][mouse[0]%myColumns] == 0)
     board[mouse[0]/myColumns][mouse[0]%myColumns]= int(random(1, 4));
    if(board[mouse[1]/myColumns][mouse[1]%myColumns] == 0)
     board[mouse[1]/myColumns][mouse[1]%myColumns]= int(random(1, 4));
    if(board[mouse[2]/myColumns][mouse[2]%myColumns] == 0)
     board[mouse[2]/myColumns][mouse[2]%myColumns]= int(random(1, 4));
    if(board[mouse[3]/myColumns][mouse[3]%myColumns] == 0)
     board[mouse[3]/myColumns][mouse[3]%myColumns]= int(random(1, 4));
  }
   else if(board[Position / myColumns][Position % myColumns] == 1){
   mark = 1;
    board[Position / myColumns][Position % myColumns] = 0 ;}
  else if(board[Position / myColumns][Position % myColumns] == 2){
    mark = 2;
    board[Position / myColumns][Position % myColumns] = 0 ;}
  else if(board[Position / myColumns][Position % myColumns] == 3){
    mark = 3;
    board[Position / myColumns][Position % myColumns] = 0 ;}
  else if(board[Position / myColumns][Position % myColumns] == 4){
    mark= 4;
    board[Position / myColumns][Position % myColumns] = 0 ;}
}
/*
    if(board[Position/myColumns][Position%myColumns] != 0){
        board[Position/myColumns][Position % myColumns] = 0; 
        return;
     }
     else{
      noStroke();
      board[Position/myColumns][Position%myColumns]= colors;
      colors = int(random(1, 1));
     }*/
