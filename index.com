<!DOCTYPE html>
<html lang="pt-BR" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Laura Gimenez dos Santos — Portfólio</title>
<meta name="description" content="Portfólio pessoal de Laura Gimenez dos Santos, estudante de Técnico em Informática para Internet em Varginha, MG.">

<!-- Fontes do Google Fonts: Space Grotesk (títulos) e Inter (texto) -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

<style>
  /* ======================================================================
     VARIÁVEIS DE COR (paleta "Algodão Doce")
     Tudo declarado aqui como variável CSS, para o tema claro e o escuro.
     O tema escuro é uma variação da mesma paleta, criada só para manter
     contraste bom quando a Laura ativar o botão de alternância.
     ====================================================================== */
  :root{
    --bg: #FFF8FB;          /* fundo do tema claro */
    --text: #2E2A3A;        /* texto do tema claro */
    --primary: #B983FF;     /* cor primária (roxo pastel) */
    --secondary: #FFD6E8;   /* cor secundária (rosa pastel) */
    --accent: #3BB273;      /* cor de destaque (verde) */
    --on-primary: var(--text); /* texto usado sobre a cor primária, com contraste garantido */
    --card-bg: #FFFFFF;     /* fundo dos cards (moldura do polaroid) */
    --grid-line: rgba(46, 42, 58, 0.08); /* linha do papel quadriculado */
    --shadow-color: var(--primary);
    --radius-pill: 999px;
    --transicao: 0.5s ease;
  }

  /* Tema escuro: aplicado quando <html data-theme="dark"> */
  html[data-theme="dark"]{
    --bg: #241F30;
    --text: #F7EFFA;
    --primary: #C79BFF;
    --secondary: #4A3350;
    --accent: #56D69A;
    --on-primary: #1B1728;  /* texto escuro sobre o roxo, para manter contraste no tema escuro também */
    --card-bg: #2E2740;
    --grid-line: rgba(247, 239, 250, 0.07);
    --shadow-color: var(--primary);
  }

  /* ======================================================================
     RESET BÁSICO E ESTILOS GERAIS
     ====================================================================== */
  *{ box-sizing: border-box; }

  html{ scroll-behavior: smooth; }

  body{
    margin: 0;
    background-color: var(--bg);
    color: var(--text);
    font-family: "Inter", sans-serif;
    line-height: 1.65;
    transition: background-color var(--transicao), color var(--transicao);

    /* Fundo "papel quadriculado": duas grades de linhas finas, uma
       horizontal e uma vertical, sobrepostas com repeating-linear-gradient */
    background-image:
      repeating-linear-gradient(to right, var(--grid-line) 0 1px, transparent 1px 32px),
      repeating-linear-gradient(to bottom, var(--grid-line) 0 1px, transparent 1px 32px);
  }

  h1, h2, h3{
    font-family: "Space Grotesk", sans-serif;
    font-weight: 600;
    margin: 0;
  }

  a{ color: var(--primary); }

  :focus-visible{
    outline: 2px solid var(--accent);
    outline-offset: 3px;
  }

  .wrap{
    max-width: 1080px;
    margin: 0 auto;
    padding: 0 24px;
  }

  /* Respeita quem ativou "reduzir movimento": desliga transições,
     animações e a rolagem suave para essas pessoas */
  @media (prefers-reduced-motion: reduce){
    *{
      animation: none !important;
      transition: none !important;
    }
    html{ scroll-behavior: auto; }
  }

  /* ======================================================================
     BOTÃO DE ALTERNÂNCIA DE TEMA (claro/escuro)
     Fica fixo no canto superior direito, sem menu de navegação.
     ====================================================================== */
  .theme-toggle{
    position: fixed;
    top: 18px;
    right: 18px;
    z-index: 50;
  }

  /* ======================================================================
     ESTILO GERAL DE PÍLULA — usado em botões e links de ação
     ====================================================================== */
  .pill-btn{
    display: inline-block;
    border: 1.5px solid var(--text);
    background: transparent;
    color: var(--text);
    font-family: "Inter", sans-serif;
    font-size: 0.9rem;
    font-weight: 500;
    padding: 10px 20px;
    border-radius: var(--radius-pill);
    cursor: pointer;
    text-decoration: none;
    transition: background-color 0.3s ease, color 0.3s ease, transform 0.3s ease;
  }

  .pill-btn:hover{
    background-color: var(--text);
    color: var(--bg);
    transform: translateY(-2px);
  }

  /* ======================================================================
     TOPO (HERO) — centralizado: foto em cima, nome e frase embaixo
     ====================================================================== */
  .hero{
    position: relative;
    overflow: hidden;
    text-align: center;
    padding: 100px 24px 90px;
    isolation: isolate; /* garante que a luz fique atrás do conteúdo */
  }

  /* Luz que segue o cursor (ou o toque, no celular).
     A posição é controlada pelo JavaScript através das variáveis
     --mx e --my, atualizadas a cada movimento. */
  .hero-light{
    position: absolute;
    inset: 0;
    z-index: -1;
    background: radial-gradient(
      circle at var(--mx, 50%) var(--my, 20%),
      color-mix(in srgb, var(--primary) 35%, transparent) 0%,
      transparent 55%
    );
    pointer-events: none;
  }

  .avatar-frame{
    width: 160px;
    height: 160px;
    margin: 0 auto 32px;
    position: relative;
  }

  .avatar-frame img,
  .avatar-fallback{
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    background-color: var(--secondary);
    border: 2px solid var(--text);
    /* Sombra dura deslocada, sem desfoque, como pedido no briefing */
    box-shadow: 10px 10px 0 var(--shadow-color);
  }

  .avatar-fallback{
    display: none; /* só aparece se a imagem "foto-laura.jpg" não existir */
    align-items: center;
    justify-content: center;
    font-family: "Space Grotesk", sans-serif;
    font-size: 2.4rem;
    font-weight: 700;
    color: var(--text);
  }

  /* Nome clicável: dispara o confete quando clicado (detalhe divertido) */
  .hero h1{
    font-size: clamp(2.2rem, 6vw, 3.4rem);
    cursor: pointer;
    user-select: none;
  }

  .hero .frase{
    max-width: 44ch;
    margin: 22px auto 0;
    font-size: 1.15rem;
    color: var(--text);
  }

  .hero .dica-clique{
    margin-top: 14px;
    font-size: 0.8rem;
    color: var(--text);
    opacity: 0.6;
  }

  /* ======================================================================
     DIVISOR EM FORMA DE ONDA — usado entre as seções
     ====================================================================== */
  .wave-divider{
    line-height: 0;
    margin: 0;
  }

  .wave-divider svg{
    display: block;
    width: 100%;
    height: 50px;
  }

  /* ======================================================================
     ANIMAÇÃO DE ENTRADA AO ROLAR — alterna esquerda/direita
     A classe final (is-visible) é adicionada pelo JavaScript quando a
     seção entra na tela, usando IntersectionObserver.
     ====================================================================== */
  .reveal{
    opacity: 0;
    transition: opacity 0.6s ease, transform 0.6s ease;
  }

  .reveal.reveal-left{ transform: translateX(-48px); }
  .reveal.reveal-right{ transform: translateX(48px); }

  .reveal.is-visible{
    opacity: 1;
    transform: translateX(0);
  }

  /* ======================================================================
     SEÇÕES GERAIS
     ====================================================================== */
  section{
    padding: 70px 0;
  }

  .section-titulo{
    font-size: clamp(1.6rem, 3vw, 2.1rem);
    margin-bottom: 12px;
  }

  .section-intro{
    max-width: 60ch;
    color: var(--text);
    opacity: 0.85;
    margin-bottom: 40px;
  }

  /* ======================================================================
     SOBRE MIM
     ====================================================================== */
  .sobre-conteudo{
    display: grid;
    grid-template-columns: 1.4fr 1fr;
    gap: 40px;
    align-items: start;
  }

  .sobre-conteudo p{ max-width: 62ch; }
  .sobre-conteudo p + p{ margin-top: 16px; }

  .info-card{
    background: var(--card-bg);
    border: 1.5px solid var(--text);
    border-radius: 18px;
    padding: 26px;
  }

  .info-card h3{
    font-size: 1.05rem;
    margin-bottom: 14px;
  }

  .info-card ul{
    list-style: none;
    margin: 0 0 20px;
    padding: 0;
  }

  .info-card li{
    padding-left: 18px;
    position: relative;
    margin-bottom: 8px;
    font-size: 0.95rem;
  }

  /* Marcador em formato de bolinha: junto com o ícone de pata no rodapé,
     é o "detalhe que só existe" na página de Laura (o gato é o animal
     favorito dela, mencionado logo abaixo, na curiosidade) */
  .info-card li::before{
    content: "";
    position: absolute;
    left: 0;
    top: 7px;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent);
  }

  .curiosidade{
    border-top: 1.5px dashed var(--grid-line);
    padding-top: 16px;
    font-size: 0.92rem;
  }

  .curiosidade strong{ color: var(--primary); }

  .objetivo-link{
    display: inline-block;
    margin-top: 4px;
    font-size: 0.9rem;
  }

  /* ======================================================================
     MINHAS ENTREGAS — mosaico de cards estilo polaroid
     ====================================================================== */
  .entregas-grid{
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-auto-rows: minmax(150px, auto);
    gap: 26px;
  }

  /* Tamanhos diferentes para criar o efeito de painel/mosaico */
  .card--1{ grid-column: span 2; grid-row: span 2; }
  .card--2{ grid-column: span 2; grid-row: span 1; }
  .card--3{ grid-column: span 1; grid-row: span 1; }
  .card--4{ grid-column: span 1; grid-row: span 1; }
  .card--5{ grid-column: span 2; grid-row: span 1; }

  .polaroid{
    position: relative;
    overflow: hidden;
    background: var(--card-bg);
    border: 1px solid var(--grid-line);
    border-radius: 4px;
    padding: 14px 14px 18px;
    box-shadow: 4px 4px 0 rgba(46, 42, 58, 0.08);
    display: flex;
    flex-direction: column;
    transition: transform 0.4s ease;
  }

  .polaroid:hover{ transform: translateY(-4px); }

  /* Efeito "brilho atravessa o card" ao passar o mouse */
  .polaroid::after{
    content: "";
    position: absolute;
    top: 0;
    left: -75%;
    width: 45%;
    height: 100%;
    background: linear-gradient(
      120deg,
      transparent,
      color-mix(in srgb, var(--bg) 70%, transparent),
      transparent
    );
    transform: skewX(-20deg);
    transition: left 0.6s ease;
    pointer-events: none;
  }

  .polaroid:hover::after{ left: 125%; }

  .polaroid-foto{
    flex: 1;
    min-height: 70px;
    border-radius: 2px;
    background: repeating-linear-gradient(
      45deg,
      var(--secondary),
      var(--secondary) 10px,
      color-mix(in srgb, var(--secondary) 60%, var(--bg)) 10px,
      color-mix(in srgb, var(--secondary) 60%, var(--bg)) 20px
    );
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: "Space Grotesk", sans-serif;
    font-size: 0.8rem;
    color: var(--text);
    text-align: center;
    padding: 8px;
  }

  .polaroid-legenda{
    padding-top: 12px;
  }

  .polaroid-numero{
    font-family: "Space Grotesk", sans-serif;
    font-size: 0.75rem;
    color: var(--primary);
  }

  .polaroid-titulo{
    font-family: "Space Grotesk", sans-serif;
    font-size: 1.05rem;
    font-weight: 600;
    margin: 4px 0 6px;
  }

  .polaroid-meta{
    font-size: 0.8rem;
    opacity: 0.75;
    margin-bottom: 6px;
  }

  .polaroid-aprendizado{
    font-size: 0.85rem;
    margin-bottom: 10px;
  }

  .selo{
    display: inline-block;
    font-size: 0.72rem;
    font-weight: 600;
    padding: 3px 10px;
    border-radius: var(--radius-pill);
    border: 1px solid var(--text);
    margin-bottom: 10px;
  }

  .selo--preencher{
    opacity: 0.6;
    border-style: dashed;
  }

  /* Cards ainda sem link/dados definidos ficam com aparência apagada */
  .polaroid.polaroid--pendente{
    opacity: 0.6;
  }

  .polaroid-link{
    font-size: 0.85rem;
    align-self: flex-start;
  }

  /* ======================================================================
     MANIFESTO — fundo na cor primária, texto invertido
     ====================================================================== */
  .manifesto{
    background-color: var(--primary);
    color: var(--on-primary);
    border-radius: 18px;
    padding: 60px 40px;
  }

  .manifesto .section-titulo,
  .manifesto .section-intro{
    color: var(--on-primary);
    opacity: 1;
  }

  .manifesto-texto{
    max-width: 72ch;
    font-size: 1.02rem;
    margin: 0;
  }

  .manifesto-texto + .manifesto-texto{
    margin-top: 16px;
  }

  /* ======================================================================
     RODAPÉ
     ====================================================================== */
  footer{
    padding: 60px 0 50px;
  }

  .rodape-topo{
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: flex-start;
    gap: 30px;
  }

  .rodape-links{
    display: flex;
    flex-direction: column;
    gap: 10px;
    font-size: 0.95rem;
  }

  .rodape-links a{
    text-decoration: none;
    border-bottom: 1.5px solid var(--grid-line);
  }

  .contador-tempo{
    margin-top: 40px;
    font-size: 0.85rem;
    opacity: 0.75;
  }

  .rodape-detalhe{
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 8px;
    font-size: 0.85rem;
    opacity: 0.75;
  }

  .pata-icone{
    width: 16px;
    height: 16px;
    fill: var(--accent);
    flex-shrink: 0;
  }

  /* ======================================================================
     BOTÃO "VOLTAR AO TOPO" — único elemento de navegação da página
     ====================================================================== */
  .voltar-topo{
    position: fixed;
    bottom: 22px;
    right: 22px;
    z-index: 50;
    opacity: 0;
    transform: translateY(10px);
    pointer-events: none;
    transition: opacity 0.3s ease, transform 0.3s ease;
  }

  .voltar-topo.visivel{
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
  }

  /* ======================================================================
     CONFETE — peças criadas dinamicamente pelo JavaScript ao clicar no nome
     ====================================================================== */
  .confete{
    position: fixed;
    top: 0;
    left: 0;
    width: 8px;
    height: 8px;
    z-index: 100;
    pointer-events: none;
    animation: cair 1.6s ease-in forwards;
  }

  @keyframes cair{
    to{
      transform: translateY(70vh) rotate(360deg);
      opacity: 0;
    }
  }

  /* ======================================================================
     RESPONSIVO — testado mentalmente a partir de 360px de largura
     ====================================================================== */
  @media (max-width: 780px){
    .sobre-conteudo{ grid-template-columns: 1fr; }

    .entregas-grid{ grid-template-columns: 1fr; }
    .card--1, .card--2, .card--3, .card--4, .card--5{
      grid-column: span 1;
      grid-row: auto;
    }

    .manifesto{ padding: 40px 24px; }

    .rodape-topo{ flex-direction: column; }
  }
