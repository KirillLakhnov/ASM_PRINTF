extern "C" void myprintf(const char*, ...);

int main ()
{
    /*int number = 1000;
    int hex_number = 0xDEAD;
    char string[] = "I fucking TimaSuck\0";
    char ch = 'I';
    int number_2 = 'a';*/
    
    //myprintf ("%s %d times and he is %x INSIDE, \n%c'%c with love, 100%%, 32 == %b,\n%s\n\n", string, number, hex_number, ch, 'm', 31, "QWERTYIOPASDFGHJKLZ");

    //myprintf ("%d %d %d\n", -1443, 233434, -1999900000);

    float flt = 12.34;
    myprintf ("%f", flt);

    return 0;
}