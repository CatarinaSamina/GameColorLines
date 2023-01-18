final int myWidth = 700;
final int myHeight = 600;
// Margem
final int marginWidth = 100;
final int marginHeight = 100;
// Resolucao Tabuleiro
final int myRows = 8;
final int myColumns = 10;
float cellWidth = (myWidth - 2.0*marginWidth)/myColumns;
float cellHeight = (myHeight - 2.0*marginHeight)/myRows;
// Matriz
int [][] board;
int [][] distance;
int [][] path;
int [] adjacent;
// Eixo
int cell; 
int cellX, cellY; 
float cellCenterX, cellCenterY; 

color windowColor;
int rColorIndex;
// Mouse
float x, y;
int myMouseX, myMouseY; 
boolean mouseflag;
// Timer
final int delay = 1000; 
int t1 = 0; 
final color black = color (0,0,0);
final color white = color (255, 255, 255);
final color red = color (255, 0, 0);
final color gold = color (255, 215, 0);

void settings()
{
  size(myWidth, myHeight); 
}

void setup()
{  
  ellipseMode(CENTER);
  windowColor = black;
  
  board = new int[myRows][myColumns];
  distance = new int[myRows][myColumns]; 
  path = new int [myRows][myColumns];
  adjacent = new int [8];
  matrixSetup(distance, -1); 
}

void draw()
{
  x=mouseX;
  y=mouseY;
  background(windowColor);
  drawBoard();
  drawCircle();
  drawPath();
  //ellipse(x, y, 5, 5);
  getMouseAxis(x, y, cellWidth, cellHeight, marginWidth, marginHeight);
  
  if (myMouseX < myColumns && myMouseX >= 0 && myMouseY < myRows && myMouseY >= 0) //Checks if the mouse is not clicking the margin
  {
    matrixSetup(path, 0);
    if (mouseflag)
      shortestPath(distance, myMouseY, myMouseX, path);
  }
}

// Settings
void lineSettings(color strokeColor, int strokeSize)
{
  stroke(strokeColor);
  strokeWeight(strokeSize);
}

void textSettings(color textColor, int size)
{
  textSize(size);
  fill(textColor); 
  textAlign(CENTER, CENTER); 
}

void drawBoard()
{
  lineSettings(white, 3);  
  for (int i = 0; i<=myColumns; i++)
    line(i*cellWidth + marginWidth, marginHeight, i*cellWidth + marginWidth, myRows*cellHeight + marginHeight);
  for (int i = 0; i<=myRows; i++)
    line(marginWidth, i*cellHeight + marginHeight, myColumns*cellWidth+marginWidth, i*cellHeight + marginHeight);
}

void drawCircle()
{
  int [] myColors = {gold};
  for (int i = 0; i<myRows; i++)
    for (int j = 0; j<myColumns; j++)
      if (board[i][j]>0)
      {
        fill(myColors[board[i][j]-1]);
        getCellCenter(j, i, cellWidth, cellHeight, marginWidth, marginHeight); 
        ellipse(cellCenterX, cellCenterY, cellWidth, cellHeight);
      }
}

void drawPath()
{
  textSettings(white, 25);
  for (int i = 0; i<myRows; i++)
    for (int j = 0; j<myColumns; j++)
    {
      getCellCenter(j, i, cellWidth, cellHeight, marginWidth, marginHeight); 
      text(path[i][j], cellCenterX, cellCenterY);
    }
}

void getMouseAxis(float x, float y, float w, float h, int marginWidth, int marginHeight) 
{
  myMouseX = int((x-marginWidth)/w);
  myMouseY = int((y-marginHeight)/h);
}

void getCellAxis(float x, float y, float w, float h, int marginWidth, int marginHeight) 
{
  cellX = int((x-marginWidth)/w);
  cellY = int((y-marginHeight)/h);
}

void getCellCenter(float x, float y, float w, float h, int marginWidth, int marginHeight) 
{
  cellCenterX = x*w + marginWidth + w/2.0;
  cellCenterY = y*h + marginHeight + h/2.0;
}

int getCell(float x, float y, float w, float h, int c, int marginWidth, int marginHeight) 
{
  int x0 = int((x-marginWidth)/w);
  int y0 = int((y-marginHeight)/h);
  cell = (y0*c)+x0;
  return cell;
}

void matrixSetup(int[][] m, int x) 
{
  for (int i = 0; i<myRows; i++)
    for (int j = 0; j<myColumns; j++)
      m[i][j]=x;
}

int countWhile(int[][] m, int rows, int columns, int x, int r, int c, int dv, int dh) 
{
  int result=0;
  r+=dv; 
  c+=dh; 
  while (r>=0 && c>=0 && r<=rows-1 && c<=columns-1 && m[r][c]==x)
  {
    result++; 
    r+=dv; 
    c+=dh; 
  }
  return result;
}

void S(int[][] m, int[][] d, int i, int j, int x) 
{
  if (i<myRows-1 && d[i+1][j]==-1 && m[i+1][j]==0) 
    d[i+1][j]=x+1;
}
void N(int[][] m, int[][] d, int i, int j, int x) 
{
  if (i>0 && d[i-1][j]==-1 && m[i-1][j]==0)
    d[i-1][j]=x+1;
}
void E(int[][] m, int[][] d, int i, int j, int x) 
{
  if (j<myColumns-1 && d[i][j+1]==-1 && m[i][j+1]==0)
    d[i][j+1]=x+1;
}

