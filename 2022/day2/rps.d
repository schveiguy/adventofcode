import std.stdio;
import std.file : readText;
import std.conv;
import std.algorithm;
import std.string;

void main(string[] args)
{
    int[char][char] scores;
    if(args.length > 2 && args[2] == "winner")
    {
        scores['X'] =  ['A': 3, 'B': 1, 'C': 2];
        scores['Y'] =  ['A': 1+3, 'B': 2+3, 'C': 3+3];
        scores['Z'] =  ['A': 2+6, 'B': 3+6, 'C': 1+6];
    }
    else
    {
        scores['X'] =  ['A': 1+3, 'B': 1+0, 'C': 1+6];
        scores['Y'] =  ['A': 2+6, 'B': 2+3, 'C': 2+0];
        scores['Z'] =  ['A': 3+0, 'B': 3+6, 'C': 3+3];
    }
        
    auto input = readText(args[1]);
    int score = 0;
    foreach(round; input.splitter('\n').map!(l => strip(l).split))
    {
        if(round.length)
            score += scores[round[1][0]][round[0][0]];
    }
    writeln(score);
}
