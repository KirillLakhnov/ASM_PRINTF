extern "C" void myprintf(const char*, ...);

int main ()
{
    int number = 1000;
    int hex_number = 0xDEAD;
    char string[] = "I fucking TimaSuck\0";
    char ch = 'I';
    int number_2 = 'a';
    
    myprintf ("\n\n\n%s %d times and he is %x INSIDE, \n%c'%c with love, 100%%, 31 == %b,\n%s\n\n %d %s %x %d%%%c%b\n", 
                string, number, hex_number, ch, 'm', 31, "QWERTYIOPASDFGHJKLZ", -1, "love", 3802, 100, 33, 127);

    //myprintf ("%d %d %d\n\n\n", -1443, 233434, -1999900);

    return 0;
}