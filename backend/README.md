# Teman Belajar AI — UI/UX Design Prompt & API Documentation

Prompt siap pakai untuk tool desain (Figma AI, v0, Lovable, Galileo AI, dsb) atau brief ke desainer, dilengkapi panduan implementasi frontend dengan backend yang sudah tersedia.

---

## Konsep Produk (Ringkas)

**Target user:** siswa SMA & SMK (mobile-first)

**Fitur inti:**
1. Generate soal pilihan ganda (ABCD) dari catatan (PDF/foto) — tiap soal dilengkapi **penjelasan** dan **referensi ke sumber catatan**, dibuat via RAG (bukan pengetahuan umum AI) supaya valid.
2. Penyimpanan tugas per mata pelajaran (foto/video, tersusun per tanggal) — auto-kategorisasi ke mapel & deteksi deadline dari lembar tugas, otomatis jadi portofolio (penting untuk SMK: PKL/praktik).
3. Spaced repetition & jurnal kesalahan — soal yang sering salah diulang otomatis beberapa hari kemudian.
4. Peta kelemahan per topik/bab, rencana belajar otomatis mundur dari tanggal ujian/UKK.
5. Laporan progres mingguan ke orang tua/guru.

**Tech stack:**
- Frontend: Flutter (mobile, satu codebase Android/iOS)
- Backend: Python + FastAPI
- Database: PostgreSQL + pgvector (untuk RAG)
- Storage: AWS S3 / Firebase Storage (foto, video, PDF)
- AI: LLM (Claude/GPT) dengan pola RAG untuk generate soal+penjelasan+referensi
- OCR: Google Cloud Vision API / Tesseract
- Auth: Firebase Auth
- Notifikasi: Firebase Cloud Messaging
- Offline-first: SQLite lokal + sync saat online

---

## Konsep Visual: "Siang Belajar, Malam Review"

Ide besar: aplikasi terasa seperti **langit** — terang & bersih saat mode terang (fokus, produktif, siang hari belajar), berubah jadi **langit malam berbintang dengan bulan purnama** saat dark mode (tenang, waktu review/refleksi malam hari).

### Light Mode
- **Warna utama:** `#38BDF8` (Sky-400) — tombol utama, header, progress bar, badge aktif.
- **Teks di atas warna utama:** putih (`#FFFFFF`), kontras terjaga (WCAG AA).
- **Background:** putih / off-white terang (`#FFFFFF` – `#F7FAFC`), clean dan lapang, kesan "langit cerah".
- **Card/permukaan:** putih dengan border/shadow sangat tipis, jangan berat.
- Kesan keseluruhan: cerah, ringan, tidak bikin "capek mata" saat belajar lama.

### Dark Mode
- Background **bertransformasi** jadi gradasi langit malam — biru tua ke navy gelap (`#0B1026` → `#1B2A4A`), bukan hitam pekat biasa.
- Tambahkan **bintang-bintang kecil** tersebar halus di background (titik putih/`#38BDF8` transparan, ukuran kecil, sedikit berkelip pelan — animasi opacity, bukan gerak).
- Tambahkan **bulan purnama** sebagai elemen dekoratif — bisa di pojok atas layar utama/dashboard atau splash screen, warna putih kekuningan lembut dengan glow tipis (bukan efek neon tebal).
- Warna aksen `#38BDF8` tetap dipakai untuk tombol/ikon aktif, versi sedikit lebih terang supaya kontras di background gelap.
- Teks utama jadi putih/abu terang, teks sekunder abu muda.

### Transisi Light ↔ Dark
- Animasikan seperti **matahari terbenam**: background light memudar ke gradasi malam, bintang fade-in satu-satu, bulan muncul terakhir dengan glow lembut. Durasi singkat (~400–600ms), jangan berlebihan.

### Palet Warna Lengkap

| Role | Light Mode | Dark Mode |
|---|---|---|
| **Primary** | `#38BDF8` (Sky-400) | `#7DD3FC` (Sky-300) |
| **Primary Hover** | `#0284C7` (Sky-600) | `#38BDF8` (Sky-400) |
| **Primary Light** | `#E0F2FE` (Sky-100) | `#1E3A5F` |
| **Success** | `#10B981` (Emerald-500) | `#34D399` (Emerald-400) |
| **Error** | `#EF4444` (Red-500) | `#F87171` (Red-400) |
| **Warning** | `#F59E0B` (Amber-500) | `#FBBF24` (Amber-400) |
| **Background** | `#F8FAFC` (Slate-50) | `#0B1026` gradasi `#1B2A4A` |
| **Card** | `#FFFFFF` | `#1E293B` (Slate-800) |
| **Text Primary** | `#0F172A` (Slate-900) | `#F1F5F9` (Slate-100) |
| **Text Secondary** | `#64748B` (Slate-500) | `#94A3B8` (Slate-400) |

---

## Tipografi
- Sans-serif rounded, ramah dan mudah dibaca (contoh arah: Poppins, Nunito, atau sejenis) — hindari font yang terkesan kaku/formal berlebihan, karena target siswa.
- Ukuran teks cukup besar untuk konten belajar panjang (nyaman dibaca lama).

