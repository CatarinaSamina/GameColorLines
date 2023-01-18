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
  colors = int(random(1,1));

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
       fill(myColor[colors]);
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


//contar o numero de bolas 
void count_balls(){
  for(int r = 0; r < myRows; r++){
   for(int c = 0; c < myColumns; c++){
    int vertical = countWhile(board, myRows, myColumns, board[r][c], r, c, 1, 0) + countWhile(board, myRows, myColumns, 1, r, c, -1, 0) + 1;
    int horizontal = countWhile(board, myRows, myColumns, board[r][c], r, c, 0, 1) + countWhile(board, myRows, myColumns, 1, r, c, 0, -1) + 1;;
    int diagonal1 = countWhile(board, myRows, myColumns, board[r][c], r, c, 1, 1) + countWhile(board, myRows, myColumns, 1, r, c, -1, -1) + 1;;
    int diagonal2 = countWhile(board, myRows, myColumns, board[r][c], r, c, -1, 1) + countWhile(board, myRows, myColumns, 1, r, c, 1, -1) + 1;;
    if(vertical >= 5)
      clean_balls(board, 1, r, c, 1, 0);
      clean_balls(board, 1, r, c, -1, 0);
      board[r][c] = 0;
    if(horizontal >= 5)
      clean_balls(board, 1, r, c, 0, 1);
      clean_balls(board, 1, r, c, 0, -1);
      board[r][c] = 0;
    if(diagonal1 >= 5)
      clean_balls(board, 1, r, c, 1, 1);
      clean_balls(board, 1, r, c, -1, -1);
      board[r][c] = 0;
    if(diagonal2 >= 5)
      clean_balls(board, 1, r, c, 1, -1);
      clean_balls(board, 1, r, c, -1, 1);
      board[r][c] = 0;
   }  
 }
}
  
void clean_balls( int [][]m, int x, int r, int c,int dv, int dh){
  r += dv;
  c += dh;
  while(r < myRows && r >= 0 && c < myColumns && c >= 0 && m[r][c] == x){
    m[r][c] = 0;
    r += dv;
    c += dh;
  }
}

void clear_board(){
  for(int r = 0; r < myRows; r++){
   for(int c = 0; c < myColumns; c++){
    clearboard[r][c] = 0; 
   }
  }
}

void settings(){
  size(myWidth, myHeight);
}

void draw(){
  background(windowColor);
  Matrix(myRows, myColumns);
  Balls(myRows, myColumns);
  if(millis() >= t1 + delay)
    update();
}

void update(){
  count_balls();
}

void mouseClicked(){
  
  Position = Cell(mouseX, mouseY);
  t1 = millis();
  if(mouseX < (myWidth - marginX) && mouseX > marginX && mouseY > marginY && mouseY < (myHeight - marginY)){
     if(board[Position/myColumns][Position%myColumns] != 0){
        board[Position/myColumns][Position % myColumns] = 0; 
     }
     else{
      noStroke();
      board[Position/myColumns][Position%myColumns]= colors;
      colors = int(random(1, 1));
     }
  }
}
