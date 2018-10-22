Score=Struct.new(:set,:game,:point)

def count(winer,oncebefore)
  
  #����ݒ�
  
  server=Score.new
  receiver=Score.new
  case winer
    when 0;loser=1
    when 1;loser=0
  end
  score=[server,receiver]
  
  #���
  
  if oncebefore.split(/,/)[-3]
    sets=oncebefore.split(/,/)[-3].split(/-/) 
    server.set=sets[0].to_i;receiver.set=sets[1].to_i
  end
  
  if oncebefore.split(/,/)[-2]
    if oncebefore.split(/,/)[-2]=~/6-6/
      if ! (oncebefore.split(/,/)[-1]=~/Deuce/)
        if ! (oncebefore.split(/,/)[-1].index("A"))
          tiebreak=true
        end
      end
    end
    games=oncebefore.split(/,/)[-2].split(/-/)
    server.game=games[0].to_i;receiver.game=games[1].to_i
  end
  
  
  points=oncebefore.split(/,/)[-1]
  if points=~/Deuce/
    server.point=3
    receiver.point=3
  else
    server.point,receiver.point=points.split(/-/)
    if tiebreak
      server.point=server.point.to_i
      receiver.point=receiver.point.to_i
    elsif
      server.point=trans(server.point)
      receiver.point=trans(receiver.point)
    end
  end
  
  
  #�v�Z
  
  score[winer].point+=1
  
  if tiebreak
    if score[winer].point==7
      score[winer].point=0
      score[loser].point=0
      score[winer].game=0
      score[loser].game=0
      score[winer].set+=1
    end
  elsif score[winer].point==4
    unless score[loser].point==3
      score[winer].point=0
      score[loser].point=0
      score[winer].game+=1
      
      a=(score[winer].game==6 and (score[loser].game!=6 and score[loser].game!=5))
      b=score[winer].game==7
      if a or b
        score[winer].game=0
        score[loser].game=0
        score[winer].set+=1
      end
    end
  end
  
  #�o��
  
  if tiebreak
    if server.point==6 and receiver.point==6
      pointstr="Deuce"
    else
      pointstr=server.point.to_s+"-"+receiver.point.to_s
    end
  elsif server.point==3 and receiver.point==3
    pointstr="Deuce"
  elsif score[winer].point==4 and score[loser].point==3
    pointstr="A- " if winer==0
    pointstr=" -A" if winer==1
  else
    pointstr=trans(server.point)+"-"+trans(receiver.point)
  end
  
  gamestr=server.game.to_s+"-"+receiver.game.to_s if server.game
  setstr=server.set.to_s+"-"+receiver.set.to_s if server.set
  
  scorestr=pointstr
  scorestr=gamestr+","+scorestr if gamestr
  scorestr=setstr+","+scorestr if setstr
  
  p scorestr
  
end

def trans (point)
  case point
    when "A";3
    when " ";2
    when "40";3
    when "30";2
    when "15";1
    when "0";0
    when 0;"0"
    when 1;"15"
    when 2;"30"
    when 3;"40"
  end
end





count(0,"6-6, -A")
