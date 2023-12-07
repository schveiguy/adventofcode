import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;

void main(string[] args)
{
    auto board = readText(args[1]).strip
        .split
        .map!(ln => ln.map!(a => int(a)-'0').array).array;

    static immutable dx = [-1, 0, 1, -1, 1, -1, 0, 1];
    static immutable dy = [-1, -1, -1, 0, 0, 1, 1, 1];
    int pt1;
    void flash(size_t x, size_t y)
    {
        foreach(i; 0 .. dx.length)
        {
            auto nx = x + dx[i];
            auto ny = y + dy[i];
            if(nx >= board.length || ny >= board.length)
                continue;
            if(board[nx][ny] > 0)
                ++board[nx][ny];
        }
        board[x][y] = 0;
        ++pt1;
    }
    void step()
    {
        foreach(ref a; board)
            a[] += 1;
        
        //writefln("before:\n%(%(%s%)\n%)", board);
        bool changed = true;
        while(changed) {
            changed = false;
            foreach(x; 0 .. board.length)
                foreach(y; 0 .. board.length)
                {
                    if(board[x][y] > 9)
                    {
                        flash(x, y);
                        changed = true;
                    }
                }
        }
        //writefln("after step %s:\n%(%(%s%)\n%)", i+1, board);
    }
    foreach(i; 0 .. 100)
    {
        step();
    }
    writeln("part1: ", pt1);

    int pt2 = 100;
    while(true)
    {
        pt1 = 0;
        step();
        ++pt2;
        if(pt1 == board.length * board.length)
            break;
    }
    writeln("part2: ", pt2);
}
