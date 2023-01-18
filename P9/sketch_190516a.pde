final int myWidth=700, myHeight=500;
final int boardWidth=6, boardHeight=5;
final float cellSizeX=(myWidth*0.8)/boardWidth;
final float cellSizeY=(myHeight*0.8)/boardHeight;
int firstX=4, firstY=4;
int enemyX=0, enemyY=2;
int life=3;
int delay=500;

int time=millis();
int ecra;
PImage penguinImage, bombImage;

int[][]board = new int[boardWidth][boardHeight];
int[][]clearBoard = new int[boardWidth][boardHeight];
int[][]clearBoard2 = new int[boardWidth][boardHeight];

void settings(){
  size(myWidth, myHeight);
}

void setup(){
  if(boardHeight>4 && boardWidth>5){
    penguinImage = loadImage("penguin.png");
    bombImage = loadImage("bomb.png");
    ecra = 1;
  }
}

void clearBoard(){
  for(int i=0; i<boardWidth; i++){
    for(int j=0; j<boardHeight; j++){
      board[i][j]=0;
    }
  }
}

void drawMatrix(){
  for(int i=0; i<boardWidth; i++){
    for(int j=0; j<boardHeight; j++){
      fill(200, 200, 200);
      stroke(255);
      rect((width*0.8/boardWidth)*(i%boardWidth)+width*0.1, (j%boardHeight)*((height*0.8)/boardHeight)+height*0.1, cellSizeX, cellSizeY);
    }
  }
  paintPosition();
}

void drawMatrixLevel2(int [][] boards){
  board=boards;
  for(int i=0; i<boardWidth; i++){
    for(int j=0; j<boardHeight; j++){
      if((i>0 && i<5 && j==1) || (i==2 && j==1) || (j>2 && j<5 && i==2) || (i==4 && j==3)){
        fill(255);
        rect((width*0.8/boardWidth)*(i%boardWidth)+width*0.1, (j%boardHeight)*((height*0.8)/boardHeight)+height*0.1, cellSizeX, cellSizeY);
      }
      else{
        fill(200, 200, 200);
        rect((width*0.8/boardWidth)*(i%boardWidth)+width*0.1, (j%boardHeight)*((height*0.8)/boardHeight)+height*0.1, cellSizeX, cellSizeY);
      }
    }
  }
  paintPosition();
}

void getEnemy(){
  image(bombImage, (width*0.8/boardWidth)*(enemyX%boardWidth)+width*0.1, (enemyY%boardHeight)*((height*0.8)/boardHeight)+height*0.1, cellSizeX, cellSizeY);
}

void draw(){
  if(ecra==1){
    background(color(122, 77, 183));
    text("Olá!", myWidth/2, myHeight/5);
    textAlign(CENTER);
    fill(0, 182, 206);
    if(key==' ')
      ecra = 2;
  }
  else if(ecra==2){ //Nivel 1
    background(color(245, 195, 66)); //Amarelo
    drawMatrix(); //Matriz simples
    getEnemy(); //Penguin a passar
    text("Lifes: " + life, myWidth/6, myHeight/14); //Vidas
    if(time+delay < millis()){
      enemyX++;
      time = millis();
      if(isGameOver(firstX, firstY)==true){
        ecra = 7;
      }
    }
    if(isVictory()==true)
      ecra = 3;
  }
  else if(ecra==3){ //Ecra de vitoria
    background(color(17, 190, 63));
    if(key==' ')
      ecra = 4;
  }
  else if(ecra==4){ //Nivel 2
    background(color(200, 0, 0));
    drawMatrixLevel2(clearBoard);
    fill(255);
    text("Lifes: "+life, myWidth/6, myHeight/14); //Vidas
    paintPosition();
    if(isVictory()==true)
      ecra = 5;
  }
  else if(ecra==5){ //Ecra Vitoria 2
    background(color(17, 190, 63));
    if(key==' ')
      ecra = 6;
  }
  else if(ecra==6){ //Nivel 3
    background(color(17, 190, 63));
    drawMatrixLevel2(clearBoard2);
    getEnemy();
    fill(255);
    text("Lifes: "+life, myWidth/6, myHeight/14); //Vidas
    if(time+delay < millis()){
      enemyX++;
      time = millis();
      if(isGameOver(firstX, firstY)==true)
        ecra = 7;
    }
    if(isVictory()==true)
      ecra = 8;
  }
  else if(ecra==7){
    background(color(200, 0, 0));
    fill(255);
    text("Você perdeu!", myWidth/2, myHeight/5);
    text("Deseja começar de novo?", myWidth/2, myHeight/3);
    fill(color(0, 255, 0));
    rect(myWidth/4, 2*myHeight/3, 50, 30);
    fill(0);
    text("Sim", (myWidth/4)+25, (2*myHeight/3)+20);
    fill(color(255, 0, 0));
    rect(2*myWidth/3, 2*myHeight/3, 50, 30);
    fill(0);
    text("Não", (2*myWidth/3)+25, (2*myHeight/3)+20);
    textAlign(CENTER);
  }
  else if(ecra==8){
    background(color(200, 0, 0));
    fill(255);
    text("Parabéns, você ganhou!", myWidth/2, myHeight/5);
    textAlign(CENTER);
  }
}

