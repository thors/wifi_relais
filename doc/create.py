import sys,os

def system(command):
    print(command)
    os.system(command)

def dot2png():
    for (root, folders, files) in os.walk("."):
        for f in files:
            if f.lower().find(".dot") > 0:
                ifn = root + os.sep + f;
                ofn = ifn.lower().replace(".dot",".png");
                system("dot -Tpng " + ifn + " > " + ofn);
                ofn = ifn.lower().replace(".dot",".eps");
                system("dot -Teps " + ifn + " > " + ofn);

def latex(): 
    system("pdflatex main.tex")
    system("makeindex main.idx")
    system("pdflatex main.tex")

def clear():                
    system("rm -f main.aux main.dvi main.idx main.ilg main.ind main.lof main.log main.lot main.toc")

def main():                
    clear()
    dot2png()
    latex()

main()
