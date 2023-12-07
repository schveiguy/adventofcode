import std.stdio;
import std.algorithm;
import std.conv;
import std.file : readText;
import std.range;
import std.string;

void main(string[] args)
{
	auto input = File(args[2]).byLineCopy;
	auto mode = args[1] == "last";
	auto numbers = input.front.split(',').map!(n => n.to!int);
	input.popFront;
	alias Card = int[5][5];
	Card[] cards;
	// read in the cards
	Card curCard;
	size_t idx;
	foreach(l; input.filter!(l => l.strip.length > 0))
	{
		copy(l.splitter.map!(v => v.to!int), curCard[idx++][]);
		if(idx == 5)
		{
			cards ~= curCard;
			idx = 0;
		}
	}

	bool isWinner(Card c)
	{
		if(c[0][0] == -2) // already won
			return false;
		foreach(i; 0 .. 5)
		{
			// check rows
			bool rowgood = true;
			bool colgood = true;
			foreach(j; 0 .. 5)
			{
				if(c[i][j] != -1)
					rowgood = false;
				if(c[j][i] != -1)
					colgood = false;
			}
			if(rowgood || colgood) return true;
		}
		return false;
	}

	// run the game
	int nWinners = 0;
	foreach(n; numbers)
	{
		foreach(i, ref c; cards)
		{
			int score;
			foreach(ref row; c)
				foreach(ref v; row)
				{
					if(v == n) v = -1;
					else if(v != -1) score += v;
				}
			if(isWinner(c))
			{
				if(!mode)
				{
					writeln("Winner card ", i, " score = ", score, " last number = ", n, " result = ", score * n);
					return;
				}
				// mark as winner
				c[0][0] = -2;
				++nWinners;
				if(nWinners == cards.length)
				{
					writeln("Loser card ", i, " score = ", score, " last number = ", n, " result = ", score * n);
					return;
				}
			}

		}
	}
}
