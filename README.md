# 📚 Ekşi KazaR
🔗 **Live Demo:** [https://aliemrekaragul.shinyapps.io/eksi-kazaR/](https://aliemrekaragul.shinyapps.io/eksi-kazaR/)
**Ekşi KazaR**, *Ekşi Sözlük*'teki herhangi bir başlık altındaki içerikleri kazıyarak kelime bulutu şeklinde görselleştiren bir Shiny uygulamasıdır. Bir başlığı özet gibi görselleştirir.

## 🚀 Özellikler

- 🌐 Ekşi Sözlük’ten herhangi bir başlığı URL ile kazıma
- ☁️ Etkileşimli kelime bulutu oluşturma
- 🎨 Şekil, yakınlaştırma ve tema özelleştirme
- 🧠 Türkçe ve İngilizce stopword (önemsiz kelime) temizliği
- 📈 Çok sayfalı başlıklarda ilerleme göstergesi

## 🔧 Nasıl Çalışır?

1. *Ekşi Sözlük*’teki bir başlığın URL’sini girersin.
2. Uygulama, o başlık altındaki tüm sayfalardaki içerikleri kazır.
3. Metin temizlenir:
   - Noktalama işaretleri, sayılar ve gereksiz kelimeler kaldırılır.
   - Küçük harfe dönüştürülür.
4. Kelimelerin frekans tablosu oluşturulur.
5. Bu tablo görsel bir kelime bulutuna dönüştürülür.

## 📦 Gereksinimler

Aşağıdaki R paketlerinin kurulu olduğundan emin olun:

```r
install.packages(c(
  "shiny", 
  "rvest", 
  "dplyr", 
  "wordcloud", 
  "wordcloud2", 
  "stopwords", 
  "stringr", 
  "tm", 
  "bslib"
))
```
🌈 Arayüz
Tema: Bootstrap

Yazı Tipi: Space Mono & Roboto

📃 Lisans
MIT Lisansı © AliEmreKaragul
