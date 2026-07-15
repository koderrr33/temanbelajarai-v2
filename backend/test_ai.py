"""
Test AI services — cek apakah Gemini OCR dan DeepSeek generate soal jalan.
Jalankan: python test_ai.py
"""

import os, tempfile
from config import GEMINI_API_KEY, DEEPSEEK_API_KEY


def test_deepseek():
    print("\n🧪 Test 1: DeepSeek — Generate Soal")
    if not DEEPSEEK_API_KEY or DEEPSEEK_API_KEY == "your_deepseek_api_key_here":
        print("  ❌ Skip: DEEPSEEK_API_KEY belum diisi di .env")
        return False

    from services.deepseek_service import generate_questions

    teks = """
    Ekosistem adalah sistem interaksi antara makhluk hidup dan lingkungannya.
    Komponen ekosistem terdiri dari komponen biotik (makhluk hidup) dan abiotik (tak hidup).
    Contoh komponen biotik: tumbuhan, hewan, bakteri. Contoh komponen abiotik: air, tanah, cahaya matahari.
    Dalam ekosistem terjadi rantai makanan: rumput → belalang → katak → ular → elang.
    """

    try:
        soal = generate_questions(teks, jumlah=3)
    except Exception as e:
        print(f"  ❌ Gagal: {e}")
        return False

    if not soal or len(soal) == 0:
        print("  ❌ Gagal: tidak ada soal yang dihasilkan")
        return False

    print(f"  ✅ Berhasil: {len(soal)} soal dibuat")
    for i, s in enumerate(soal, 1):
        print(f"     {i}. {s['pertanyaan'][:60]}...")
        print(f"        Jawaban: {s['jawaban']}")
        print(f"        Penjelasan: {s.get('penjelasan', '-')[:60]}...")
    return True


def test_gemini_ocr():
    print("\n🧪 Test 2: Gemini — OCR dari file gambar")
    if not GEMINI_API_KEY or GEMINI_API_KEY == "your_gemini_api_key_here":
        print("  ❌ Skip: GEMINI_API_KEY belum diisi di .env")
        return False

    from services.gemini_service import ocr_from_file

    # Buat file gambar dummy berisi teks
    try:
        from PIL import Image, ImageDraw, ImageFont
    except ImportError:
        print("  ❌ Skip: PIL tidak terinstall. Install: pip install pillow")
        return False

    img = Image.new("RGB", (400, 100), color="white")
    draw = ImageDraw.Draw(img)
    draw.text((10, 40), "Rumus fisika: F = m x a", fill="black")

    with tempfile.NamedTemporaryFile(suffix=".png", delete=False) as f:
        img.save(f.name)
        tmp_path = f.name

    try:
        teks = ocr_from_file(tmp_path, "image/png")
        if not teks or len(teks.strip()) == 0:
            print("  ❌ Gagal: teks kosong")
            return False
        print(f"  ✅ Berhasil: teks terbaca = '{teks.strip()}'")
        return True
    except Exception as e:
        print(f"  ❌ Error: {e}")
        return False
    finally:
        os.unlink(tmp_path)


def test_gemini_ocr_pdf():
    print("\n🧪 Test 3: Gemini — OCR dari PDF")
    if not GEMINI_API_KEY or GEMINI_API_KEY == "your_gemini_api_key_here":
        print("  ❌ Skip: GEMINI_API_KEY belum diisi di .env")
        return False

    from services.gemini_service import ocr_from_file

    try:
        from fpdf import FPDF
    except ImportError:
        print("  ❌ Skip: fpdf tidak terinstall. Install: pip install fpdf2")
        return False

    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=14)
    pdf.cell(200, 10, text="Hukum Newton 1: Benda cenderung mempertahankan", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(200, 10, text="keadaan diam atau gerak lurus beraturan.", new_x="LMARGIN", new_y="NEXT")

    with tempfile.NamedTemporaryFile(suffix=".pdf", delete=False) as f:
        pdf.output(f.name)
        tmp_path = f.name

    try:
        teks = ocr_from_file(tmp_path, "application/pdf")
        if not teks or len(teks.strip()) == 0:
            print("  ❌ Gagal: teks kosong")
            return False
        print(f"  ✅ Berhasil: teks terbaca = '{teks.strip()[:80]}...'")
        return True
    except Exception as e:
        print(f"  ❌ Error: {e}")
        return False
    finally:
        os.unlink(tmp_path)


if __name__ == "__main__":
    print("=" * 50)
    print("  TEMAN BELAJAR AI — TEST AI SERVICES")
    print("=" * 50)

    results = []

    results.append(("DeepSeek generate soal", test_deepseek()))
    results.append(("Gemini OCR gambar", test_gemini_ocr()))
    results.append(("Gemini OCR PDF", test_gemini_ocr_pdf()))

    print("\n" + "=" * 50)
    print("  RINGKASAN")
    print("=" * 50)
    all_ok = True
    for name, ok in results:
        status = "✅" if ok else "❌"
        print(f"  {status} {name}")
        if not ok:
            all_ok = False

    print()
    if all_ok:
        print("  🎉 Semua test passed! AI services siap dipakai.")
    else:
        print("  ⚠️  Ada test yang gagal atau di-skip. Cek .env dan koneksi internet.")
    print()
