#!/usr/bin/env bash

# ──────────────────────────────────────────────────────────────────────
# gerar_xacomigo_pdf.sh
# Gera o cartaz "Xá Comigo!" em PDF A4 usando WeasyPrint.
# Uso: bash gerar_xacomigo_pdf.sh
# ──────────────────────────────────────────────────────────────────────

set -euo pipefail

OUTPUT_DIR="${HOME}/Desktop/xacomigo"
HTML_FILE="${OUTPUT_DIR}/xacomigo_hector_neder.html"
PDF_FILE="${OUTPUT_DIR}/xacomigo_hector_neder.pdf"

mkdir -p "$OUTPUT_DIR"

# Verifica WeasyPrint
if ! command -v weasyprint >/dev/null 2>&1; then
  echo "⚠️  WeasyPrint não encontrado. Instalando via pip…"
  pip install --quiet weasyprint || pip3 install --quiet weasyprint
fi

echo "📝  Gerando HTML em ${HTML_FILE}…"

cat > "$HTML_FILE" <<'HTML_EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Xá Comigo! — Hector Neder</title>
<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;500;600;700;900&family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&display=swap" rel="stylesheet">
<style>
@page { size: A4; margin: 10mm; }
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0;
  -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }

:root {
  --cream:#F7F2EA; --cream2:#FDFAF2; --cream3:#EFE7D5;
  --navy:#0f1c33; --navy-d:#050E1F; --navy-m:#1C2B4A; --navy-l:#2A3D63;
  --red:#CC092F; --red-d:#8B0620; --red-l:#FF3859;
  --gold:#D4A843; --gold-d:#b88a2a; --gold-l:#E5C16E;
  --ink:#2A2A2A; --ink2:#555;
}

