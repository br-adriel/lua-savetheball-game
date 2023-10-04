local love = require("love")

function Enemy()
  local dado = math.random(1, 4)
  local _x, _y
  local _raio = 20

  if dado == 1 then
    _x = math.random(_raio, love.graphics.getWidth())
    _y = -_raio * 4
  elseif dado == 2 then
    _x = -_raio * 4
    _y = math.random(_raio, love.graphics.getHeight())
  elseif dado == 3 then
    _x = math.random(_raio, love.graphics.getWidth())
    _y = love.graphics.getHeight() + _raio * 4
  else
    _x = love.graphics.getWidth() + _raio * 4
    _y = math.random(_raio, love.graphics.getHeight())
  end

  return {
    nivel = 1,
    raio = _raio,
    x = _x,
    y = _y,

    move = function(self, jogador_x, jogador_y)
      if jogador_x - self.x > 0 then
        self.x = self.x + self.nivel
      elseif jogador_x - self.x < 0 then
        self.x = self.x - self.nivel
      end

      if jogador_y - self.y > 0 then
        self.y = self.y + self.nivel
      elseif jogador_y - self.y < 0 then
        self.y = self.y - self.nivel
      end
    end,

    draw = function(self)
      love.graphics.setColor(1, 0.5, 0.7)
      love.graphics.circle("fill", self.x, self.y, self.raio)
      love.graphics.setColor(1, 1, 1)
    end
  }
end

return Enemy
