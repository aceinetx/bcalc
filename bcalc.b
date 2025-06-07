ch;
token;
number;
error;

NUMBER;
PLUS;
MINUS;
MUL;
DIV;
LPAREN;
RPAREN;
EXCLAMATION;

is_digit() return ch >= '0' & ch <= '9';

expected(what){
	extrn printf;
	printf("syntax error: expected %s*n", what);
	error = 1;
}

/* input */
advance() {
	extrn getc, stdin;
	ch = getc(stdin);
	if (ch == 10) ch = 0;
}
/* - input */

/* lexer */
do_number(){
	while(ch){
		if(is_digit()){
			number *= 10;
			number += ch - '0';
		} else break;

		advance();
	}
}

next() {
	token = number = 0;

	while (ch) {
		if (is_digit()) {
			do_number();
			token = NUMBER;
			break;
		}

		if (ch == '+') token = PLUS;
		else if (ch == '-') token = MINUS;
		else if (ch == '*') token = MUL;
		else if (ch == '/') token = DIV;
		else if (ch == '(') token = LPAREN;
		else if (ch == ')') token = RPAREN;
		else if (ch == '!') token = EXCLAMATION;

		advance();
		if (token) break;
	}
}
/* - lexer */

/* parser */
lit(){
	extrn puts;
	auto v;

	if(
		token != NUMBER & 
		token != MINUS &
		token != PLUS
	) expected("NUMBER or MINUS or PLUS");

	v = number;
	if(token == MINUS){
		next();
		v = -number;
	}
	else if(token == PLUS){
		next();
		v = number;
	}

	next();

	return v;
}

factor(){
	extrn puts, expr, printf;
	auto v, not;
	not = 0;

	if(token == EXCLAMATION){
		not = 1;
		next();
	}

	if(token == LPAREN){
		next();
		
		v = expr();

		if(token != RPAREN) expected("RPAREN");

		next();
		if(not) v = !v;
		return v;
	}

	v = lit();
	if(not) v = !v;
	return v;
}

term(){
	auto left, right, op;

	left = factor();
	
	op = token;
	while(op == MUL | op == DIV){
		next();

		right = factor();

		if(op == MUL){
			left *= right;
		} else if(op == DIV){
			left /= right;
		}
		op = token;
		if(!op) break;
	}
	return left;
}

expr(){
	auto left, right, op;

	left = term();
	
	op = token;
	while(op == PLUS | op == MINUS){
		next();

		right = term();

		if(op == PLUS){
			left += right;
		} else if(op == MINUS){
			left -= right;
		}
		op = token;
		if(!op) break;
	}
	return left;
}
/* - parser */

main(){
	extrn printf;

	auto iota, result;
	iota = 1;
	error = 0;

	NUMBER = ++iota;
	PLUS = ++iota;
	MINUS = ++iota;
	MUL = ++iota;
	DIV = ++iota;
	LPAREN = ++iota;
	RPAREN = ++iota;
	EXCLAMATION = ++iota;

	advance();
	if(ch == 0){
		result = 0;
	} else {
		next();
		
		result = expr();
	}

	if(!error) printf("%ld*n", result);
	return error;
}
