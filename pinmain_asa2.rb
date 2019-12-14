# coding: utf-8
require 'dxopal'
include DXOpal

require_remote 'ball.rb'
require_remote 'bumper.rb'
require_remote 'r-flipper.rb'
require_remote 'l-flipper.rb'

Image.register(:player, 'images/ball.png') 
Image.register(:enemy, 'images/bumper.png')
Image.register(:enemy2, 'images/bumper2.png')
Image.register(:flipper, 'images/flipper.png')
Image.register(:tit, 'images/title.png')
Image.register(:back, 'images/background.png')

Window.load_resources do
  Window.width  = 400
  Window.height = 1000

  GAME_INFO = {
  scene: :title,  # 現在のシーン(起動直後は:title)
  }

  player_img = Image[:player]
  flipper_img = Image[:flipper]
  player_img.set_color_key([0, 0, 0])
  title_img = Image[:tit]
  background_img = Image[:back]

  enemy_img = Image[:enemy]
  enemy2_img = Image[:enemy2]
  enemy_img.set_color_key([0, 0, 0])

  #配列---------------------------------------
  players = []
  enemies = []
  items = []
  flippers_r = []
  flippers_l = []
  #---------------------------------------------
  
  #実体の生成-----------------------------------
  players << Player.new(400, 50, player_img,-1, 1)
  flippers_r << Rflipper.new(390, 700, flipper_img)
  flippers_l << Lflipper.new(10, 700, flipper_img)

  font = Font.new(30)
  pt = 0
  iuni = 2
  uni = iuni #残機
  
  Window.loop do
     Window.draw(0,0,background_img)
    #if Input.key_push?(K_R)
   #     break
    #end
    case GAME_INFO[:scene]
    when :title
      # タイトル画面
      Window.draw(0,0,title_img)
      Window.draw_font(120, 450, "PRESS KEY", Font.default)
      Window.draw_font(120, 500, "☆1　☆2", Font.default)
      # スペースキーが押されたらシーンを変える
      if Input.key_push?(K_1)
        enemies[0] = Enemy.new(200, 80, enemy_img)
        enemies[1] = Enemy.new(100, 220, enemy_img)
        enemies[2] = Enemy.new(300, 220, enemy_img)
        GAME_INFO[:scene] = :playing
      
      elsif Input.key_push?(K_2)
        enemies[0] = Enemy.new(200, 80, enemy2_img)
        enemies[1] = Enemy.new(100, 220, enemy2_img)
        enemies[2] = Enemy.new(300, 220, enemy2_img)
        GAME_INFO[:scene] = :playing2
      end
      
      
    when :playing
        #プレイ画面
        Window.draw_font(10,10,"得点:#{pt} Rキーでリスタート",font)
        Window.draw_font(10,40,"ボール:#{uni}",font)
        Sprite.update(enemies)
        Sprite.draw(enemies)
        Sprite.draw(items)
       # if Input.key_down?(K_SPACE) #デバッグ用　コマ送り
            Sprite.update(players)
        #end
        if Input.key_push?(K_R)
            player = Player.new(400, 50, player_img,1, 1)
            players = [player]
        end

    #操作----------------------------------------
    if Input.key_down?(K_RIGHT)
        flippers_r[0].setflag(1)
    else
        flippers_r[0].setflag(0)
    end
    if Input.key_down?(K_LEFT)
        flippers_l[0].setflag(1)
    else
        flippers_l[0].setflag(0)
    end

        #player.update
        Sprite.update(flippers_r)
        Sprite.update(flippers_l)
        Sprite.draw(players)
        Sprite.draw(flippers_r)
        Sprite.draw(flippers_l)
        
        # 当たり判定
        if players[0] === items
            players[0].change_x(4)
            items[0].vanish
        end
        
        if players[0] === enemies
            pt += 1
            if pt % 100 == 0
                uni += 1
            end
            
            if pt % 50 == 0
                item = Enemy.new(220, 150, enemy_img)
                items = [item]            
                end
        end
        Sprite.check(players, enemies)
        
        if players[0] === flippers_r
            players[0].change_x(flippers_r[0].ang_flag)
        end
        
        if players[0] === flippers_l
            players[0].change_x(flippers_l[0].ang_flag)
        end
        
        if players[0] === enemies
            players[0].change_x(8)
        end
        Sprite.check(players, flippers_r)
        Sprite.check(players, flippers_l)
        
        if players[0].y >= Window.height - players[0].image.height*players[0].scale_y && uni != 0
            uni -= 1
            GAME_INFO[:scene] = :restart
        end
        if uni == 0
            GAME_INFO[:scene] = :game_over
        end
        
        when :playing2
        #プレイ画面(map2)
        Window.draw_font(10,10,"得点:#{pt} Rキーでリスタート",font)
        Window.draw_font(10,40,"ボール:#{uni}",font)
        Sprite.update(enemies)
        Sprite.draw(enemies)
        Sprite.draw(items)
       # if Input.key_down?(K_SPACE) #デバッグ用　コマ送り
            Sprite.update(players)
        #end
        if Input.key_push?(K_R)
            player = Player.new(400, 50, player_img,1, 1)
            players = [player]
        end

    #操作----------------------------------------
    if Input.key_down?(K_RIGHT)
        flippers_r[0].setflag(1)
    else
        flippers_r[0].setflag(0)
    end
    if Input.key_down?(K_LEFT)
        flippers_l[0].setflag(1)
    else
        flippers_l[0].setflag(0)
    end

        #player.update
        Sprite.update(flippers_r)
        Sprite.update(flippers_l)
        Sprite.draw(players)
        Sprite.draw(flippers_r)
        Sprite.draw(flippers_l)
        
        # 当たり判定
        if players[0] === items
            players[0].change_x(4)
            items[0].vanish
        end
        
        if players[0] === enemies
            pt += 1
            if pt % 100 == 0
                uni += 1
            end
            
            if pt % 50 == 0
                item = Enemy.new(220, 150, enemy_img)
                items = [item]            
                end
        end
        Sprite.check(players, enemies)
        
        if players[0] === flippers_r
            players[0].change_x(flippers_r[0].ang_flag)
        end
        
        if players[0] === flippers_l
            players[0].change_x(flippers_l[0].ang_flag)
        end
        
        if players[0] === enemies
            players[0].change_x(8)
        end
        Sprite.check(players, flippers_r)
        Sprite.check(players, flippers_l)
        
        if players[0].y >= Window.height - players[0].image.height*players[0].scale_y && uni != 0
            uni -= 1
            GAME_INFO[:scene] = :restart
        end
        if uni == 0
            GAME_INFO[:scene] = :game_over
        end
        
    when :restart
        Window.draw_font(0, 30, "REPLAY PRESS SPACE_KEY", Font.default)

        # スペースキーが押されたらゲームの状態をリセットし、シーンを変える
        if Input.key_push?(K_SPACE)
          player = Player.new(400, 50, player_img,1, 1)
          players = [player]
          GAME_INFO[:scene] = :playing
        end
    
    when :game_over
      # ゲームオーバー画面
      Window.draw_font(0, 30, "GAME OVER", Font.default)
      Window.draw_font(0, 60, "SCORE:#{pt}", Font.default)
      Window.draw_font(0, 90, "REPLAY PRESS SPACE_KEY", Font.default)
      Window.draw_font(0, 120, "TITLE PRESS T_KEY",Font.default)
      
      # スペースキーが押されたらゲームの状態をリセットし、シーンを変える
      if Input.key_push?(K_SPACE)
        player = Player.new(400, 50, player_img,1, 1)
        players = [player]
        pt = 0
        uni = iuni
        GAME_INFO[:scene] = :playing
      end
      
      if Input.key_push?(K_T)
        player = Player.new(400, 50, player_img,1, 1)
        players = [player]
        pt = 0
        uni = iuni
        GAME_INFO[:scene] = :title
      end
      
    end
  end
end