local love = require("love")
local Inimigo = require("Inimigo")
local Botao = require("Botao")

math.randomseed(os.time())

local jogo = {
  dificuldade = 1,
  estado = {
    menu = true,
    rodando = false,
    finalizado = false,
  },
  niveis = { 15, 30, 60, 120, }
}

local fontes = {
  media = {
    fonte = love.graphics.newFont(16),
    tamanho = 16,
  },
  grande = {
    fonte = love.graphics.newFont(24),
    tamanho = 24,
  },
  gigante = {
    fonte = love.graphics.newFont(60),
    tamanho = 60,
  },
}

local jogador = {
  raio = 20,
  x = 30,
  y = 30,
  pontos = 0,
}

local botoes = {
  estado_menu = {},
  estado_finalizado = {},
}

local inimigos = {}

local function mudarEstadoJogo(estado)
  jogo.estado.finalizado = estado == "finalizado"
  jogo.estado.menu = estado == "menu"
  jogo.estado.rodando = estado == "rodando"
end

local function iniciarNovoJogo()
  mudarEstadoJogo("rodando")

  jogador.pontos = 0
  inimigos = {
    Inimigo(1)
  }
end

function love.mousepressed(x, y, button, isTouch, presses)
  if not jogo.estado.rodando then
    if button == 1 then
      if jogo.estado.menu then
        for index in pairs(botoes.estado_menu) do
          botoes.estado_menu[index]:checkPressed(x, y, jogador.raio)
        end
      elseif jogo.estado.finalizado then
        for index in pairs(botoes.estado_finalizado) do
          botoes.estado_finalizado[index]:checkPressed(x, y, jogador.raio)
        end
      end
    end
  end
end

function love.load()
  love.mouse.setVisible(false)

  botoes.estado_menu.jogar = Botao("Jogar", iniciarNovoJogo, nil, 160, 40)
  botoes.estado_menu.sair = Botao("Sair", love.event.quit, nil, 160, 40)

  botoes.estado_finalizado.jogar_novamente = Botao("Jogar novamente", iniciarNovoJogo, nil, 240, 50)
  botoes.estado_finalizado.menu = Botao("Menu", mudarEstadoJogo, "menu", 240, 50)
  botoes.estado_finalizado.sair = Botao("Sair", love.event.quit, nil, 240, 50)
end

function love.update(dt)
  jogador.x, jogador.y = love.mouse.getPosition()

  -- atualiza posicao dos inimigos
  if jogo.estado.rodando then
    for i = 1, #inimigos do
      if inimigos[i]:checkTouched(jogador.x, jogador.y, jogador.raio) then
        mudarEstadoJogo("finalizado")
      else
        for i = 1, #jogo.niveis do
          if (math.floor(jogador.pontos)) == jogo.niveis[i] then
            table.insert(inimigos, 1, Inimigo(jogo.dificuldade * (i + 1)))
            jogador.pontos = jogador.pontos + 1
          end
        end

        inimigos[i]:move(jogador.x, jogador.y)
      end
    end
    jogador.pontos = jogador.pontos + dt
  end
end

function love.draw()
  -- love.graphics.scale(1.5, 1.5)

  love.graphics.setFont(fontes.media.fonte)

  love.graphics.printf(
    "FPS: " .. love.timer.getFPS(),
    fontes.media.fonte,
    5,
    love.graphics.getHeight() - 25,
    love.graphics.getWidth()
  )

  if jogo.estado.rodando then
    love.graphics.printf(
      math.floor(jogador.pontos), fontes.grande.fonte,
      0, 10, love.graphics.getWidth(), "center"
    )

    love.graphics.circle("fill", jogador.x, jogador.y, jogador.raio)

    for i = 1, #inimigos do
      inimigos[i]:draw()
    end
  elseif jogo.estado.menu then
    botoes.estado_menu.jogar:draw(10, 20, 17, 10)
    botoes.estado_menu.sair:draw(10, 70, 17, 10)
  elseif jogo.estado.finalizado then
    love.graphics.setFont(fontes.grande.fonte)

    botoes.estado_finalizado.jogar_novamente:draw(
      love.graphics.getWidth() / 2 - 120,
      love.graphics.getHeight() / 2,
      17,
      10
    )
    botoes.estado_finalizado.menu:draw(
      love.graphics.getWidth() / 2 - 120,
      love.graphics.getHeight() / 2 + 10 + 50,
      17,
      10
    )
    botoes.estado_finalizado.sair:draw(
      love.graphics.getWidth() / 2 - 120,
      love.graphics.getHeight() / 2 + 2 * (10 + 50),
      17,
      10
    )

    love.graphics.printf(
      math.floor(jogador.pontos),
      fontes.gigante.fonte,
      0,
      love.graphics.getHeight() / 2 - fontes.gigante.tamanho - 10,
      love.graphics.getWidth(),
      "center"
    )
  end

  if not jogo.estado.rodando then
    love.graphics.circle("fill", jogador.x, jogador.y, jogador.raio / 2)
  end
end