</style>
</head>
<body>

  <!-- Botão de alternância entre tema claro e escuro -->
  <button id="theme-toggle" class="pill-btn theme-toggle">Modo escuro</button>

  <!-- ==========================================================
       CABEÇALHO / TOPO (HERO)
       Centralizado: foto em cima, nome e frase embaixo.
       Contém a luz que segue o cursor/toque.
       ========================================================== -->
  <header class="hero" id="topo">
    <div class="hero-light" id="hero-light" aria-hidden="true"></div>

    <div class="avatar-frame">
      <img src="foto-laura.jpg" alt="Foto de Laura Gimenez dos Santos" id="foto-avatar">
      <div class="avatar-fallback" id="avatar-fallback">LG</div>
    </div>

    <h1 id="nome-clicavel">Laura Gimenez dos Santos</h1>
    <p class="frase">Dando o meu melhor a cada dia, com responsabilidade e criatividade.</p>
    <p class="dica-clique">Clique no meu nome.</p>
  </header>

  <main>

    <!-- ==========================================================
         SEÇÃO: SOBRE MIM
         ========================================================== -->
    <section id="sobre" class="reveal reveal-left">
      <div class="wrap">
        <h2 class="section-titulo">Sobre mim</h2>

        <div class="sobre-conteudo">
          <div>
            <p>Tenho 16 anos e moro na cidade de Varginha, em Minas Gerais.</p>
            <p>Atualmente, sou estudante do Sesi Senai e faço o curso Técnico de Informática para Internet, onde venho desenvolvendo minhas habilidades técnicas e descobrindo novas paixões no universo digital.</p>
          </div>

          <div class="info-card">
            <h3>O que me define</h3>
            <ul>
              <li>Prestativa</li>
              <li>Responsável</li>
              <li>Organizada</li>
            </ul>

            <h3>Objetivo</h3>
            <p style="font-size:0.9rem; margin:0 0 4px;">Quero seguir carreira em UX/UI Design.</p>
            <a class="objetivo-link" href="https://4ed.com.br/guias/o-que-e-ux-ui-design/" target="_blank" rel="noopener">O que é UX/UI Design</a>

            <div class="curiosidade" style="margin-top:18px;">
              <p style="margin:0 0 6px;">Poucas pessoas sabem, mas eu gosto de <strong>desenhar</strong> nas horas vagas.</p>
              <p style="margin:0;">E, já que estamos em curiosidades: meu animal favorito é o <strong>gato</strong>.</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <div class="wave-divider" aria-hidden="true">
      <svg viewBox="0 0 1200 60" preserveAspectRatio="none">
        <path d="M0,30 C300,60 900,0 1200,30 L1200,60 L0,60 Z" style="fill: var(--secondary);"></path>
      </svg>
    </div>

    <!-- ==========================================================
         SEÇÃO: MINHAS ENTREGAS
         Cinco cards em estilo polaroid, dispostos em mosaico.
         Os campos data / aprendizado / link / selo estão marcados
         como [PREENCHER] porque essas informações não foram
         fornecidas — nada foi inventado.
         ========================================================== -->
    <section id="entregas" class="reveal reveal-right">
      <div class="wrap">
        <h2 class="section-titulo">Minhas entregas</h2>
        <p class="section-intro">Registro dos trabalhos desenvolvidos ao longo do curso.</p>

        <div class="entregas-grid">

          <!-- Entrega 1 -->
          <article class="polaroid card--1 polaroid--pendente">
            <div class="polaroid-foto">Capa do Meu Álbum</div>
            <div class="polaroid-legenda">
              <p class="polaroid-numero">Entrega 01/05</p>
              <h3 class="polaroid-titulo">Capa do Meu Álbum</h3>
              <p class="polaroid-meta">[PREENCHER: data]</p>
              <p class="polaroid-aprendizado">[PREENCHER: uma linha sobre o que aprendi]</p>
              <span class="selo selo--preencher">[PREENCHER: status]</span>
              <br>
              <a class="polaroid-link" href="#">[PREENCHER: link da pasta no GitHub]</a>
            </div>
          </article>

          <!-- Entrega 2 -->
          <article class="polaroid card--2 polaroid--pendente">
            <div class="polaroid-foto">Dashboard Quem Sou Eu</div>
            <div class="polaroid-legenda">
              <p class="polaroid-numero">Entrega 02/05</p>
              <h3 class="polaroid-titulo">Dashboard Quem Sou Eu</h3>
              <p class="polaroid-meta">[PREENCHER: data]</p>
              <p class="polaroid-aprendizado">[PREENCHER: uma linha sobre o que aprendi]</p>
              <span class="selo selo--preencher">[PREENCHER: status]</span>
              <br>
              <a class="polaroid-link" href="#">[PREENCHER: link da pasta no GitHub]</a>
            </div>
          </article>

          <!-- Entrega 3 -->
          <article class="polaroid card--3 polaroid--pendente">
            <div class="polaroid-foto">Árvore das Profissões 2.0</div>
            <div class="polaroid-legenda">
              <p class="polaroid-numero">Entrega 03/05</p>
              <h3 class="polaroid-titulo">Árvore das Profissões 2.0</h3>
              <p class="polaroid-meta">[PREENCHER: data]</p>
              <p class="polaroid-aprendizado">[PREENCHER: uma linha sobre o que aprendi]</p>
              <span class="selo selo--preencher">[PREENCHER: status]</span>
              <br>
              <a class="polaroid-link" href="#">[PREENCHER: link da pasta no GitHub]</a>
            </div>
          </article>

          <!-- Entrega 4 -->
          <article class="polaroid card--4 polaroid--pendente">
            <div class="polaroid-foto">Âncoras de Carreira</div>
            <div class="polaroid-legenda">
              <p class="polaroid-numero">Entrega 04/05</p>
              <h3 class="polaroid-titulo">Âncoras de Carreira</h3>
              <p class="polaroid-meta">[PREENCHER: data]</p>
              <p class="polaroid-aprendizado">[PREENCHER: uma linha sobre o que aprendi]</p>
              <span class="selo selo--preencher">[PREENCHER: status]</span>
              <br>
              <a class="polaroid-link" href="#">[PREENCHER: link da pasta no GitHub]</a>
            </div>
          </article>

          <!-- Entrega 5 -->
          <article class="polaroid card--5 polaroid--pendente">
            <div class="polaroid-foto">Manifesto</div>
            <div class="polaroid-legenda">
              <p class="polaroid-numero">Entrega 05/05</p>
              <h3 class="polaroid-titulo">Manifesto</h3>
              <p class="polaroid-meta">[PREENCHER: data]</p>
              <p class="polaroid-aprendizado">[PREENCHER: uma linha sobre o que aprendi]</p>
              <span class="selo selo--preencher">[PREENCHER: status]</span>
              <br>
              <a class="polaroid-link" href="#">[PREENCHER: link da pasta no GitHub]</a>
            </div>
          </article>

        </div>
      </div>
    </section>

    <div class="wave-divider" aria-hidden="true">
      <svg viewBox="0 0 1200 60" preserveAspectRatio="none">
        <path d="M0,30 C300,0 900,60 1200,30 L1200,60 L0,60 Z" style="fill: var(--secondary);"></path>
      </svg>
    </div>

    <!-- ==========================================================
         SEÇÃO: MANIFESTO
         Fundo na cor primária, texto em cor com bom contraste
         (a variável --on-primary garante a leitura em ambos os temas).
         ========================================================== -->
    <section id="manifesto" class="reveal reveal-left">
      <div class="wrap">
        <div class="manifesto">
          <h2 class="section-titulo">Manifesto</h2>
          <p class="manifesto-texto">Como estudante de Informática para Internet no SESI SENAI, construo minha identidade na união exata entre dedicação técnica e paixão pela inovação. Busco evolução contínua na área tecnológica, transformando desafios complexos em linhas de código eficientes. Sou uma jovem determinada, focada em aprender novas ferramentas e em usar o conhecimento digital como motor de transformação pessoal e profissional constante.</p>
          <p class="manifesto-texto">Caminho firme rumo a um futuro de estabilidade financeira e plena realização em um emprego que me traga felicidade real todos os dias. Meu grande objetivo é consolidar uma carreira de excelência na tecnologia, assumindo o compromisso de usar minhas conquistas e condições para ajudar o próximo. Este portfólio reflete meu ponto de partida para gerar um impacto social profundamente positivo.</p>
        </div>
      </div>
    </section>

  </main>

  <!-- ==========================================================
       RODAPÉ
       ========================================================== -->
  <footer class="reveal reveal-right">
    <div class="wrap">
      <div class="rodape-topo">
        <h2 class="section-titulo" style="font-size:1.6rem;">Vamos conversar</h2>
        <div class="rodape-links">
          <a href="https://github.com/llgimenez" target="_blank" rel="noopener">github.com/llgimenez</a>
          <a href="mailto:llaura.gimenz2010@gmail.com">llaura.gimenz2010@gmail.com</a>
        </div>
      </div>

      <div class="rodape-detalhe">
        <svg class="pata-icone" viewBox="0 0 24 24"><circle cx="7" cy="8" r="2.2"/><circle cx="12" cy="5.5" r="2.2"/><circle cx="17" cy="8" r="2.2"/><path d="M12 12c-4 0-6.5 2.6-6.5 5.3 0 2 1.7 3.2 3.6 2.5.9-.3 1.9-.5 2.9-.5s2 .2 2.9.5c1.9.7 3.6-.5 3.6-2.5C18.5 14.6 16 12 12 12z"/></svg>
        <span>Feito por Laura Gimenez dos Santos.</span>
      </div>

      <p class="contador-tempo" id="contador-tempo">Você está nesta página há 0 segundo.</p>
    </div>
  </footer>

  <!-- Botão fixo de voltar ao topo (único elemento de navegação) -->
  <a href="#topo" class="pill-btn voltar-topo" id="voltar-topo">Voltar ao topo</a>

