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

int Row, Column, Position;
float x, y;

final int delay = 1000;
int t1 = 0;

color windowColor;
int colors;
final color black = color(0, 0, 0);
final color white = color(255, 255, 255);
color[] myColor = {color(0, 125, 0), color(0, 128, 0), color(255, 99,71), color(64, 224, 208)};

int [][] board;
int [][] distance;


//----------------------------------------------------------------------------------

void setup(){
  board = new int [myRows][myColumns];
  distance = new int[myRows][myColumns];
  windowColor = black;
  marginX = (1-boardsize)*0.5*width;
  marginY = (1-boardsize)*0.5*height;
  boardW = myWidth * boardsize;
  boardH = myHeight * boardsize;
  sColumns = boardW / myColumns;
  sRows = boardH / myRows;
  MatrixUpdate(distance, -1);

}

void Text(color white, int size){
 textAlign(CENTER, CENTER);
 textSize(size);
 fill(white);
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
   for(int i=0; i<=Rows; i++){//8
    line(marginX, sRows * i + marginX, boardH + marginX, sRows * i + marginX);
   }
  for(int i=0; i<=Columns; i++){ //10
  line(sColumns * i + marginY, marginY, sColumns * i + marginY, boardW + marginY);
    }
}

 void MatrixUpdate(int[][]m, int x){
    for(int r = 0; r < myRows; r++)
      for(int c = 0; c < myColumns; c++)
        m[r][c] = x;
 }

//Criar as bolas
void Balls(int Rows, int Columns){
 for(int r = 0; r<Rows;r++){
   for(int c= 0; c < Columns; c++){
     if(board[r][c] > 0){
       ellipseMode(CORNER);
       strokeWeight(3);
       fill(myColor[colors]);
       ellipse(c*sColumns+marginX, r*sRows+marginY, sColumns, sRows);
       }
     }
  }
}

void Distance(){
 Text(white, 30);
 for(int r = 0; r < myRows; r++){
  for(int c = 0; c < myColumns; c++)
   text(distance[r][c], c * sColumns + marginX + sColumns/2, r*sRows+marginY+sRows/2);
   textMode(CORNER);
 }
}


int Cell(float x, float y){
  Row = int((y-marginY)/sRows);
  Column = int((x-marginX)/sColumns);
  int result = Row*myColumns + Column;
  return result;
}

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

void settings(){
  size(myWidth, myHeight);
}


void draw(){
  background(windowColor);
  Matrix(myRows, myColumns);
  Balls(myRows, myColumns);
  Distance();
  //if(millis() >= t1 + delay)
    //update();
}

void mouseClicked(){
  t1 = millis();
  if(mouseX < (myWidth - marginX) && mouseX > marginX && mouseY > marginY && mouseY < (myHeight - marginY)){
      MatrixUpdate(distance, -1);
      Position = Cell(mouseX, mouseY);
      noStroke();
      board[Row][Column]= +1;
      colors = int(random(1))+1;
      allDistances(board, myRows, myColumns, Position/myColumns, Position%myColumns, distance);
     
  }
}
