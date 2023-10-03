local love = require("love")

local jogo = {
  estado = {
    menu = true,
    pausado = false,
    rodando = false,
    finalizado = false,
  }
}

local jogador = {
  raio = 20,
  x = 30,
  y = 30,
}

function love.load()

end

function love.update(dt)
  jogador.x, jogador.y = love.mouse.getPosition()
end

function love.draw()
  love.graphics.circle("fill", jogador.x, jogador.y, jogador.raio)
end