<script>
  /* ========================================================================
     JAVASCRIPT
     Todo o comportamento interativo da página está aqui, comentado em
     português por bloco de funcionalidade.
     ======================================================================== */

  // Verifica se a pessoa ativou "reduzir movimento" no sistema dela.
  // Esse valor é usado para desligar ou simplificar os efeitos abaixo.
  var reduzirMovimento = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ------------------------------------------------------------------
     1) ALTERNÂNCIA DE TEMA CLARO/ESCURO
     Guarda a escolha da pessoa no localStorage para lembrar na próxima
     visita. Tudo dentro de try/catch, caso o navegador bloqueie o
     armazenamento local.
     ------------------------------------------------------------------ */
  (function(){
    var html = document.documentElement;
    var botao = document.getElementById('theme-toggle');

    function aplicarTexto(tema){
      botao.textContent = tema === 'dark' ? 'Modo claro' : 'Modo escuro';
    }

    var temaSalvo = null;
    try{
      temaSalvo = localStorage.getItem('laura-portfolio-tema');
    }catch(e){ /* localStorage indisponível: seguimos com o tema padrão */ }

    if(temaSalvo === 'dark'){
      html.setAttribute('data-theme', 'dark');
    }
    aplicarTexto(html.getAttribute('data-theme'));

    botao.addEventListener('click', function(){
      var temaAtual = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      html.setAttribute('data-theme', temaAtual);
      aplicarTexto(temaAtual);
      try{
        localStorage.setItem('laura-portfolio-tema', temaAtual);
      }catch(e){ /* segue sem salvar, sem quebrar a página */ }
    });
  })();

  /* ------------------------------------------------------------------
     2) LUZ QUE SEGUE O CURSOR (OU O TOQUE) NO TOPO
     Atualiza as variáveis CSS --mx e --my com a posição do ponteiro
     dentro da seção "hero". Em modo de movimento reduzido, a luz fica
     parada no centro, sem acompanhar o cursor.
     ------------------------------------------------------------------ */
  (function(){
    var hero = document.getElementById('topo');
    var luz = document.getElementById('hero-light');

    if(reduzirMovimento){
      luz.style.setProperty('--mx', '50%');
      luz.style.setProperty('--my', '30%');
      return;
    }

    hero.addEventListener('pointermove', function(evento){
      var caixa = hero.getBoundingClientRect();
      var x = ((evento.clientX - caixa.left) / caixa.width) * 100;
      var y = ((evento.clientY - caixa.top) / caixa.height) * 100;
      luz.style.setProperty('--mx', x + '%');
      luz.style.setProperty('--my', y + '%');
    });
  })();

  /* ------------------------------------------------------------------
     3) ANIMAÇÃO AO ROLAR A PÁGINA
     Observa cada seção com a classe "reveal" e adiciona "is-visible"
     quando ela entra na tela, fazendo-a surgir alternando pela
     esquerda e pela direita (conforme a classe reveal-left/reveal-right
     já definida em cada seção no HTML).
     ------------------------------------------------------------------ */
  (function(){
    var elementos = document.querySelectorAll('.reveal');

    if(reduzirMovimento){
      // Sem observer: mostra tudo de uma vez, sem movimento.
      elementos.forEach(function(el){ el.classList.add('is-visible'); });
      return;
    }

    var observador = new IntersectionObserver(function(entradas){
      entradas.forEach(function(entrada){
        if(entrada.isIntersecting){
          entrada.target.classList.add('is-visible');
          observador.unobserve(entrada.target);
        }
      });
    }, { threshold: 0.15 });

    elementos.forEach(function(el){ observador.observe(el); });
  })();

  /* ------------------------------------------------------------------
     4) CONFETE AO CLICAR NO NOME
     Cria pequenos quadrados coloridos que caem e desaparecem.
     Não é executado se a pessoa reduziu o movimento.
     ------------------------------------------------------------------ */
  (function(){
    var nome = document.getElementById('nome-clicavel');
    var cores = ['var(--primary)', 'var(--secondary)', 'var(--accent)'];

    nome.addEventListener('click', function(){
      if(reduzirMovimento) return;

      for(var i = 0; i < 24; i++){
        var pedaco = document.createElement('span');
        pedaco.className = 'confete';
        pedaco.style.left = (window.innerWidth / 2 + (Math.random() * 200 - 100)) + 'px';
        pedaco.style.top = (nome.getBoundingClientRect().bottom + window.scrollY) + 'px';
        pedaco.style.background = cores[Math.floor(Math.random() * cores.length)];
        pedaco.style.transform = 'rotate(' + Math.floor(Math.random() * 360) + 'deg)';
        pedaco.style.animationDelay = (Math.random() * 0.3) + 's';
        document.body.appendChild(pedaco);

        // Remove o elemento do confete assim que a animação termina,
        // para não deixar a página cheia de elementos escondidos.
        pedaco.addEventListener('animationend', function(){
          this.remove();
        });
      }
    });
  })();

  /* ------------------------------------------------------------------
     5) CONTADOR "VOCÊ ESTÁ AQUI HÁ X SEGUNDOS"
     ------------------------------------------------------------------ */
  (function(){
    var inicio = Date.now();
    var texto = document.getElementById('contador-tempo');

    setInterval(function(){
      var segundos = Math.floor((Date.now() - inicio) / 1000);
      var unidade = segundos === 1 ? 'segundo' : 'segundos';
      texto.textContent = 'Você está nesta página há ' + segundos + ' ' + unidade + '.';
    }, 1000);
  })();

  /* ------------------------------------------------------------------
     6) BOTÃO "VOLTAR AO TOPO"
     Aparece depois que a pessoa rola uma certa distância da página.
     ------------------------------------------------------------------ */
  (function(){
    var botao = document.getElementById('voltar-topo');

    window.addEventListener('scroll', function(){
      if(window.scrollY > 500){
        botao.classList.add('visivel');
      }else{
        botao.classList.remove('visivel');
      }
    });
  })();

  /* ------------------------------------------------------------------
     7) AVATAR: mostra as iniciais "LG" caso a imagem "foto-laura.jpg"
     ainda não exista na pasta (evita o ícone de imagem quebrada).
     ------------------------------------------------------------------ */
  (function(){
    var foto = document.getElementById('foto-avatar');
    var reserva = document.getElementById('avatar-fallback');

    foto.addEventListener('error', function(){
      foto.style.display = 'none';
      reserva.style.display = 'flex';
    });
  })();
</script>

</body>
</html>