## Mood & Tone
- Tenang, suportif, tidak bikin cemas — hindari kesan "ujian yang menegangkan" meski isinya soal latihan.
- Playful secukupnya (ikon, animasi bintang/bulan) tapi tetap kredibel untuk konteks akademik.

---

## Layar Utama yang Perlu Did Desain

1. **Dashboard** — ringkasan progres per mapel, skor terakhir, tugas mendatang.
2. **Upload catatan** — drag/scan PDF atau foto, pilih mapel.
3. **Kuis ABCD** — pertanyaan, 4 opsi, state benar (hijau)/salah (merah), lalu panel penjelasan + link referensi ke bagian catatan.
4. **Jurnal kesalahan** — daftar soal yang pernah salah, siap direview ulang.
5. **Timeline tugas per mapel** — galeri foto/video tersusun per tanggal, mirip portofolio.
6. **Kalender/reminder deadline**.
7. **Laporan progres** — versi ringkas untuk dibagikan ke orang tua/guru.
8. **Toggle light/dark mode** dengan animasi transisi siang→malam di atas.

## Ikon
- Gaya outline, simpel, konsisten satu set (bukan campur filled & outline).

---

## Catatan Tambahan untuk Desainer / Tool AI
- Prioritaskan kontras & keterbacaan — ini aplikasi belajar, dipakai lama, jangan sampai elemen dekoratif (bintang/bulan) mengganggu keterbacaan teks.
- Semua warna harus tetap accessible (WCAG AA minimum) baik di light maupun dark mode.
- Desain mobile-first, prioritaskan layar sempit (~375–430px).

---

## Mapping Frontend ↔ Backend (Saat Ini)

Berikut status ketersediaan fitur di backend yang sudah jadi:

| Layar / Fitur Prompt | Endpoint API | Status |
|---|---|---|
| **Auth (Login/Register)** | `POST /api/register`, `POST /api/login` | ✅ Tersedia (JWT manual, **bukan** Firebase Auth) |
| **Dashboard (daftar catatan)** | `GET /api/notes` | ✅ Tersedia |
| **Upload catatan** | `POST /api/notes/upload` (`multipart/form-data`) | ✅ Tersedia (format: PDF, JPG, PNG, WEBP, max 10MB) |
| **Generate soal** | `POST /api/notes/{note_id}/generate` | ✅ Tersedia (5 soal, **belum** RAG — masih dari full teks) |
| **Kuis ABCD + feedback** | `GET /api/notes/{note_id}/questions` + `POST /api/quiz/submit` | ✅ Tersedia |
| **Jurnal kesalahan** | `GET /api/errors` | ✅ Tersedia |
| **Hasil quiz** | `GET /api/quiz/result/{note_id}` | ✅ Tersedia |
| **Timeline tugas per mapel** | ❌ Belum ada | Perlu fitur baru (domain berbeda dari catatan) |
| **Kalender / deadline** | ❌ Belum ada | Perlu fitur baru |
| **Spaced repetition** | ❌ Belum ada | Perlu algoritma SM-2/FSRS + tabel baru |
| **Peta kelemahan & rencana belajar** | ❌ Belum ada | Perlu analytics engine |
| **Laporan progres** | ❌ Belum ada | Perlu aggregasi + sharing |
| **RAG + referensi ke sumber** | ❌ Masih generate dari full teks | Perlu pgvector + chunking + embedding |
| **File storage (S3/Firebase)** | ❌ Masih local disk (`backend/uploads/`) | Perlu migrasi |
| **Firebase Auth** | ❌ Masih JWT + bcrypt | Opsi: integrasi atau dual auth |
| **Firebase Cloud Messaging** | ❌ Belum ada | Perlu setup FCM |
| **Offline-first SQLite + sync** | ❌ Belum ada | Perlu sync API |

---

## Rencana Implementasi Bertahap

### Sprint 1 — v1 (Sekarang, backend sudah siap)
Fokus: 3 halaman inti, siap rilis cepat untuk user testing.

```
Minggu 1-2: Auth + Upload Catatan + Dashboard Daftar Catatan
Minggu 3-4: Quiz + Feedback Jawaban + Hasil Skor
Minggu 5:   Jurnal Kesalahan
```

### Sprint 2 — v2 (Fitur baru)
```
- Timeline tugas per mapel (foto/video, upload + galeri)
- Deteksi deadline dari lembar tugas (OCR + LLM parsing)
- Kalender akademik
```

### Sprint 3 — v3 (AI cerdas)
```
- Migrasi PostgreSQL + pgvector
- Chunking + embedding untuk RAG
- Spaced repetition (SM-2 / FSRS)
- Peta kelemahan per topik
- Rencana belajar otomatis mundur dari tanggal ujian
```

### Sprint 4 — v4 (Produksi)
```
- Firebase Auth integration
- Firebase Cloud Messaging (notifikasi)
- AWS S3 / Firebase Storage untuk file
- Laporan progres mingguan (PDF / share link)
- Offline-first dengan sync
```

