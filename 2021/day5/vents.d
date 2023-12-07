import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;

void main(string[] args)
{
	auto input = File(args[2]).byLineCopy;
	bool mode = args[1] == "diags";
	ubyte[int][int] mapping;
	foreach(l; input)
	{
		auto segs = l.splitter;
		auto ps = segs.front.split(',');
		int x1, x2, y1, y2;
		x1 = ps[0].to!int;
		y1 = ps[1].to!int;
		segs.popFrontN(2);
		ps = segs.front.split(',');
		x2 = ps[0].to!int;
		y2 = ps[1].to!int;

		if(x1 == x2)
		{
			foreach(y; min(y1, y2) .. max(y1, y2)+1)
				++mapping[x1][y];
		}
		else if(y1 == y2)
		{
			foreach(x; min(x1, x2) .. max(x1, x2)+1)
				++mapping[x][y1];
		}
		else if(mode)
		{
			// consider diagonals
			int dx = x2 > x1 ? 1 : -1;
			int dy = y2 > y1 ? 1 : -1;
			++mapping[x1][y1];
			do
			{
				x1 += dx;
				y1 += dy;
				++mapping[x1][y1];
			} while(x1 != x2);
		}
	}
	int nbig = 0;
	foreach(aa; mapping)
		foreach(v; aa)
			nbig += v > 1;
	writeln(nbig);
}
