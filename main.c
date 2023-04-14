extern void _printf(const char*, ...);

int main ()
{
    int number = 1000;
    int hex_number = 0xDEAD;
    char string[] = "I fucking TimaSuck\0";
    char ch = 'I';
    int number_2 = -89;
    
    _printf ("%s %d times and he is %x INSIDE, \n%c'%c with love, 100%%, -89 == %o, 235 == %b", string, number, hex_number, ch, 'm', number_2, 235);

    return 0;
}