local love = require("love")
local Inimigo = require("Inimigo")
local Botao = require("Botao")

math.randomseed(os.time())

local jogo = {
  dificuldade = 1,
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

local botoes = {
  estado_menu = {}
}

local inimigos = {}

local function iniciarNovoJogo()
  -- atualiza estado do jogo
  jogo.estado.menu = false;
  jogo.estado.rodando = true;

  -- gera inimigos
  table.insert(inimigos, 1, Inimigo())
end

function love.mousepressed(x, y, button, isTouch, presses)
  if not jogo.estado.rodando then
    if button == 1 then
      if jogo.estado.menu then
        for index in pairs(botoes.estado_menu) do
          botoes.estado_menu[index]:checkPressed(x, y, jogador.raio)
        end
      end
    end
  end
end

function love.load()
  love.mouse.setVisible(false)

  botoes.estado_menu.jogar = Botao("Jogar", iniciarNovoJogo, nil, 120, 40)
  botoes.estado_menu.configuracoes = Botao("Configurações", nil, nil, 120, 40)
  botoes.estado_menu.sair = Botao("Sair", love.event.quit, nil, 120, 40)
end

function love.update(dt)
  jogador.x, jogador.y = love.mouse.getPosition()

  -- atualiza posicao dos inimigos
  if jogo.estado.rodando then
    for i = 1, #inimigos do
      inimigos[i]:move(jogador.x, jogador.y)
    end
  end
end

function love.draw()
  love.graphics.scale(1.5, 1.5)

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
  elseif jogo.estado.menu then
    botoes.estado_menu.jogar:draw(10, 20, 17, 10)
    botoes.estado_menu.configuracoes:draw(10, 70, 17, 10)
    botoes.estado_menu.sair:draw(10, 120, 17, 10)
  end

  if not jogo.estado.rodando then
    love.graphics.circle("fill", jogador.x, jogador.y, jogador.raio / 2)
  end
end
