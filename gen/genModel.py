import sys
import csv

with open(sys.argv[1], newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter='|', quotechar='|')
    for row in reader:
        if len(row) == 3: # proper row
            vName = row[0]
            vNameCapital = row[0].title()
            vType = row[1]
            vDefaultValue = row[2]
            print("static "+vType+" "+vName+"() {") # static double coins() { 
            print("return getBox().get(\""+vName+"\",defaultValue:"+vDefaultValue+");}") # return getBox().get("coins",defaultValue: 1.0);}
            print("static void update"+vNameCapital+"("+vType+" "+vName+") {") # static void coins() { 
            print("getBox().put(\""+vName+"\","+vName+");}") # getBox().put("hotbarShop",hotbarShop);