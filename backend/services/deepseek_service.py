import json, re
from openai import OpenAI
from config import DEEPSEEK_API_KEY, DEEPSEEK_BASE_URL

client = OpenAI(api_key=DEEPSEEK_API_KEY, base_url=DEEPSEEK_BASE_URL)


def generate_questions(content_text: str, jumlah: int = 5) -> list[dict]:
    prompt = f"""Buatkan {jumlah} soal pilihan ganda (ABCD) berdasarkan teks catatan berikut.

Aturan:
- Setiap soal harus berdasarkan ISI CATATAN, bukan pengetahuan umum
- 4 opsi (A, B, C, D) dengan 1 jawaban benar
- Sertakan penjelasan kenapa jawaban itu benar

Format output JSON (harus valid):
{{
  "soal": [
    {{
      "pertanyaan": "teks pertanyaan",
      "opsi": [
        {{"label": "A", "teks": "isi opsi A"}},
        {{"label": "B", "teks": "isi opsi B"}},
        {{"label": "C", "teks": "isi opsi C"}},
        {{"label": "D", "teks": "isi opsi D"}}
      ],
      "jawaban": "A",
      "penjelasan": "penjelasan kenapa jawaban A benar"
    }}
  ]
}}

Teks catatan:
{content_text}

Keluarkan HANYA JSON, tanpa markdown, tanpa teks lain."""

    response = client.chat.completions.create(
        model="deepseek-chat",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3,
    )

    raw = response.choices[0].message.content.strip()
    match = re.search(r"\{.*\}", raw, re.DOTALL)
    if match:
        raw = match.group()
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        raw = raw.replace("```json", "").replace("```", "").strip()
        data = json.loads(raw)
    return data.get("soal", [])
