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
  love.mouse.setVisible(false)
end

function love.update(dt)
  jogador.x, jogador.y = love.mouse.getPosition()
end

function love.draw()
  love.graphics.printf(
    "FPS: " .. love.timer.getFPS(),
    love.graphics.newFont(16),
    5,
    love.graphics.getHeight() - 25,
    love.graphics.getWidth()
  )

  if jogo.estado.rodando then
    love.graphics.circle("fill", jogador.x, jogador.y, jogador.raio)
  end

  if not jogo.estado.rodando then
    love.graphics.circle("fill", jogador.x, jogador.y, jogador.raio / 2)
  end
end
