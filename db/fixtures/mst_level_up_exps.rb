exp = 0
1.upto(998) do |i|
  exp += i + 1
  MstLevelUpExp.seed do |s|
    s.id = i
    s.level = i + 1
    s.exp = exp
  end
end
