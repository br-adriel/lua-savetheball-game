local love = require("love")
local Inimigo = require("Inimigo")

math.randomseed(os.time())

local jogo = {
  dificuldade = 1,
  estado = {
    menu = false,
    pausado = false,
    rodando = true,
    finalizado = false,
  }
}

local jogador = {
  raio = 20,
  x = 30,
  y = 30,
}

local inimigos = {}

function love.load()
  love.mouse.setVisible(false)

  table.insert(inimigos, 1, Inimigo())
end

function love.update(dt)
  jogador.x, jogador.y = love.mouse.getPosition()

  for i = 1, #inimigos do
    inimigos[i]:move(jogador.x, jogador.y)
  end
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

    for i = 1, #inimigos do
      inimigos[i]:draw()
    end
  end

  if not jogo.estado.rodando then
    love.graphics.circle("fill", jogador.x, jogador.y, jogador.raio / 2)
  end
end
