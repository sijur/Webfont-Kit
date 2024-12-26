#!/usr/bin/env python

# libraries used
import sys

class ConvertTTF(ConvertFont):
    def __init__(self, *args):
        super().__init__(*args)
    
    def main(self, *args):
        pass

if __name__ == '__main__':
    sys.exit(ConvertTTF().main(sys.argv))