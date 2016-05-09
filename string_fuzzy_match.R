library(RecordLinkage)
library(dplyr)

ref <- c('cat', 'dog', 'turtle', 'cow', 'horse', 'pig', 'sheep', 'koala','bear','fish')
words <- c('dog', 'kiwi', 'emu', 'pig', 'sheep', 'cow','cat','horse')


ref = 'NB/PAD RF�L�u�q�T�į��������'
words = 'NB/PAD RF�L�u�q�T�Ҳվ�X����'

##match to each one
wordlist <- expand.grid(words = words, ref = ref, stringsAsFactors = FALSE)
##find the best matched element
##group�D�n�O���Ӱ�dplyr���F��
wordlist %>% group_by(words) %>% mutate(match_score = jarowinkler(words, ref)) %>%
  summarise(match = match_score[which.max(match_score)], matched_to = ref[which.max(match_score)])

## > 0.9 < 1 

fuzzy_matching = wordlist %>% mutate(match_score = jarowinkler(words, ref))
fuzzy_matching = fuzzy_matching[order(fuzzy_matching$match_score),]
fuzzy_matching = fuzzy_matching[which(fuzzy_matching$match_score >=0.9 & fuzzy_matching$match_score < 1),]
if(nrow(fuzzy_matching)>0){
  
}