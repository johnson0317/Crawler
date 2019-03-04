# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import requests
from bs4 import BeautifulSoup
#mypara = {'keyword' : '短褲'}
r = requests.get("https://www.ptt.cc/bbs/graduate/index.html") #將此頁面的HTML GET下來
#if r.status_code==requests.codes.ok :
 #   print ("ok")

soup = BeautifulSoup(r.text,"html.parser")
sel = soup.select('div.title a')

for s in sel:
    print(s['href'],s.text)# -*- coding: utf-8 -*-

