all: bcalc

bcalc: bcalc.b
	blang bcalc.b -o bcalc -b