---

## Panduan API — Untuk Frontend Developer

### Base URL

```
http://localhost:8000/api
```

Semua endpoint (kecuali register/login) pakai header:

```
Authorization: Bearer <access_token>
```

---

### 1. Register

**`POST /api/register`**

Request:
```json
{
  "email": "siswa@email.com",
  "name": "Budi",
  "password": "rahasia123"
}
```

Response:
```json
{
  "access_token": "eyJhbGci...",
  "token_type": "bearer",
  "user_id": 1,
  "name": "Budi"
}
```

---

### 2. Login

**`POST /api/login`**

Request:
```json
{
  "email": "siswa@email.com",
  "password": "rahasia123"
}
```

Response: (sama seperti register)

---

### 3. Upload Catatan

**`POST /api/notes/upload`** — `multipart/form-data`

| Field | Type | Contoh |
|---|---|---|
| `file` | File | catatan.pdf / foto.jpg |
| `title` | String | "Catatan Fisika" |

Response:
```json
{
  "id": 1,
  "title": "Catatan Fisika",
  "filename": "abc123.pdf",
  "content_text": "Hasil OCR dari file...",
  "created_at": "2026-07-14T10:00:00"
}
```

`content_text` = teks hasil bacaan AI dari PDF/foto.

---

### 4. Daftar Catatan

**`GET /api/notes`**

Response:
```json
[
  {
    "id": 1,
    "title": "Catatan Fisika",
    "filename": "abc123.pdf",
    "content_text": "...",
    "created_at": "2026-07-14T10:00:00"
  }
]
```

---

### 5. Generate Soal

**`POST /api/notes/{note_id}/generate`**

Panggil setelah upload. AI akan bikin 5 soal berdasarkan teks catatan.

Response:
```json
{
  "message": "Soal berhasil dibuat",
  "total_questions": 5
}
```

> Kalau sudah ada soal, return pesan "Soal sudah ada". Hapus dulu atau buat catatan baru.

---

### 6. Ambil Soal

**`GET /api/notes/{note_id}/questions`**

Response:
```json
[
  {
    "id": 1,
    "question_text": "Apa rumus energi kinetik?",
    "options": [
      {"label": "A", "text": "EK = ½mv²"},
      {"label": "B", "text": "EK = mgh"},
      {"label": "C", "text": "EK = F × s"},
      {"label": "D", "text": "EK = ½kx²"}
    ]
  }
]
```

Tampilkan ke user: teks soal + 4 pilihan (radio button).

---

### 7. Submit Jawaban

**`POST /api/quiz/submit`**

Request:
```json
{
  "question_id": 1,
  "selected_answer": "A"
}
```

Response:
```json
{
  "is_correct": true,
  "correct_answer": "A",
  "explanation": "Energi kinetik dirumuskan EK = ½mv²..."
}
```

- Kalau benar: kasih tahu user, tampilkan skor nanti
- Kalau salah: tampilkan penjelasan + jawaban benar

---

### 8. Lihat Skor

**`GET /api/quiz/result/{note_id}`**

Response:
```json
{
  "total": 5,
  "correct": 3,
  "wrong": 2,
  "score": 60.0
}
```

---

### 9. Jurnal Soal Salah

**`GET /api/errors`**

Response:
```json
[
  {
    "question_id": 2,
    "question_text": "...",
    "options": [{"label": "A", "text": "..."}, ...],
    "correct_answer": "C",
    "explanation": "Karena...",
    "your_answer": "B",
    "attempted_at": "2026-07-14T11:00:00"
  }
]
```

Tampilkan di halaman "Riwayat Salah" — soal yang pernah dijawab salah.

---

### Detail Catatan

**`GET /api/notes/{note_id}`**

Response: sama seperti satu item di daftar catatan.

---

## Alur Aplikasi (v1 — 3 Halaman)

### Halaman 1 — Upload

```
[Upload PDF/Foto] → POST /api/notes/upload → dapat note_id
[Generate Soal]  → POST /api/notes/{id}/generate
[Lanjut Quiz]    → pindah halaman
```

### Halaman 2 — Quiz

```
GET /api/notes/{id}/questions  → tampilkan 5 soal (1 per 1)
User pilih jawaban → POST /api/quiz/submit
Setelah semua → GET /api/quiz/result/{note_id} → tampilkan skor
```

### Halaman 3 — Riwayat Salah

```
GET /api/errors → tampilkan daftar soal yang salah
```

---

## Catatan Teknis

- File upload maksimal 10MB
- Format didukung: PDF, JPG, PNG, WEBP
- Soal cuma bisa di-generate sekali per catatan (kalau mau ulang, buat catatan baru)
- Semua data tersimpan di SQLite (`temanbelajar.db`) — akan migrasi ke PostgreSQL di v3
- Backend berjalan di `localhost:8000`, CORS sudah allow all origins untuk development
- Dokumentasi API interaktif (Swagger): http://localhost:8000/docs
