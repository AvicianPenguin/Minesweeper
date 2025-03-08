import de.bezier.guido.*;
int NUM_ROWS = 10;
int NUM_COLS = 10;
int NUM_BOMBS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i<NUM_COLS; i++)
    {
      for(int j = 0; j<NUM_ROWS; j++)
      {
        buttons[i][j] = new MSButton(i,j);
      }
    }
    setMines();
}
public void setMines()
{
    while(mines.size()<NUM_BOMBS)
    {
      int row = (int)(Math.random()*(NUM_ROWS-1));
      int col = (int)(Math.random()*(NUM_COLS-1));
      if(!mines.contains(buttons[row][col]))
      {
        mines.add(buttons[row][col]);
      }
   }
}

public void draw ()
{
    background(0);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int countFlagged = 0;
    int countClicked = 0;
    for(int i = 0; i<mines.size(); i++)
    {
      if((mines.get(i).flagged == true));
        countFlagged+=1;
    }
    for(int i = 0; i<NUM_COLS; i++)
    {
      for(int j = 0; j<NUM_ROWS; j++)
      {
        if(buttons[i][j].clicked == true)
          countClicked +=1;
      }
    }
    if(countFlagged == NUM_BOMBS&&countClicked == NUM_ROWS*NUM_COLS - NUM_BOMBS)
      return true;
    return false;
}
public void displayLosingMessage()
{
   
    for(int i = 0; i<mines.size(); i++)
    {
      mines.get(i).clicked = true;
      if(mines.get(i).flagged == true)
        mines.get(i).flagged = false;
    }
    for(int i = 0; i<NUM_COLS; i++)
    {
      for(int j = 0; j<NUM_ROWS; j++)
      {
        if(!mines.contains(buttons[i][j]))
        {
          buttons[i][j].clicked = true;
        }
        if(buttons[i][j].flagged == true)
        {
          buttons[i][j].flagged = false;
        }
      }
    }
    for(int i = 0; i<NUM_COLS; i++)
    {
      for(int j = 0; j<NUM_ROWS; j++)
      {
        buttons[i][j].setLabel("L");
      }
    }
}
public void displayWinningMessage()
{
   for(int i = 0; i<NUM_COLS; i++)
    {
      for(int j = 0; j<NUM_ROWS; j++)
      {
        buttons[i][j].setLabel("W");
      }
    }
}
public boolean isValid(int row, int col)
{
  if(row>=0&&row<NUM_ROWS&&col>=0&&col<NUM_COLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1;r<=row+1;r++)
      for(int c = col-1; c<=col+1;c++)
        if(isValid(r,c)&&mines.contains(buttons[r][c]))
          numMines++;
    if(mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed()
    {
        clicked = true;
        if(mouseButton == RIGHT)
          if(flagged == true){
            flagged = false;
          }
          else{
            flagged = true;
            clicked = false;
          }
        else if (mines.contains(buttons[myRow][myCol]))
          displayLosingMessage();
        else if(countMines(myRow,myCol)>0)
          buttons[myRow][myCol].setLabel(countMines(myRow,myCol));
        else
          for(int r = myRow-1;r<=myRow+1;r++)
          {
            for(int c = myCol-1; c<=myCol+1;c++)
            {
               if(isValid(r,c)&&(countMines(r,c)<=1)&&(buttons[r][c].clicked==false))
                 buttons[r][c].mousePressed();
            }
          }
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
