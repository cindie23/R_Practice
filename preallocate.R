##preallocate

#NA有四種類型NA_integer_, NA_real_, NA_complex_ and NA_character_
#分別是整數、帶小數的數、複數跟字元的NA類別
#不同NA類別會給vector不同類型的儲存大小、儲存類型
#給一個適當的NA也是一個好方法
#另外，一般的NA是NA_character_
(s2 = vector('list', 3))
(x = rep(NA_real_, 10))




##https://www.ptt.cc/bbs/R_Language/M.1437916508.A.C27.html