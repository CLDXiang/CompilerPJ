#include <iostream>
#include <string.h>
#include <stdio.h>
#include <iomanip>
#include "lexer.h"
using namespace std;

int yylex();
extern "C" FILE* yyin;
extern "C" char* yytext;
extern string text;
extern int line_leng;
extern int extra_n;
extern int err_code;

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            cerr << "Cannot open file." << endl;
            return 1;
        } else {
            yyin = file;
        }
    } else {
        yyin = stdin;
    }
    
    int row = 1, col = 1;
    int tokens_counter = 0, errors_counter = 0;

    // output header
    cout<<setw(5)<<left<<"Row"<<setw(5)<<left<<"Col"<<setw(20)<<left<<"Type"<<"Token/Error"<<endl;
    
    while (true) {
        int n = yylex();
        string type = "";
        string token = "";
        string error = "";
        if (n == T_EOF) break;
        switch(n) {
            case INTEGER:
                // overflow? (see file test20.pcat)
                type = "integer";
                if (strlen(yytext)>10 || (strlen(yytext)==10 && yytext > "4294967295")) {
                    error = "/Error: An out of range integer!";
                    type = "error";
                }
                token = yytext;
                break;
            case REAL:
                type = "real";
                token = yytext;
                break;
            case WS:
                type = "whitespace";
                token = yytext;
                break;
            case RK:
                type = "reserved keyword";
                token = yytext;
                break;
            case COMMENT:
                type = "comment";
                token = text;
                break;
            case ID:
                type = "identifier";
                if (strlen(yytext) > 255) {
                    error = "/Error: An overly long identifier!";
                    type = "error";
                }
                token = yytext;
                break;
            case OP:
                type = "operator";
                token = yytext;
                break;
            case DE:
                type = "delimiter";
                token = yytext;
                break;
            case STRING:
                type = "string";
                if (text.find('\n') != std::string::npos || text.find('\t') != std::string::npos) {
                    error = "/Error: An invalid string with tab or newline in it!";
                    type = "error";
                }
                else if (text.length() > 257) {
                    error = "/Error: An overly long string!";
                    type = "error";
                }
                token = text;
                break;
            case NEWLINE:
                type = "return";
                break;
            case ERR:
                type = "error";
                switch(err_code) {
                    case 0:
                        error = "Error: A bad character (bell)!";
                        break;
                    case 1:
                        error = "Error: An unterminated string!";
                        break;
                    case 2:
                        error = "Error: An unterminated comment!";
                        break;
                }
                break;
            default:
                type = "error";
                token = yytext;
        }
        
        // print (rows and cols?)
        if (n != WS && n != NEWLINE && n != COMMENT) {
            cout<<setw(5)<<left<<row<<setw(5)<<left<<col<<setw(20)<<left<<type<<token<<error<<endl;
            tokens_counter++;
        }

        if (n == COMMENT || n == STRING) {
            row += extra_n;
            col += line_leng;
        } else {
            col += token.length();
        }
        
        if (n == RETURN) {
            row++;
            col = 1;
        }
    }
    
    // count num of tokens and errors?
    cout<<"Num of tokens: "<<tokens_counter<<endl; 
    
    return 0;
}
