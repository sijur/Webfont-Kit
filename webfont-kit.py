#!/usr/bin/env python

# libraries used
import sys
import os

def main(*args):
    # find out what file type we're working with.
    print("Number of arguments {}.".format(len(args)))
    if len(args) >= 1:
        file_path = args[0][1]
        file_extension = file_path.split('.')[-1]
    else:
        print("No file provided.")

    curr_dir = os.getcwd()
    ttf_convert_path = os.path.join(curr_dir, 'lib', 'convert-ttf.py')
    
    # determine which function we're sending this to.
    if file_extension == 'ttf':
        
        print("TTF file detected.")
        ttf_convert_path.main(args)
    elif file_extension == 'otf':
        print("OTF file detected.")
    else:
        print("File type not supported.")


if __name__ == '__main__':
    sys.exit(main(sys.argv))