boolean isVictory() {
  int counter = 0;
  for(int i=0; i<boardWidth; i++){
    for(int j=0; j<boardHeight; j++){
      if(board[i][j]==1)
        counter++;
    }
  }
  if(ecra==2 && counter==boardHeight*boardWidth)
    return true;
  else if(ecra==4 && counter==boardHeight*boardWidth-7)
    return true;
  else if(ecra==6 && counter==boardHeight*boardWidth-7)
    return true;
  else
    return false;
}

boolean isGameOver(int currentX, int currentY) {
  if(life==0)
    return true;
  else if(currentX==enemyX%6 && currentY==enemyY || currentY==enemyY && currentX==enemyX%6-1){
    life--;
    return false;
  }
  return false;
}

void paintPosition() {
  for(int i=0; i<boardWidth; i++){
    for(int j=0; j<boardHeight; j++){
      image(penguinImage, (myWidth*0.8/boardWidth)*(firstX%boardWidth)+myWidth*0.1, (firstY%boardHeight)*((myHeight*0.8)/boardHeight)+myHeight*0.1, cellSizeX, cellSizeY);
      if(board[i][j]==1){
        fill(0, 189, 214);
        rect((myWidth*0.8/boardWidth)*(i%boardWidth)+myWidth*0.1, (j%boardHeight)*((myHeight*0.8)/boardHeight)+myHeight*0.1, cellSizeX, cellSizeY);
      }
    }
  }
}

boolean checkSurroundings(int x, int y){
  if(x>=0 && x<boardWidth && y>=0 && y<boardHeight)
    return true;
  return false;
}

boolean checkSurroundingsLevel2(int x, int y){
  if(((x==1 || x==2 || x==3 || x==4 ) && y==1) || (x==2 && (y==3 || y==4)) || (x==4 && y==3))
    return false;
  if(x>=0 && x<boardWidth && y>=0 && y<boardHeight)
    return true;
  return false;
}

void keyPressed() {
  if(key=='w' || keyCode==UP){
    if(ecra==2 && checkSurroundings(firstX, firstY-1)==true){
      if(board[firstX][firstY-1] == 0)
        board[firstX][firstY-1] = 1;
      else
        board[firstX][firstY-1] = 0;  
      firstY -= 1;
    }
    else if((ecra==4 || ecra==6) && checkSurroundingsLevel2(firstX, firstY-1)==true){
      if(board[firstX][firstY-1] == 0)
        board[firstX][firstY-1] = 1;
      else
        board[firstX][firstY-1] = 0;
      firstY -= 1;
    }
  }
  else if(key=='s' || keyCode==DOWN){
    if(ecra==2 && checkSurroundings(firstX, firstY+1)==true){
      if(board[firstX][firstY+1] == 0)
        board[firstX][firstY+1] = 1;
      else
        board[firstX][firstY+1] = 0;  
      firstY += 1;
    }
    else if((ecra==4 || ecra==6) && checkSurroundingsLevel2(firstX, firstY+1)==true){
      if(board[firstX][firstY+1] == 0)
        board[firstX][firstY+1] = 1;
      else
        board[firstX][firstY+1] = 0;
    firstY += 1;
    }
  }
  else if(key=='a' || keyCode==LEFT){
    if(ecra==2 && checkSurroundings(firstX-1, firstY)==true){
      if(board[firstX-1][firstY] == 0)
        board[firstX-1][firstY] = 1;
      else
        board[firstX-1][firstY] = 0;  
      firstX -= 1;
    }
    else if((ecra==4 || ecra==6) && checkSurroundingsLevel2(firstX-1, firstY)==true){
      if(board[firstX-1][firstY] == 0)
        board[firstX-1][firstY] = 1;
      else
        board[firstX-1][firstY] = 0;  
      firstX -= 1;
    }
  }
  else if(key=='d' || keyCode==RIGHT){
    if(ecra==2 && checkSurroundings(firstX+1, firstY)==true){
      if(board[firstX+1][firstY] == 0)
        board[firstX+1][firstY] = 1;
      else
        board[firstX+1][firstY] = 0;  
      firstX += 1;
    }
    else if((ecra==4 || ecra==6) && checkSurroundingsLevel2(firstX+1, firstY)==true){
      if(board[firstX+1][firstY] == 0)
        board[firstX+1][firstY] = 1;
      else
        board[firstX+1][firstY] = 0; 
      firstX += 1;
    }
  }
}