void NE(int[][]m, int[][]d, int i, int j, int x){
  if(i > 0 && j < myColumns -1 && d[i-1][j+1] == -1 && m[i-1][j+1] == 0)
    d[i-1][j+1] = x+1;
}

void SE(int[][]m, int[][]d, int i, int j, int x){
  if(i < myRows -1 && j < myColumns -1 && d[i+1][j+1] == -1 && m[i+1][j+1] == 0)
    d[i+1][j+1] = x+1;
}

void W(int[][] m, int[][] d, int i, int j, int x) 
{
  if (j>0 && d[i][j-1]==-1 && m[i][j-1]==0)
    d[i][j-1]=x+1;
}

void NW(int[][]m, int[][]d, int i, int j, int x){
  if(i > 0 && j > 0 && d[i-1][j-1] == -1 && m[i-1][j-1] == 0)
    d[i-1][j-1] = x+1;
}

void SW (int[][]m, int[][]d, int i, int j, int x){
  if(i < myRows -1 && j > 0 && d[i+1][j-1] == -1 && m[i+1][j-1] == 0)
    d[i+1][j-1] = x+1;
}

void sDistance(int[][] d, int i, int j) 
{
  if (i<myRows-1) 
    adjacent[0]=d[i+1][j];
  else
    adjacent[0]=9999; 
}
void nDistance(int[][] d, int i, int j) 
{
  if (i>0)
    adjacent[1]=d[i-1][j];
  else
    adjacent[1]=9999;
}
void eDistance(int[][] d, int i, int j) 
{
  if (j<myColumns-1)
    adjacent[2]=d[i][j+1];
  else
    adjacent[2]=9999;
}

void wDistance(int[][] d, int i, int j) 
{
  if (j>0)
    adjacent[3]=d[i][j-1];
  else
    adjacent[3]=9999;
}

void neDistance(int[][]d, int r, int c){
  if(r > 0 && c < myColumns -1)
    adjacent[4] = d[r-1][c+1];
  else
    adjacent[4] = 9999;
}

void seDistance(int[][]d, int r, int c){
  if(r < myRows -1 && c < myColumns -1)
    adjacent[5] = d[r+1][c+1];
  else
    adjacent[5] = 9999;
}

void nwDistance(int[][]d, int r, int c){
  if(r > 0 && c > 0)
    adjacent[6] = d[r-1][c-1];
  else
    adjacent[6] = 9999;
}

void swDistance(int[][]d, int r, int c){
  if(r < myRows -1 && c > 0)
    adjacent[7] = d[r+1][c-1];
  else
    adjacent[7] = 9999;
}

void distances(int[][] m, int rows, int columns, int r, int c, int[][] d)
{
  d[r][c]=0; 
  int x=0; 
  int loop=0;
  while (loop<rows*columns) 
  {   
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        if (d[i][j]==x) 
        {
          S(m, d, i, j, x);
          N(m, d, i, j, x);
          E(m, d, i, j, x);
          W(m, d, i, j, x);
          NE(m, d, i, j, x);
          SE(m, d, i, j, x);
          NW(m, d, i, j, x);
          SW(m, d, i, j, x);
        }
    loop++;
    x++;
  }
}

void shortestPath(int [][] d, int r, int c, int[][] p)
{
  int currentDistance = d[r][c];
  while(currentDistance>=1)
  {
    p[r][c]=1;
    int direction=-1; 
    sDistance(d, r, c); 
    nDistance(d, r, c); 
    eDistance(d, r, c);
    neDistance(d, r, c);
    seDistance(d, r, c);
    wDistance(d, r, c);
    nwDistance(d, r, c);
    swDistance(d, r, c);
    for (int i = 0; i < 8; i++) 
      if (currentDistance>adjacent[i]  && adjacent[i] >=0)
      {
        currentDistance=adjacent[i];
        direction = i;
      } 
    if (currentDistance!=0)
    {
      if (direction==-1) 
        p[r][c]=1;
      if (direction==0) 
        p[r++][c]=currentDistance+1;
      if (direction==1) 
        p[r--][c]=currentDistance+1;
      if (direction==2) 
        p[r][c++]=currentDistance+1;
      if(direction == 3) // NE
         p[r--][c++] = currentDistance+1;
      if(direction == 4) //SE
         p[r++][c++] = currentDistance+1;
      if (direction==5) 
        p[r][c--]=currentDistance+1;
      if(direction == 6) //NW
         p[r--][c--] = currentDistance+1;
      if(direction == 7) //SW
         p[r++][c--] = currentDistance+1;
    }
  }
}


void mousePressed()
{
  x = mouseX;
  y = mouseY;

  mouseflag=true; 
  t1 = millis(); 
  rColorIndex=int(random(1))+1;
  if (x>marginWidth && x < myWidth-marginWidth && y>marginHeight && y < myHeight-marginHeight) 
  {
    matrixSetup(distance, -1); 
    cell = getCell(x, y, cellWidth, cellHeight, myColumns, marginWidth, marginHeight); 
    getCellAxis(x, y, cellWidth, cellHeight, marginWidth, marginHeight); 
    board[cellY][cellX] = rColorIndex;
    distances(board, myRows, myColumns, cellY, cellX, distance); 
  }
}
