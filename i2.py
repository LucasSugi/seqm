from pandas import DataFrame
from os import getlogin

df  = DataFrame({"LOGIN" : ["ADRIBEZ" ,"ALEXCAJ" ,"ANACRVI" ,"CAROCOE" ,"CRISLIM" ,"ALVESOU" ,"HENRCOI" ,"JOAOJSC" ,"JULIAMA" ,"JULBASC" ,"LEONSAM" ,"LUOLIVE" ,"LUIMATS" ,"MATHMAR" ,"MARINAC" ,"MEIREAD" ,"PATRODR" ,"EDUABEL" ,"ROSIBRI" ,"SUELARA" ,"VICTVUL" ,"VINMACE" ,"GUIMEI","LUCASUG"], "PWD": ["Safra445","Safra949","Safra110","Safra571","Safra398","Safra828","Safra249","Safra983","Safra126","Safra235","Safra460","Safra256","Safra250","Safra995","Safra284","Safra714","Safra345","Safra871","Safra777","Safra495","Safra140","Safra971","Safra276","Safra123"]})

login = df.loc[df["LOGIN"] == getlogin().upper(),"LOGIN"].values[0]
pwd = df.loc[df["LOGIN"] == getlogin().upper(),"PWD"].values[0]

print(f"\nLOGIN: {login}\nSENHA: {pwd}")