body { background:#FFFFFF; font-family:'Cormorant Garamond', Georgia, serif; }

.card {
  width:100%; background:var(--cream); position:relative;
  box-shadow: 0 0 0 1px var(--gold-d), 0 0 0 4px var(--cream), 0 0 0 5px var(--gold);
}

/* corner ornaments */
.corner { position:absolute; width:32px; height:32px; z-index:25; }
.corner::before, .corner::after { content:''; position:absolute; background:var(--gold-d); }
.corner::before { width:18px; height:1px; top:6px; left:6px; box-shadow:0 4px 0 var(--gold); }
.corner::after { width:1px; height:18px; top:6px; left:6px; box-shadow:4px 0 0 var(--gold); }
.corner .dot { position:absolute; width:6px; height:6px; background:var(--gold); border-radius:50%;
  top:3px; left:3px; box-shadow:0 0 6px rgba(212,168,67,0.6); }
.c-tl { top:12px; left:12px; }
.c-tr { top:12px; right:12px; transform:scaleX(-1); }
.c-bl { bottom:12px; left:12px; transform:scaleY(-1); }
.c-br { bottom:12px; right:12px; transform:scale(-1); }

/* HERO */
.hero {
  background: radial-gradient(ellipse at top, var(--navy-l) 0%, var(--navy) 50%, var(--navy-d) 100%);
  padding: 44px 50px 36px; text-align:center; position:relative;
  border-bottom:1px solid var(--gold-d);
}
.hero::after { content:''; position:absolute; top:30px; left:50%; transform:translateX(-50%);
  width:380px; height:240px; background:radial-gradient(ellipse, rgba(204,9,47,0.18) 0%, transparent 70%); }
.hero-inner { position:relative; z-index:2; }

.program-tag { display:inline-flex; align-items:center; gap:12px; margin-bottom:22px;
  flex-wrap:wrap; justify-content:center; }
.program-tag .line { width:50px; height:1px; background:linear-gradient(90deg, transparent, var(--gold)); }
.program-tag .line.r { background:linear-gradient(90deg, var(--gold), transparent); }
.program-tag span { font-family:'Cinzel', serif; font-size:9.5px; letter-spacing:4px;
  color:var(--gold); text-transform:uppercase; font-weight:600; }
.program-tag .red-dot { width:5px; height:5px; background:var(--red); border-radius:50%;
  box-shadow:0 0 8px var(--red); }

/* Estrela 5 pontas */
.star-wrap { display:flex; justify-content:center; margin-bottom:24px; }
.star-seal { width:96px; height:96px; position:relative;
  filter: drop-shadow(0 0 16px rgba(204,9,47,0.55)); }
.star-shape { width:100%; height:100%;
  clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
  background: radial-gradient(circle at 35% 30%, var(--red-l) 0%, var(--red) 45%, var(--red-d) 100%);
  position:relative; }
.star-inner { position:absolute; inset:18%;
  clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
  background: linear-gradient(135deg, rgba(255,255,255,0.20) 0%, transparent 50%, rgba(0,0,0,0.18) 100%); }

.recipient-label { font-family:'Cinzel', serif; font-size:9px; letter-spacing:5px;
  color:var(--gold); text-transform:uppercase; margin-bottom:12px; font-weight:500; }
.recipient-name { font-family:'Cinzel', serif; font-size:34px; font-weight:700;
  letter-spacing:6px; line-height:1.1; color:var(--gold); margin-bottom:14px;
  text-transform:uppercase; text-shadow: 0 1px 0 rgba(0,0,0,0.4); }
.tagline { font-family:'Cormorant Garamond', serif; font-style:italic; font-size:18px;
  color:rgba(247,242,234,0.78); margin-bottom:16px; letter-spacing:0.5px; }
.tagline em { font-weight:600; color:var(--red-l); }
.descriptor { max-width:540px; margin:0 auto; font-size:13.5px;
  color:rgba(247,242,234,0.65); font-style:italic; line-height:1.65; }

/* Faixa vermelha */
.red-band { height:5px;
  background: linear-gradient(90deg, var(--red-d), var(--red) 50%, var(--red-d)); }
.red-band-text { background: linear-gradient(90deg, var(--red-d), var(--red) 50%, var(--red-d));
  padding:11px 50px; text-align:center;
  border-top:1px solid rgba(255,255,255,0.1); border-bottom:1px solid rgba(0,0,0,0.2); }
.red-band-text .text { font-family:'Cinzel', serif; font-size:10.5px; letter-spacing:5px;
  color:var(--cream2); text-transform:uppercase; font-weight:600;
  display:inline-flex; align-items:center; gap:14px; }
.red-band-text .text::before, .red-band-text .text::after {
  content:''; display:inline-block; width:30px; height:1px; background:rgba(255,255,255,0.5); }

/* Qualidades */
.qualities { display:flex; flex-wrap:wrap; justify-content:center; gap:7px;
  padding:22px 50px 4px; background:var(--cream); }
.qual { font-family:'Cinzel', serif; font-size:9.5px; letter-spacing:2px;
  color:var(--gold-d); padding:5px 12px; border:1px solid var(--gold-d);
  background:var(--cream2); text-transform:uppercase; font-weight:600; }

/* Stats */
.stats-bar { display:flex; justify-content:center; border-top:1px solid var(--gold-d);
  border-bottom:1px solid var(--gold-d); margin:18px 30px 0; background:var(--cream2); }
.stat { flex:1; padding:14px 6px; text-align:center;
  border-right:1px dashed rgba(184,138,42,0.35); }
.stat:last-child { border-right:none; }
.stat-num { font-family:'Cinzel', serif; font-size:26px; font-weight:700;
  color:var(--gold-d); line-height:1; }
.stat-label { font-family:'Cinzel', serif; font-size:8px; letter-spacing:2.5px;
  color:var(--ink2); text-transform:uppercase; margin-top:5px; font-weight:600; }
.stats-spacer { height:18px; background:var(--cream); }

/* Depoimentos */
.recs { padding:6px 0; background:var(--cream); }
.rec { display:grid; grid-template-columns:50px 1fr 70px; gap:0 16px;
  padding:14px 44px 14px 38px;
  border-bottom:1px dashed rgba(184,138,42,0.25); align-items:start;
  page-break-inside: avoid; }
.rec:last-child { border-bottom:none; }
.rec-medal { width:40px; height:40px; border-radius:50%;
  border:1.5px solid var(--gold-d); background:var(--cream2);
  display:flex; align-items:center; justify-content:center;
  font-family:'Cinzel', serif; font-size:13px; font-weight:700;
  color:var(--gold-d); position:relative; box-shadow: inset 0 1px 0 rgba(255,255,255,0.6); }
.rec-medal::after { content:''; position:absolute; inset:3px; border-radius:50%;
  border:1px dashed rgba(184,138,42,0.4); }
.rec-name { font-family:'Cinzel', serif; font-size:12px; font-weight:700;
  letter-spacing:1.5px; color:var(--navy); margin-bottom:6px; }
.rec-quote { font-size:13.5px; color:var(--ink2); line-height:1.65;
  font-style:italic; }
.rec-quote b { color:var(--navy); font-style:normal; font-weight:600; }
.rec-trait { display:inline-block; margin-top:7px; font-family:'Cinzel', serif;
  font-size:8px; letter-spacing:2.5px; color:var(--red); text-transform:uppercase;
  font-weight:700; padding:3px 8px; border-left:2px solid var(--red);
  background:rgba(204,9,47,0.05); }
.rec-date { font-family:'Cinzel', serif; font-size:8.5px; color:var(--gold-d);
  letter-spacing:1px; text-align:right; font-weight:600; }
.rec-date .day { display:block; font-size:20px; font-weight:700;
  color:var(--gold-d); margin-bottom:1px; }

/* Footer */
.footer-section { background: linear-gradient(180deg, var(--navy-m) 0%, var(--navy) 100%);
  padding:26px 50px 22px; display:flex; align-items:center; justify-content:space-between;
  gap:24px; border-top:1px solid var(--gold-d); page-break-inside: avoid; }
.signature-block { flex:1; }
.signature-line { height:1px; background:linear-gradient(90deg, var(--gold), transparent);
  margin-bottom:8px; width:220px; }
.signature-label { font-family:'Cinzel', serif; font-size:8px; letter-spacing:3px;
  color:var(--gold); text-transform:uppercase; margin-bottom:3px; font-weight:600; }
.signature-name { font-family:'Cormorant Garamond', serif; font-size:18px; font-style:italic;
  color:var(--cream2); font-weight:600; }
.signature-meta { font-family:'Cinzel', serif; font-size:8.5px; letter-spacing:2px;
  color:rgba(247,242,234,0.55); margin-top:8px; font-weight:500; }
.footer-seal { width:64px; height:64px;
  filter: drop-shadow(0 4px 10px rgba(204,9,47,0.4)); }

/* Brand strip */
.footer-strip { background:var(--navy-d); padding:11px 44px;
  display:flex; align-items:center; justify-content:space-between;
  border-top:1px solid rgba(212,168,67,0.2); flex-wrap:wrap; gap:12px; }
.footer-brand { font-family:'Cinzel', serif; font-size:8.5px; letter-spacing:3px;
  color:var(--gold); text-transform:uppercase; display:flex; align-items:center;
  gap:10px; font-weight:700; }
.footer-brand .red-bar { width:18px; height:2px; background:var(--red); }
.footer-tags { display:flex; gap:5px; flex-wrap:wrap; }
.ftag { font-family:'Cinzel', serif; font-size:8px;
  color:rgba(247,242,234,0.6); border:1px solid rgba(212,168,67,0.25);
  padding:2px 9px; letter-spacing:0.5px; font-weight:600; }
</style>
</head>
<body>

<div class="card">
  <div class="corner c-tl"><span class="dot"></span></div>
  <div class="corner c-tr"><span class="dot"></span></div>
  <div class="corner c-bl"><span class="dot"></span></div>
  <div class="corner c-br"><span class="dot"></span></div>

  <!-- HERO -->
  <div class="hero">
    <div class="hero-inner">
      <div class="program-tag">
        <div class="line"></div>
        <span>Grupo Bradesco Seguros</span>
        <div class="red-dot"></div>
        <span>Xá Comigo! · Ciclo Desempenho 2025</span>
        <div class="line r"></div>
      </div>

      <div class="star-wrap">
        <div class="star-seal">
          <div class="star-shape">
            <div class="star-inner"></div>
          </div>
        </div>
      </div>

      <div class="recipient-label">Concedido a</div>
      <div class="recipient-name">Hector Neder</div>
      <div class="tagline">"Deixa <em>comigo</em> que eu resolvo."</div>

      <div class="descriptor">
        Distinção interna de excelência em atendimento — concedida a funcionários
        que assumem com disposição, conduzem com cuidado e entregam com qualidade,
        em reconhecimento manifestado espontaneamente pelos pares.
      </div>
    </div>
  </div>

  <div class="red-band"></div>

  <!-- QUALIDADES -->
  <div class="qualities">
    <span class="qual">Atencioso</span>
    <span class="qual">Prestativo</span>
    <span class="qual">Resolutivo</span>
    <span class="qual">Didático</span>
    <span class="qual">Parceiro</span>
    <span class="qual">Educado</span>
    <span class="qual">Sábio na condução</span>
  </div>

  <!-- STATS -->
  <div class="stats-bar">
    <div class="stat"><div class="stat-num">12</div><div class="stat-label">Medalhas</div></div>
    <div class="stat"><div class="stat-num">45</div><div class="stat-label">Dias de ciclo</div></div>
    <div class="stat"><div class="stat-num">100%</div><div class="stat-label">Espontâneas</div></div>
  </div>

  <div class="stats-spacer"></div>

  <div class="red-band-text">
    <span class="text">Manifestações em destaque · 5 de 12</span>
  </div>

  <!-- DEPOIMENTOS -->
  <div class="recs">
    <div class="rec">
      <div class="rec-medal">I</div>
      <div>
        <div class="rec-name">Katia Costa</div>
        <div class="rec-quote">"Gostaria de agradecer ao Hector pelo apoio e condução de todo o processo de regularização dos indicadores de desempenho. <b>Super parceiro, disposto a ajudar e soube conduzir com sabedoria.</b> Parabéns e sucesso!!!!"</div>
        <div class="rec-trait">Sabedoria na condução</div>
      </div>
      <div class="rec-date"><span class="day">27</span>Abr · 2026</div>
    </div>

    <div class="rec">
      <div class="rec-medal">II</div>
      <div>
        <div class="rec-name">Julliana Gonzalez</div>
        <div class="rec-quote">"Gratidão por todo apoio e suporte relacionado aos indicadores de desempenho! <b>Sua parceria, atenção pontual e pronto atendimento foram essenciais para a conclusão e resolução dos erros da ferramenta,</b> nos deixando muito mais tranquilos neste processo."</div>
        <div class="rec-trait">Parceria & pronto atendimento</div>
      </div>
      <div class="rec-date"><span class="day">30</span>Mar · 2026</div>
    </div>

    <div class="rec">
      <div class="rec-medal">III</div>
      <div>
        <div class="rec-name">Ludmila Ribeiro</div>
        <div class="rec-quote">"<b>Atencioso, didático e principalmente muito educado e prestativo.</b> Nos retornou com 'todo tempo do mundo' para conferir as informações e nos deixar tranquilas. Obrigada pelo apoio e parabéns."</div>
        <div class="rec-trait">Didática & disponibilidade</div>
      </div>
      <div class="rec-date"><span class="day">26</span>Mar · 2026</div>
    </div>

    <div class="rec">
      <div class="rec-medal">IV</div>
      <div>
        <div class="rec-name">Eliane Cury</div>
        <div class="rec-quote">"Muito obrigada pela ajuda! <b>Foi muito atencioso, prestativo e resolutivo, nos deixando tranquilas!</b> Parabéns pelo excelente profissional que é!"</div>
        <div class="rec-trait">Resolutividade</div>
      </div>
      <div class="rec-date"><span class="day">26</span>Mar · 2026</div>
    </div>

    <div class="rec">
      <div class="rec-medal">V</div>
      <div>
        <div class="rec-name">Soraia Castro</div>
        <div class="rec-quote">"<b>Te agradeço por sempre nos atender com excelência.</b>"</div>
        <div class="rec-trait">Excelência consistente</div>
      </div>
      <div class="rec-date"><span class="day">25</span>Mar · 2026</div>
    </div>
  </div>

  <!-- FOOTER -->
  <div class="footer-section">
    <div class="signature-block">
      <div class="signature-line"></div>
      <div class="signature-label">Outorgado pelos pares · Ciclo Desempenho 2025</div>
      <div class="signature-name">Grupo Bradesco Seguros</div>
      <div class="signature-meta">São Paulo · 45 dias de ciclo · 12 medalhas · 2026</div>
    </div>

    <div class="footer-seal">
      <div class="star-shape">
        <div class="star-inner"></div>
      </div>
    </div>
  </div>

  <div class="footer-strip">
    <div class="footer-brand">
      <span class="red-bar"></span>
      <span>Bradesco Seguros · 2026</span>
    </div>
    <div class="footer-tags">
      <span class="ftag">#XáComigo</span>
      <span class="ftag">#DeixaComigoQueEuResolvo</span>
      <span class="ftag">#ExcelênciaNoAtendimento</span>
    </div>
  </div>
</div>

</body>
</html>
HTML_EOF

echo "🖨️   Renderizando PDF com WeasyPrint…"
weasyprint "$HTML_FILE" "$PDF_FILE" --presentational-hints

echo ""
echo "✅  PDF gerado com sucesso:"
echo "    ${PDF_FILE}"
echo ""

# Abre automaticamente no macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  open "$PDF_FILE"
fi
