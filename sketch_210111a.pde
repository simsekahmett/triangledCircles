import ddf.minim.*;

// ses çalma ile alakalı variable'lar
Minim minim; //  sesi çalacak playerımızın kodlarını içeren kütüphane (import ettiğimiz kütüphane)

//her bir renk için ayrı player tanımlıyoruz
AudioPlayer redSound;
AudioPlayer greenSound;
AudioPlayer blueSound;

//ekranda görünecek tüm hjalkaları bir liste içerisinde tutacağımız listeyi oluşturuyoruz
//listenin type'ı "Circle", liste içindeki her obje "Circle" type'ında olacak
ArrayList<Circle> circles = new ArrayList<Circle>();

//Colour class'ından 5 tane obje oluşturuyoruz,
//bunları renklendirme işlemlerimizde kullanacağız
//renklerin kodlarıyla uğraşmak yerine, direk kodlarla eşleştirdiğimiz
//renk isimleri üzerinden daha okunaklı ve kullanışlı kodlar yazmamıza yarıyor
Colour red = new Colour(#FF0000, "red");
Colour green = new Colour(#00FF00, "green");
Colour blue = new Colour(#0000FF, "blue");
Colour white = new Colour(#FFFFFF, "white");
Colour black = new Colour (#000000, "black");

//önceki kullanılan rengin indexini tutacak değer,
//başlangıçta 1 olarak başlatıyoruz
int previousColourIndex = 1;

//arkaplan rengimizi tutacak renk objesi
color backColor;

void setup() {
  // minim kütüphanesinden Minim objesi oluşturuyoruz
  // ses çalmak için kullanacağımız obje
  minim = new Minim(this);

  // minim kütüphanesinin loadfile fonksiyonunu kullanarak ses dosyalarımızı gerekli playerlarımıza yüklüyoruz
  redSound = minim.loadFile(dataPath("red.mp3"));
  greenSound = minim.loadFile(dataPath("green.mp3"));
  blueSound = minim.loadFile(dataPath("blue.mp3"));

  //500x500 tablo oluşturuyoruz, çizme ve animasyon işlemlerimizi üzerinde gerçekleştirecez
  size(500, 500);

  //ilk etapta ekranda görünecek halkaları for döngüsü ile oluşturuyoruz
  //halka kalınlıkları ve sayısını for döngümüzün azalış miktarını belirlediğimiz
  //"i -= width/10" kısmından değiştirebiliriz
  //for döngümüz (-) yönde bir döngü ve bu da bizim halkalarımızı dıştan içe doğru oluşturacak
  for (float i = width; i > 0; i -= width/10) {
    Circle circle = new Circle();
    circle.size = i;
    circle.colour = red.colourCode; //default olarak başta kırmızı renk atıyoruz

    //switch-case döngüsü ile önceki renk indeximize bakıp bir sonrakinin seçimini yapıyoruz
    switch(previousColourIndex) {
    case 1:
      circle.colour = red.colourCode;
      break;
    case 2:
      circle.colour = green.colourCode;
      break;
    case 3:
      circle.colour = white.colourCode;
      break;
    case 4:
      circle.colour = black.colourCode;
      break;
    case 5:
      circle.colour = blue.colourCode;
      break;
    case 6:
      circle.colour = white.colourCode;
    }

    //önceki renk değerimizi 1 ile 6 arasında random olarak değiştiriyoruz,
    //böylelikle halkalarımızın renkleri de sıralı bir şekilde değil,
    //random olarak oluşturulacak
    previousColourIndex = (int) random(1, 6);

    //döngü içerisinde oluşturduğumuz halkayı "circles" listemize ekliyoruz
    circles.add(circle);
  }
  background(230);
}

void draw() {
  noStroke();

  //for döngümüz ile "circles" listemize eklediğimiz halkalarımızı son eklenenden başa
  //doğru olacak şekilde ekranda çizme işlemine başlıyoruz
  for (int i = circles.size() - 1; i >= 0; i--) {
    Circle circle = circles.get(i); //i'nci halka
    Circle circleShow = circles.get(circles.size() - 1 - i); //i'den bir önceki halka

    //circleShow halkamız yani i'den bir önceki halkamızın rengine bakarak
    //arkaplan renk (diğer halkayla arasına gelecek renk) seçimini yapıyoruz
    switch(circleShow.colour) {
    case #000000: //siyah'sa, kırmızıya
      backColor = red.colourCode;
      break;
    case #0000FF: //mavi'yse, yeşile
      backColor = green.colourCode;
      break;
    case #FF0000: //kırmızı'ysa beyaza
      backColor = white.colourCode;
      break;
    case #00FF00: //yeşil'se siyaha
      backColor = black.colourCode;
      break;
    case #FFFFFF: //beyaz'sa maviye
      backColor = blue.colourCode;
      break;
    }
    fill(backColor); //boyuyoruz

    //tablomuzun orta noktası(width/2,height/2)nın 50 piksel üzerine
    //genişliği ve yüksekliği circleShow objemizin size'ı boyutlarında olan bir elips çiziyoruz 
    //(genişlik ve yükseklik eşit olduğu için halka formunda görünecek)    
    ellipse(width/2, height/2 + 50, circleShow.size, circleShow.size);

    //eğer mousea basılıysa halkaları hareket ettirip sesi çalacağız
    if (mousePressed == true)
    {
      //halkaların ilerleme hızı
      circle.size += 1;

      //eğer circle objemizin boyu 211 olursa üçgenin sol kenarına değiyor
      //sol kenarına değdiği zaman rengine göre ses çalacak
      if (circleShow.size == 211.0)
      {
        switch(backColor)
        {
        case #FF0000: //kırmızı
          redSound.play();
          break;
        case #00FF00: //yeşil
          greenSound.play();
          break;
        case #0000FF: //mavi
          blueSound.play();
          break;
        }

        //eğer ses dosyalarımız çalmıyorsa başa sarıyoruz
        //tekrardan çalabilmek için
        if (!redSound.isPlaying())
          redSound.rewind();
        if (!greenSound.isPlaying())
          greenSound.rewind();
        if (!blueSound.isPlaying())
          blueSound.rewind();
      }

      //eğer halkamızın büyüklüğü, tablo genişliğini geçerse;
      //random renkte yeni bir halka oluşturup, halkalar arrayine ekleyip,
      //eski halkayı (i'nci halka) çıkarıyoruz
      //böylelikle halkaların geçişleri arasında akışkan bir görüntü elde ediyoruz
      if (circle.size >= width) {
        Circle newCircle = new Circle();
        newCircle.size = 1;
        newCircle.colour = getDifferentColorRandomly(backColor);

        circles.add(newCircle);
        circles.remove(circle);
      }
    }//ses dosyalarını tekrar çalabilmek için başa alıyoruz
  }

  //çizeceğimiz üçgenin çizgi hat kalınlığı ve kenar çizgilerinin rengi
  strokeWeight(450);
  stroke(230);

  //üçgene renk vermiyoruz
  noFill();

  //köşe noktalarının koordinatlarını parametre olarak verip, çizme işlemini gerçekleştiriyoruz
  triangle(width/2, -350, -350, height + 150, width +375, height + 150);
}

//önceki renge bakıp random olarak yeni renk veren metod
//color type'ında obje döndürüyor 
color getDifferentColorRandomly(color currentColor) {

  //1'den 6'ya kadar random bir sayı üretiyoruz
  int roll = (int) random(1, 6);

  //default olarak mavi renkli bir obje oluşturuyoruz
  color newColor = blue.colourCode;

  //do-while döngüsü ile defaultu mavi olan objemizi,
  //random oluşturduğumuz sayıya bakarak yeni rengiyle değiştiriyoruz
  //bu döngüyü yeni renk ile fonksiyona gönderdiğimiz mevcut renk eşit olduğu
  //sürece gerçekleştiriyoruz
  do {
    switch(roll) {
    case 1:
      newColor = red.colourCode;
      break;
    case 2:
      newColor = green.colourCode;
      break;
    case 3:
      newColor = blue.colourCode;
      break;
    case 4:
      newColor = black.colourCode;
      break;
    case 5:
      newColor = white.colourCode;
      break;
    case 6:
      newColor = black.colourCode;
      break;
    }
    roll = (int) random(1, 6);
  } while (newColor == currentColor);

  //yeni rengimizi return ediyoruz
  return newColor;
}
