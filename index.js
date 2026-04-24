<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes">
  <title>GD Link Converter • Auto Walk Script</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      background: linear-gradient(145deg, #0f1115 0%, #1a1e26 100%);
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
      margin: 0;
      color: #e0e4e9;
    }

    .glass-card {
      background: rgba(22, 26, 33, 0.85);
      backdrop-filter: blur(18px);
      -webkit-backdrop-filter: blur(18px);
      border: 1px solid rgba(90, 160, 255, 0.25);
      box-shadow: 0 30px 50px rgba(0, 0, 0, 0.7), 0 0 0 1px rgba(56, 128, 255, 0.2);
      border-radius: 36px;
      padding: 30px 25px;
      max-width: 650px;
      width: 100%;
      transition: all 0.3s ease;
    }

    h1 {
      font-size: 2.2rem;
      font-weight: 700;
      margin-bottom: 6px;
      background: linear-gradient(to right, #a0d0ff, #5ca0f2);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      letter-spacing: -0.5px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .subtitle {
      color: #8b9bb5;
      margin-bottom: 28px;
      font-size: 0.95rem;
      border-left: 3px solid #3b82f6;
      padding-left: 14px;
    }

    .input-group {
      margin-bottom: 22px;
    }

    label {
      display: block;
      font-weight: 600;
      font-size: 0.9rem;
      margin-bottom: 6px;
      color: #b0c7e0;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    input, textarea {
      width: 100%;
      background: #0b0e14;
      border: 1px solid #2d3542;
      border-radius: 18px;
      padding: 14px 18px;
      font-size: 1rem;
      color: #ffffff;
      outline: none;
      transition: all 0.2s ease;
      font-family: inherit;
      resize: vertical;
      background: rgba(10, 14, 20, 0.8);
      backdrop-filter: blur(4px);
    }

    input:focus, textarea:focus {
      border-color: #3b82f6;
      box-shadow: 0 0 15px rgba(59,130,246,0.3);
      background: #0c0f16;
    }

    textarea {
      min-height: 90px;
    }

    .row {
      display: flex;
      gap: 15px;
      flex-wrap: wrap;
    }

    .row .input-group {
      flex: 1 1 45%;
    }

    .convert-btn {
      background: #1e3b6b;
      border: none;
      background: linear-gradient(135deg, #1e4b8c, #0f2b4f);
      border: 1px solid #3f6eb0;
      color: white;
      font-weight: bold;
      font-size: 1.1rem;
      padding: 14px 28px;
      border-radius: 30px;
      width: 100%;
      cursor: pointer;
      margin: 18px 0 20px;
      transition: all 0.25s;
      letter-spacing: 0.8px;
      box-shadow: 0 8px 20px rgba(0,80,200,0.3);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .convert-btn:hover {
      background: linear-gradient(135deg, #2563c9, #153a66);
      border-color: #6099ff;
      box-shadow: 0 12px 28px rgba(0,120,255,0.45);
      transform: scale(1.01);
    }

    .result-box {
      background: #0a0e13;
      border-radius: 22px;
      padding: 18px 16px;
      border: 1px dashed #3b5f8a;
      margin: 20px 0 15px;
      word-break: break-all;
    }

    .direct-link {
      background: #0f1a24;
      padding: 12px;
      border-radius: 14px;
      font-family: 'Fira Code', monospace;
      font-size: 0.9rem;
      color: #9ac8ff;
      margin: 12px 0;
      border: 1px solid #2d4b6e;
    }

    .preview-card {
      background: #0c0f14;
      border-radius: 20px;
      padding: 20px;
      margin-top: 20px;
      border: 1px solid #2e4055;
      white-space: pre-wrap;
      font-family: 'Segoe UI', monospace;
      line-height: 1.6;
      color: #ccdbe9;
      font-size: 0.9rem;
    }

    .copy-group {
      display: flex;
      gap: 10px;
      margin: 15px 0 5px;
    }

    .copy-btn {
      background: #1f2b3a;
      border: 1px solid #42628b;
      color: #d4e2ff;
      padding: 10px 18px;
      border-radius: 25px;
      font-weight: 600;
      cursor: pointer;
      transition: 0.2s;
      font-size: 0.9rem;
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 5px;
    }

    .copy-btn:hover {
      background: #233752;
      border-color: #608fd0;
    }

    .note {
      font-size: 0.8rem;
      color: #8f9eb5;
      margin-top: 12px;
      text-align: center;
    }

    hr {
      border-color: #263445;
      margin: 18px 0 12px;
    }

    .auto-badge {
      display: inline-block;
      background: #0f2b4f;
      color: #7bb3ff;
      font-size: 0.7rem;
      padding: 2px 10px;
      border-radius: 20px;
      margin-left: 8px;
      font-weight: 600;
      letter-spacing: 0.3px;
    }

    .readonly-highlight {
      background: #0a0f17;
      border-color: #2f4a6b;
      color: #c0d4f0;
    }
  </style>
</head>
<body>
  <div class="glass-card">
    <h1>⚡ GD Link Converter</h1>
    <div class="subtitle">Ubah link Google Drive biasa → direct download & format Auto Walk</div>

    <div class="input-group">
      <label>🔗 Link Google Drive (share link)</label>
      <input type="text" id="driveLinkInput" placeholder="https://drive.google.com/file/d/1SL1uOU.../view?usp=sharing" autocomplete="off">
      <div style="font-size:0.8rem; margin-top:6px; color:#7b8aa6;">Contoh: https://drive.google.com/file/d/XXXXX/view</div>
    </div>

    <div class="row">
      <div class="input-group">
        <label>👤 Dibuat oleh (nama/ID)</label>
        <input type="text" id="creatorInput" placeholder="<@1159798036713713686>" value="<@1159798036713713686>">
      </div>
      <div class="input-group">
        <label>📅 Tanggal <span class="auto-badge">AUTO REAL-TIME</span></label>
        <input type="text" id="dateInput" class="readonly-highlight" readonly placeholder="Terisi otomatis hari ini">
      </div>
    </div>

    <div class="row">
      <div class="input-group">
        <label>🏔️ Nama Map</label>
        <input type="text" id="mapInput" placeholder="MOUNT NOX" value="MOUNT NOX">
      </div>
      <div class="input-group">
        <label>🔗 Link LUA <span class="auto-badge">AUTO PERMANEN</span></label>
        <input type="text" id="luaLinkInput" class="readonly-highlight" readonly value="https://discord.com/channels/1483313050185371772/1490578645516025986">
      </div>
    </div>

    <div class="input-group">
      <label>📝 Catatan</label>
      <textarea id="notesInput" placeholder="GUNAKAN AVA BESAR YAA KALOK AVA KECIL TERBANG NANTI">GUNAKAN AVA BESAR YAA KALOK AVA KECIL TERBANG NANTI</textarea>
    </div>

    <button class="convert-btn" id="generateBtn">
      <span>⚙️</span> GENERATE FORMAT & LINK
    </button>

    <!-- Hasil link langsung -->
    <div id="resultSection" style="display: none;">
      <div style="font-weight:600; margin-bottom:5px; color:#aac8ff;">📎 DIRECT DOWNLOAD LINK:</div>
      <div class="direct-link" id="directLinkDisplay">https://drive.google.com/uc?export=download&id=...</div>
      
      <div class="copy-group">
        <button class="copy-btn" id="copyLinkBtn">📋 Salin Link Download</button>
        <button class="copy-btn" id="copyFullFormatBtn">📄 Salin Format Lengkap</button>
      </div>

      <div style="margin-top: 18px; font-weight: 600; color:#b8cefc;">📜 PREVIEW FORMAT:</div>
      <div class="preview-card" id="previewOutput">
        <!-- akan diisi oleh javascript -->
      </div>
    </div>
    <div class="note">Tempelkan link load dengan format <strong>https://drive.google.com/uc?export=download&id=...</strong></div>
  </div>

  <script>
    (function() {
      // === KONFIGURASI LINK LUA PERMANEN ===
      const PERMANENT_LUA_LINK = "https://discord.com/channels/1483313050185371772/1490578645516025986";
      
      // DOM elements
      const driveLinkInput = document.getElementById('driveLinkInput');
      const creatorInput = document.getElementById('creatorInput');
      const dateInput = document.getElementById('dateInput');
      const mapInput = document.getElementById('mapInput');
      const luaLinkInput = document.getElementById('luaLinkInput');
      const notesInput = document.getElementById('notesInput');
      const generateBtn = document.getElementById('generateBtn');
      const resultSection = document.getElementById('resultSection');
      const directLinkDisplay = document.getElementById('directLinkDisplay');
      const previewOutput = document.getElementById('previewOutput');
      const copyLinkBtn = document.getElementById('copyLinkBtn');
      const copyFullFormatBtn = document.getElementById('copyFullFormatBtn');

      // === FUNGSI TANGGAL REAL-TIME ===
      function getCurrentFormattedDate() {
        const now = new Date();
        const days = ['MINGGU', 'SENIN', 'SELASA', 'RABU', 'KAMIS', 'JUMAT', 'SABTU'];
        const months = [
          'JANUARI', 'FEBRUARI', 'MARET', 'APRIL', 'MEI', 'JUNI',
          'JULI', 'AGUSTUS', 'SEPTEMBER', 'OKTOBER', 'NOVEMBER', 'DESEMBER'
        ];
        
        const dayName = days[now.getDay()];
        const day = now.getDate();
        const month = months[now.getMonth()];
        const year = now.getFullYear();
        
        return `${dayName}, ${day} ${month} ${year}`;
      }

      // Set tanggal otomatis saat halaman dimuat
      function setAutoDate() {
        dateInput.value = getCurrentFormattedDate();
      }

      // Set link LUA permanen
      function setPermanentLuaLink() {
        luaLinkInput.value = PERMANENT_LUA_LINK;
      }

      // Update tanggal setiap menit (jika halaman dibuka lama)
      function startAutoDateUpdater() {
        setAutoDate();
        // Update setiap 60 detik
        setInterval(() => {
          dateInput.value = getCurrentFormattedDate();
        }, 60000);
      }

      // === EKSTRAK FILE ID ===
      function extractFileId(url) {
        if (!url || typeof url !== 'string') return null;
        let id = null;
        
        const matchDrive = url.match(/\/d\/([a-zA-Z0-9_-]+)/);
        if (matchDrive) {
          id = matchDrive[1];
        }
        
        if (!id) {
          const matchIdParam = url.match(/[?&]id=([a-zA-Z0-9_-]+)/);
          if (matchIdParam) id = matchIdParam[1];
        }
        
        if (!id) {
          const matchOpen = url.match(/\/open\?id=([a-zA-Z0-9_-]+)/);
          if (matchOpen) id = matchOpen[1];
        }
        
        if (!id) {
          const matchUc = url.match(/[?&]id=([a-zA-Z0-9_-]+)/);
          if (matchUc) id = matchUc[1];
        }
        
        return id;
      }

      function buildDirectLink(fileId) {
        return `https://drive.google.com/uc?export=download&id=${fileId}`;
      }

      function buildFullFormat(directLink, creator, date, map, luaLink, notes) {
        const safeCreator = creator || '<@1159798036713713686>';
        const safeDate = date || getCurrentFormattedDate();
        const safeMap = map || 'MOUNT NOX';
        const safeLua = luaLink || PERMANENT_LUA_LINK;
        const safeNotes = notes || 'GUNAKAN AVA BESAR YAA KALOK AVA KECIL TERBANG NANTI';
        
        return `📜 **FILE RECORD SCRIPT ONIUM  AUTO WALK**

👤 **Dibuat oleh:** ${safeCreator} 
📅 **Tanggal:** ${safeDate}
🏔️ **Nama Map:** ${safeMap}
🔗 **Link LUA:** ${safeLua}
📝 **Catatan:** ${safeNotes}

---

⚙️ File ini berisi data hasil record pergerakan yang dapat digunakan untuk fitur auto walk.
Pastikan semua data sudah benar sebelum digunakan.

🚀 Gunakan dengan bijak dan sesuaikan dengan kebutuhan.
@everyone

PASTE IN LINK LOAD 
\`\`\`${directLink}\`\`\``;
      }

      function displayResult(directLink, fullText) {
        directLinkDisplay.textContent = directLink;
        previewOutput.textContent = fullText;
        resultSection.style.display = 'block';
      }

      function handleGenerate() {
        const rawLink = driveLinkInput.value.trim();
        if (!rawLink) {
          alert('Mohon masukkan link Google Drive terlebih dahulu.');
          return;
        }

        const fileId = extractFileId(rawLink);
        if (!fileId) {
          alert('Gagal mengekstrak ID file. Pastikan link Google Drive valid (contoh mengandung /d/FILE_ID).');
          return;
        }

        const directLink = buildDirectLink(fileId);
        
        // Ambil nilai dari input (tanggal dan lua link sudah auto)
        const creator = creatorInput.value.trim();
        const date = dateInput.value.trim();
        const map = mapInput.value.trim();
        const luaLink = luaLinkInput.value.trim();
        const notes = notesInput.value.trim();

        const fullFormat = buildFullFormat(directLink, creator, date, map, luaLink, notes);
        displayResult(directLink, fullFormat);
      }

      async function copyToClipboard(text, successMessage = 'Berhasil disalin!') {
        try {
          await navigator.clipboard.writeText(text);
          alert(successMessage);
        } catch (err) {
          const textarea = document.createElement('textarea');
          textarea.value = text;
          document.body.appendChild(textarea);
          textarea.select();
          document.execCommand('copy');
          document.body.removeChild(textarea);
          alert(successMessage);
        }
      }

      // === EVENT LISTENERS ===
      generateBtn.addEventListener('click', handleGenerate);

      copyLinkBtn.addEventListener('click', () => {
        const link = directLinkDisplay.textContent;
        if (link && link.startsWith('https://')) {
          copyToClipboard(link, 'Link download berhasil disalin!');
        } else {
          alert('Link belum tersedia. Generate dulu.');
        }
      });

      copyFullFormatBtn.addEventListener('click', () => {
        const fullText = previewOutput.textContent;
        if (fullText && fullText.includes('FILE RECORD')) {
          copyToClipboard(fullText, 'Format lengkap berhasil disalin!');
        } else {
          alert('Format belum tersedia. Silakan generate.');
        }
      });

      // === INISIALISASI ===
      driveLinkInput.placeholder = 'https://drive.google.com/file/d/1SL1uOUUhWDjKGNzuxEOGqMad9OLpa0Up/view?usp=sharing';
      
      // Set nilai awal
      setPermanentLuaLink();
      startAutoDateUpdater();
      
      // Tambahkan info readonly
      dateInput.title = "Tanggal terisi otomatis berdasarkan waktu sistem Anda";
      luaLinkInput.title = "Link LUA permanen, tidak dapat diubah";
      
    })();
  </script>
</body>
</html>
